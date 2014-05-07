function nrodh=read_no_pins(libfile,resfile,knum)
% read_no_pin  Reads the number of heated pins per node from library file
% nrodh=read_no_pins(libfile,resfile,knum)
% or:
% nrodh=read_no_pins(libfile,fue_new,knum)
%

%%
if isstruct(resfile) % take care of fue_new, resinfo or filename as input
    if max(strcmp('core',fieldnames(resfile)))
        % resinfo
        resinfo = resfile;
        dat = ReadRes(resinfo,{'LIBRARY','DIMS'},1);
        fue_new = catstruct(dat.library,dat.resinfo.core);

    else
      % fue_new
      fue_new = resfile;
    end

elseif ischar(resfile)
      % filename
        resinfo = ReadRes(resfile,'full');
        dat = ReadRes(resinfo,{'LIBRARY','DIMS'},1);
        fue_new = catstruct(dat.library,dat.resinfo.core);
end

if nargin<3, knum=1:size(fue_new.kan); end
[segmnt,segpos,nseg,niseg]=read_cdfile(libfile);

w1=fue_new.Seg_w{1};w1=w1(:,knum);
w2=fue_new.Seg_w{2};w2=w2(:,knum);
cseg=fue_new.Core_Seg{1}(:,knum);
cseg2=fue_new.Core_Seg{2}(:,knum);
csegtot=[cseg(:);cseg2(:)];
seg_list=unique(csegtot);ibort=find(seg_list==0);seg_list(ibort)=[];
nrodh=zeros(size(cseg));nrodt=nrodh;nrodh2=nrodh;nrodt2=nrodh;
fid=fopen(libfile,'r','ieee-be');
%%
i_int=get_length(fid,'int');
Nrodt=zeros(length(seg_list),1);
Nrodh=Nrodt;
for i=1:length(seg_list),
    iseg_i=strmatch(deblank(fue_new.Segment(seg_list(i),:)),cellstr(segmnt),'exact');
    iseg(i)=iseg_i(end);
    ii=find(niseg{iseg(i)}(1,:)==91);
    fseek(fid,segpos(iseg(i),ii)+5*i_int,-1);   
    rec=fread(fid,12,'int');
%    libadf(i,1:8)=rec(1:8)';
%    munits(i)=rec(9);
%    iffuel(i)=rec(10);
    Nrodh(i)=rec(11);
%    Nrodt(i)=rec(12);
    ii=find(cseg==seg_list(i));  
    nrodh(ii)=Nrodh(i);
%    nrodt(ii)=Nrodt(i);
    ii=find(cseg2==seg_list(i));  
    nrodh2(ii)=Nrodh(i);
%    nrodt2(ii)=Nrodt(i);
end
nrodh=w1.*nrodh+w2.*nrodh2;
%nrodt=w1.*nrodt+w2.*nrodt2;
fclose(fid);

%%   
    
function iform=get_length(fid,form)     % Find length of format
cur_pos=ftell(fid);
dum=fread(fid,1,form);
new_pos=ftell(fid);
iform=new_pos-cur_pos;
fseek(fid,cur_pos-new_pos,0);
    
         