%@(#)   findfile.m 1.4	 05/12/08     10:31:35
%
%function distfil=findfile(direc,file)
% finds all files named file on the specified directory,
% checks that they are distribution-files and sorts them in 
% order of ascending average burnup. Default for direc is
% current working directory.
% Example: tipfiles=findfile('/cm/f3/c8/dist','distr-*');
% If no file is specified, default is 'tip-??????.dat'
function distfil=findfile(direc,file)
dirr=path;
i=find(dirr==':');
dirr=dirr(1:i(1)-1);
if nargin==0
  [ierr,direc]=unix('pwd');
  direc=direc(1:length(direc)-1);
  file='tip-??????.dat';
end
if nargin==1
  file=direc;
  direc=pwd;
end
direc=remblank(direc);
ld=length(direc);
if abs(direc(ld))==10,
  ld=ld-1;direc=direc(1:ld);
end
if strcmp(direc(ld),'/'),
  file=[direc,file];
else
  file=[direc,'/',file];
end
lsstr=['ls ',file];
[ierr,dfil]=unix(lsstr);
iret=find(abs(dfil)==10);
maxi=length(iret);
iret=[0 iret];
maxj=max(diff(iret))-1;
distfil=32*ones(maxi,maxj);
for i=1:maxi
  distfil(i,1:iret(i+1)-iret(i)-1)=dfil(iret(i)+1:iret(i+1)-1);
end
% Check that all files are distribution-files
ld=size(distfil,1);
ifel=[];
burn=zeros(ld,1);
for i=1:ld
  fil=distfil(i,:);id=find(fil==' ');fil(id)='';
  [burnup,mminj]=readdist7(fil,'burnup');
  if mminj(1)<0,
    ifel=[ifel;i];
  else
    burn(i)=mean(mean(burnup));
  end
end
distfil(ifel,:)='';
burn(ifel)=[];
[y,isort]=sort(burn);
distfil=distfil(isort,:);
