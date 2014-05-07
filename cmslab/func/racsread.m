function [description,signals,data,lab,unt,lolim,hilim,gain] = racsread(filename,kpunktname)
% racsread - Reads racs files 
% 
% ds = racsread(racsfile)
% [description,signals,data,lab,unt,lolim,hilim,gain] = racsread(racsfile)
% kpunkt=racsread(racsfile,kpunktname)
%
% Input: 
%   racsfile - filename on racs file
%   k-punkt  - k-punkt name
%
% Output:
%  With one input and one outpcut:
%   ds          - Struct with various info
%  With one input and several outputs
%   description - General description
%   signals     - Signal information
%   data        - Data matrix, first column is time
%   lab         - Cell array of labels for signals
%   unt         - Physical unit
%   lolim       - Lower limit
%   hilim       - Upper limit
%   gain        - Gain for signal as stored on file (integer)
%
%  With two inputs and one output:
%   kpunkt      - Data for specified k-punkt
%
% Example:
%   ds=racsread('DIST-2027.racs');
%
% See also plotmat, ReadMatdataFil

% Written 2014-04-28 Thomas Smed

%%
fid=fopen(filename,'r','ieee-be');
%%
datum=fread(fid,3,'uint16')';
if datum(1)<1800||datum(2)<1||datum(2)>12||datum(3)<1||datum(3)>31,
    description=[];
    warning(['File ',filename,' seems to be corrupt']);
    fclose(fid);
    return
