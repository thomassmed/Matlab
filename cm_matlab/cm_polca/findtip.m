%@(#)   findtip.m 1.4	 05/12/08     10:31:35
%
%function distfil=findtip(direc)
% finds all files named tip-??????.dat on the specified directory,
% checks that they are distribution-files and sorts them in 
% order of ascending average burnup. Default for direc is
% current working directory.
% Example: tipfiles=findtip('/cm/f3/c8/dist');
function distfil=findtip(direc)
dirr=path;
i=find(dirr==':');
dirr=dirr(1:i(1)-1);
if nargin==0,
  [ierr,direc]=unix('pwd');
  direc=direc(1:length(direc)-1);
end
if strcmp(direc(length(direc)),'/'),
  tempfil=[direc,'tempfil.lis'];
else
  tempfil=[direc,'/tempfil.lis'];
end
gotipdat=['!',dirr,'/tipdate ',direc,' > ',tempfil];
eval(gotipdat);
fid=fopen(tempfil,'r');
i=1;
s=fscanf(fid,'%s',1);
while ~strcmp(s,'');
  distfil(i,:)=s;
  i=i+1;
  s=fscanf(fid,'%s',1);
end
fclose(fid);
remtemp=['!rm ',tempfil];
eval(remtemp);
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
