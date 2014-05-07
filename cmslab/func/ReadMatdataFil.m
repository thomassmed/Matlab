function varargout=ReadMatdataFil(filename,kpunktname)
% ReadMatdataFil - Läser den binära mätdatorfilen på F1/F2
% 
% dstruct=ReadMatdataFil(filename)
% [data,signaler,beskrivning]=ReadMatdataFil(filename)
% kpunkt=ReadMatdataFil(filename,kpunktname)
%
% Input: 
%   filename - Filnamn
%
% Output: 
%  Alternativ 1 (om 1 utargument finns i anropet)
%   dstruct  - Struct med fields 'beskrivning', 'signaler', 'data', tid(exakt)
%  Alternativ 2 (2 eller 3 utargument i anropet)
%   data        - Matris med data, första kolumnen innehåller tid
%   signaler    - Beskrivning av signaler
%   beskrivning - Datum mm om mätningen
%  Alternativ 3 (1 utargument, 2 inargument)
%   kpunkt      - Data för specificerad k-punkt
%
% Exempel
%  dstruct=ReadMatdataFil('PI608Mavareglerp_2012-10-01_08_000.dat');
%  hc=ReadMatdataFil('PI608Mavareglerp_2012-10-01_08_000.dat','211K035');
%
% See also: plotmat, racsread, ReadKpunkt

% Written: Thomas Smed 2012-10-02

[pathstr,name,ext]=fileparts(filename);
if strcmp(ext,'.dat')
fid=fopen(filename);
%% Examine the filehead
fseek(fid,0,-1);
filehead=fread(fid,200)';
nl=find(filehead==10);
filnamn=filehead(nl(1)+1:nl(2)-1);
fseek(fid,nl(2),-1);
nin=fread(fid,12,'int');
pos=ftell(fid);
fseek(fid,0,1);
newfile=1;
eof=ftell(fid);
if eof~=nin(10), 
    if eof==nin(6),
        newfile=0;
    else
        error('File is corrupt');
    end
end
fseek(fid,pos,-1);
if ~newfile, fseek(fid,-4,0);pos=pos-4;end
test=fread(fid,30)';
%%
inext=findstr([255 255 255 255],test);
fseek(fid,pos+inext(1)+3,-1);
pos=ftell(fid);
test=fread(fid,20)';
i0=find(test==0);
if isempty(i0), i0=10;end
etikett=char(test(1:i0(1)-1));
if newfile,
    islut= strfind(test,[255 255 255]);
    if ~isempty(islut)
        islut=islut(end);
        fseek(fid,pos+islut+6,-1);   
    else
        fseek(fid,4,0);
    end
    ints=fread(fid,5,'int');
    iadr=ints(5);
else
    iadr=fread(fid,1,'int');
end
%% The date and time is stored here, in int16!!! Save no effort ta spare a couple of bytes!!!
tid=fread(fid,8,'int16');
%% Move to the 'register' close to the end of the file
fseek(fid,iadr,-1);
inum=fread(fid,4,'int');
nmeas=inum(2);
anum=fread(fid,1,'float'); % Something with start time?
for i=1:5,
    itest=fread(fid,1,'int');
    if itest==(-1), break;end
end
sigs=cell(nmeas+1,1);
datasize=zeros(nmeas,1);
dataadr=zeros(nmeas,1);
len=dataadr;beskadr=len;Tsms=len;
for i=1:nmeas
    temp=fread(fid,16)';
    ii=min(find(temp==0),17);
    temp=temp(1:ii(1)-1);
    sigs{i+1}=char(temp);
    ints=fread(fid,8,'int');
    datasize(i)=ints(8);
    Tsms(i)=fread(fid,1,'float'); % Sample time (individual for each signal?) i ms?
    if newfile,
        ints=fread(fid,8,'int');
        beskadr(i)=ints(2);
        len(i)=ints(3);
        dataadr(i)=ints(5);
    else
        ints=fread(fid,5,'int');
        beskadr(i)=ints(1);
        len(i)=ints(2);
        dataadr(i)=ints(3);
    end
end
%%
Ts=Tsms(1)/1000;
N=max(datasize);
t=0:Ts:(N-1)*Ts;t=t';
if nargin==2
    flag=false;
    if strcmpi(kpunktname,'t'), flag=true; end
    if strcmpi(kpunktname,'tid'), flag=true; end
    if strcmpi(kpunktname,'time'), flag=true; end
    if flag
        varargout{1}=t;
        fclose(fid);
        return;
    end
end    
%%
data=zeros(max(datasize),nmeas+1);
beskr=cell(nmeas+1,1);units=beskr;
istart=1;istop=nmeas;
if nargin==2,
    istart=find(strncmp(kpunktname,sigs,length(kpunktname)))-1;
    istop=istart;