end
titel=char(fread(fid,20)');
i1=fread(fid,52,'uint16');
NoV=i1(1);
dt=0.005*i1(2);
x1=ReadOneRacsFloat(fid);
Nsamp=round(x1);
if nargin==2
    flag=false;
    if strcmpi(kpunktname,'t'), flag=true; end
    if strcmpi(kpunktname,'tid'), flag=true; end
    if strcmpi(kpunktname,'time'), flag=true; end
    if flag
        description=(0:dt:(Nsamp-1)*dt)';
        fclose(fid);
        return;
    end
end
i2=fread(fid,1,'uint16');
lab1=strtrim(char(fread(fid,200)'));
lab1=strrep(lab1,'\','Ö');
lab1=strrep(lab1,']','Å');
lab1=strrep(lab1,'[','Ä');
%%
lab=cell(NoV+1,1);
unt=lab;
lolim=zeros(NoV+1,1);
hilim=lolim;
gain=lolim;
gain(1)=1;
id=lolim;
lab{1}='Tid';
unt{1}='s';
for i=1:NoV
    str=strrep(char(fread(fid,20)'),'\','Ö');
    str=strrep(str,']','Å');
    lab{i+1}=strrep(str,'[','Ä');
    lolim(i+1)=ReadOneRacsFloat(fid);
    hilim(i+1)=ReadOneRacsFloat(fid);
    gain(i+1)=ReadOneRacsFloat(fid);
    unt{i+1}=strtrim(char(fread(fid,10)'));
    id(i+1)=fread(fid,1,'uint16');
end
%% Read the data, signed integer*16
fseek(fid,8192,-1);
tid=fread(fid,3,'uint16');
tid=tid(3:-1:1);
idatv=fread(fid,NoV*Nsamp,'int16');
fclose(fid);
if length(idatv)<NoV*Nsamp,
    warning('Padding with zeros. Racs-file may be corrupt');
    idatv=[idatv;zeros(NoV*Nsamp-length(idatv),1)];
end

idatm=reshape(idatv,NoV,Nsamp)';
data=zeros(Nsamp,NoV+1);
data(:,1)=(0:dt:(Nsamp-1)*dt)';
sc=2^15-1;
for i=2:NoV+1    % Kolla hur gain ska komma in
    data(:,i)=gain(i)*idatm(:,i-1)/sc*(hilim(i)-lolim(i))+lolim(i);
end

if nargin==2,
    description=data(:,strncmp(kpunktname,lab,length(kpunktname)));
    return
end
    

%%
if any(abs(gain-1)>1e-4),
    disp('gain~=1:')
    find(abs(gain-1)>1e-4)
end

%%
description=32*ones(1,250);
description([50 100 150 200 250])=10;
description(1:18)='Datum           : ';
description(19:22)=sprintf('%i',datum(1));
mm=sprintf('%i',datum(2));
if length(mm)==1, 
    mm=['-0',mm];
else
    mm=['-',mm];
end

dd=sprintf('%i',datum(3));
if length(dd)==1, 
    dd=['-0',dd'];
else
    dd=['-',dd];
end

description(23:28)=sprintf('%s',mm,dd);
hh=sprintf('%2i',tid(1));hh=strrep(hh,' ','0');
mm=sprintf('%2i',tid(2));mm=strrep(mm,' ','0');
ss=sprintf('%2i',tid(3));ss=strrep(ss,' ','0');
tidstr=[hh,':',mm,':',ss];
description(30:37)=tidstr;


description(51:68)='Etikett         : ';
description(69:88)=titel;
description(101:119)='Antal mätningar : 1'; % Hårdkodat t.v.
description(151:168)='Antal signaler  : ';
nsig=sprintf('%i',NoV+1);
description(169:168+length(nsig))=nsig;
description(201:218)='Antal sampel    : ';
if Nsamp>9999
    description(219:223)=sprintf('%5i',Nsamp);
else
    description(219:222)=sprintf('%4i',Nsamp);
end

description=char(description);

signals=32*ones(1,100*(NoV+3));

signals(100:100:end)=10;

signals(1:75)='Nr  NAME             UNIT   Lowlimit     Highlimit    Gain         COMMENTS';
signals(101:175)='++  ++++             ++++   ++++++++     +++++++++    ++++         ++++++++';
signals(201:229)='1   tid              s      0';
if data(Nsamp,1)<10000
    signals(242:249)=sprintf('%8.3f',data(Nsamp,1));
else
    signals(242:249)=sprintf('%8.2f',data(Nsamp,1));
end
signals(268:270)='Tid';

for i=2:NoV+1,
    ns=sprintf('%i',i);
    istart=100*(i+1);
    signals(istart+1:istart+length(ns))=ns;
    lstr=sprintf('%g',lolim(i));
    signals(istart+29:istart+28+length(lstr))=lstr;
    hstr=sprintf('%g',hilim(i));
    signals(istart+42:istart+41+length(hstr))=hstr;
    gstr=sprintf('%g',gain(i));
    signals(istart+55:istart+54+length(gstr))=gstr;
    isp=find(lab{i}==32,1,'first');
    if isempty(isp), 
        isp=18;
        irest=18;
    elseif isp>18,
        isp=18;
        irest=isp;
    else
        irest=isp+1;
    end
    shtit=lab{i}(1:isp-1);
    signals(istart+5:istart+3+isp)=shtit;
    lotit=strtrim(lab{i}(irest:end));
    signals(istart+68:istart+67+length(lotit))=lotit;
    signals(istart+22:istart+21+length(unt{i}))=unt{i};
end

signals=char(signals);

if nargout==1,
    cr=find(description==10);
    Nd=length(cr);
    desc=cell(Nd+2,1);
    desc{1}=strtrim(description(1:cr(1)-1));
    for i=2:Nd
        desc{i}=strtrim(description(cr(i-1)+1:cr(i)-1));
    end
    desc{Nd+1}=['Samplingstid    : ',sprintf('%g',dt)];
    if exist('file','file'),
        filn=file('normalize',filename);
    else
        filn=filename;
    end
    desc{Nd+2}=['Fil             : ',filn];    
    ds.beskrivning=char(desc);
    sig=char(32*ones(NoV+3,86));
    for i=1:NoV+3, 
        istart=(i-1)*100;
        sig(i,1:86)=signals(istart+1:istart+86);
    end
    ds.signaler=sig;
    ds.data=data;
    ds.tid=[datum(:);tid(:)];
    ds.lab=lab;
    ds.lolim=lolim;
    ds.hilim=hilim;
    ds.gain=gain;
    ds.unit=unt;
    ds.lab1=lab1;
    ds.id=id;
    description=ds;
end




