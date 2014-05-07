function [cnames,keffP,keffM,dra,fda]=stabtable(fnames);

% [cnames,keffP,keffM,dr,fd]=stabtable(fnames);
% sammanställer resultaten från matstabfiler
% exempel stabtable('dis*ned.mat')
%         stabtable({'stab1.mat','stab2.mat'})
 
if ~iscell(fnames)
  fnames=expand(fnames,'mat');
  d=dir(fnames);
  [filelist{1:length(d),1}]=deal(d.name);
else
  filelist=fnames;
end


s=['Case                  keff,P   keff,M    dr    fd   '
   '---------------------+--------+--------+-----+-----+'];
   
for i=1:length(filelist)
  try
    r=load(filelist{i},'stab','steady','msopt');
  catch
    error(['Could not read MATSTAB file :', 10, filelist{i}])
  end
  if ~(isfield(r,'stab') & isfield(r,'steady'))
    error(['Not a MATSTAB file :' 10 filelist{i}])
  end 
  f_polca=r.msopt.DistFile;
  [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist(f_polca);
  len=length(f_polca);
  maxbredd=20;
  s1=ones(1,maxbredd+1)*' ';
%  isep=(find(r.f_polca==filesep));
%  iisep=find(len-isep-1-4<maxbredd);
%  cname=r.f_polca(isep(min(iisep))+1:len-4);
  [dum,cname]=fileparts(f_polca);
  clen=min(maxbredd,length(cname));
  s1(1:clen)=cname(1:clen);
%  s1(1:min(13,len))=r.f_polca(max(len-16,1):end-4);
  s1=char(s1);
  lam=r.stab.lam;
  [dr,fd]=p2drfd(lam);
  Cnames{i}=cname; 
  keffP(i)=bb(51);
  keffM(i)=r.steady.keff;
  dra(i)=dr;
  fda(i)=fd;
  s2=sprintf(' %1.5f  %1.5f  %1.3f %1.3f  ',keffP(i),keffM(i),dr,fd);
  s=strvcat(s,[s1,s2]);
end
s=strvcat(s,' ');
if nargout>0
 cnames=Cnames;
else
 disp(s)
end
