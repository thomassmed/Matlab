%@(#)   kinf2mlab.m 1.4	 97/11/05     12:23:03
%
%function kinf=kinf2mlab(distfile,option,masfile,void,vikt)
%Available options '3D','BURC','NOBURC' or 'AUTBURC'.
%Default 2D, NOBURC
%If masfile='DISTMASTER' then MASFIL from distfile is used. (Default)
function kinf=kinf2mlab(distfile,option,masfile,void,vikt);
if nargin<5
  vikt=[0.55 0.97 1.17 1.21 1.25 1.24 1.21 1.17 1.17 1.15 ...
  1.12 1.08 1.08 1.07 1.05 1.01 1.01 1.00 0.97 0.93 0.90 0.84 0.75 0.62 0.47];
end
if nargin<4
  void=0.5;
end
if nargin<3
  masfile='DISTMASTER';
end
if nargin<2
  bcsw=0;
end
dsw=0;
if nargin>1
  option=upper(option);
  if strcmp(option,'3D'),dsw=1;option='AUTBURC';end
  if strcmp(option,'BURC'),bcsw=1;end
  if strcmp(option,'NOBURC'),bcsw=0;end
  if strcmp(option,'AUTBURC')
    [d,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
    distlist,staton,masfil,rubrik,detpos,fu]=readdist(distfile);
    if ~isempty(bucatch('BURC',distlist(:,1:4)))
      bcsw=1;
    else
      bcsw=0;
    end
  end
end
if isempty(find(distfile=='.')),distfile=sprintf('%s%s',distfile,'.dat');end
f=fopen(distfile);
if f==-1,fprintf('No such file %s\n',distfile);break;end
fclose(f);
if ~strcmp(masfile,'DISTMASTER')
  if isempty(find(masfile=='.'));masfile=sprintf('%s%s',masfile,'.dat');end
  f=fopen(masfile);
  if f==-1,fprintf('No such file %s\n',masfile);break;end
  fclose(f);
end
kinf=getkinf(distfile,bcsw,dsw,masfile,void,vikt);
%bcsw: switch for burc(1) or not burc(0)
%dsw:  switch for 3dkinf(1) or 2dkinf(0)
