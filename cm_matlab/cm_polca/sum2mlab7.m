%@(#)   sum2mlab7.m 1.1	 03/08/19     08:46:24
%
%function s=sum2mlab7(sumfil,startrec)
%
% default startrec = 1
function s=sum2mlab7(sumfil,startrec)
if nargin<2, startrec=1;end
fid=fopen(expand(sumfil,'dat'),'r','b');
ind=fread(fid,100,'int32');
if ind(100)~=921106
  fclose(fid);
  fid=fopen(expand(sumfil,'dat'),'r','l');
  ind=fread(fid,100,'int32');
end
s=zeros(200,ind(1));
for i=1:ind(1)
  fseek(fid,(i-1)*800+1600,-1);
  rec=fread(fid,200,'float32');
  s(:,i)=rec;
end