end

for i=istart:istop,
    fseek(fid,dataadr(i),-1);
    data(1:datasize(i),i+1)=fread(fid,datasize(i),'float');
    fseek(fid,2,0);
    temp=char(fread(fid,len(i)-2)');
    i0=find(temp==0);
    i0=i0(end-1:end);
    units{i+1}=temp(i0(1)+1:i0(2)-1);
    beskr{i+1}=temp(1:i0(1)-1);
end
fclose(fid);
if nargin==2,
    varargout{1}=data(:,istart+1);
    return;
end
%%
beskr{1}='Relativ tid';
units{1}='s';
sigs{1}=     'Tid';
sigrad1= 'Nr  NAME             UNIT   Lowlimit     Highlimit    Gain         COMMENTS';
sigrad2='++  ++++             ++++   ++++++++     +++++++++    ++++         +++++++++ ';
data(:,1)=t;
spc=char(32*ones(nmeas+1,1));
spc10=char(32*ones(nmeas+1,12));
nr=char(32*ones(nmeas+1,3));
lolim=cell(nmeas+1,1);hilim=lolim;
for i=1:nmeas+1
    nr(i,:)=sprintf('%-3i',i);    % Rev MAD %3i -> %-3i
    lolim{i}=sprintf('%g',min(data(:,i)));
    hilim{i}=sprintf('%g',max(data(:,i)));
end

beskrivning=cell(7,1);
beskrivning{1}=['Datum           : ',datestr(datenum(tid(1),tid(2),tid(4),tid(5),tid(6),tid(7)+tid(8)/1000),31)];
beskrivning{2}=['Etikett         : 1 - ',etikett];
beskrivning{3}= 'Antal mätningar : 1';
beskrivning{4}=['Antal signaler  : ',sprintf('%i',nmeas+1)];
beskrivning{5}=['Antal Sampel    : ',sprintf('%i',N)];
beskrivning{6}=['Samplingstid    : ',sprintf('%g',Ts)];
beskrivning{7}=['Fil             : ',char(filnamn)];
% Rev MAD 121008: Tog bort ett mellanslag innan semikolon för att efterlikna
% tidigare format

% Se nu till att signaler ser ut som den brukar (ifall den används
% progammatiskt för annat)
gain=char(49*ones(nmeas+1,1));

lolim=char(lolim);
hilim=char(hilim);
sigs=char(sigs);
units=char(units);

for i=1:16,     % Rev MAD: Ändrar loopen från 5 till 16. Missar storlek på sigs då endast korta signalnamn finns i filen
    if size(hilim,2)<12, hilim=[hilim spc];end
    if size(lolim,2)<12, lolim=[lolim spc];end
    if size(sigs,2)<16, sigs=[sigs spc];end
    if size(units,2)<6, units=[units spc];end
end  

% Rev MAD: Tog bort ett spc som fanns med i utskriften av misstag samt tog bort onödig char-konvertering.
signaler=[nr spc sigs spc units spc lolim spc hilim spc gain spc10 char(beskr)];
siglen=length(signaler(1,:));
if siglen<100   % Rev MAD: Om antalet signalkolumner < 100, padda med blanksteg
    signaler=[signaler,char(32*ones(nmeas+1,100-siglen))];
end

signaler=signaler(:,1:100); % Rev MAD: Gammalt format var maximerat till 100 kolumner
signaler=char([cellstr(sigrad1);cellstr(sigrad2);cellstr(signaler)]);

else
    load(filename);
    tid=[];
end

% Ta bort bottnade värden nedåt
% TODO: fixa samma sak för bottnade värden uppåt när det dyker upp
isat=find(min(data)<-1e37);
for i=1:length(isat),
    bot=data(:,isat(i))<-1e37;
    val=min(data(~bot,isat(i)));
    data(bot,isat(i))=val;
end

if nargout<2,
    dstruct.beskrivning=char(beskrivning);
    dstruct.signaler=signaler;
    dstruct.data=data;
    dstruct.tid=tid;
    varargout{1}=dstruct;
elseif nargout==2,
    varargout{1}=data;
    varargout{2}=signaler;
elseif nargout==3,
    varargout{1}=data;
    varargout{2}=signaler;
    varargout{3}=char(beskrivning);
elseif nargout==4,
    varargout{1}=data;
    varargout{2}=signaler;
    varargout{3}=char(beskrivning);
    varargout{4}=sigs;
elseif nargout==5,
    varargout{1}=data;
    varargout{2}=signaler;
    varargout{3}=char(beskrivning);
    varargout{4}=sigs;
    varargout{5}=beskr;
else
    warning('Only 1, 2, 3, 4 or 5 output arguments are supported');
end


