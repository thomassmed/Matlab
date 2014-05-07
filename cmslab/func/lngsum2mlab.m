%@(#)   lngsum2mlab.m 1.2	 03/12/10     13:43:56
%
%function [logdata,status]=lngsum2mlab(filename)
function [logdata,status]=lngsum2mlab(filename)
fid=fopen(expand(filename,'dat'),'r','b');

%%% Öppna filen och kolla om den har little eller big endian %%%
ind=fread(fid,50,'int32');
if ind(8)~=1
  fclose(fid);
  fid=fopen(expand(filename,'dat'),'r','l');
  ind=fread(fid,50,'int32');
  if ind(8)~=1, error(['Unable to open file ' filname]), end
end

fseek(fid,0,-1);
nrec=fread(fid,1,'int32');

fseek(fid,1156*4,-1);
for i=1:nrec-34
%  fseek(fid,1156*4+(i-1)*34*4,-1);
  for j=1:6
    logdata(j,i)=fread(fid,1,'int32');
  end
  for j=7:32
    logdata(j,i)=fread(fid,1,'float32');
  end
  for j=1:2
    tmp(j)=fread(fid,1,'int32');
  end
  for j=1:16
    status(j,i)=bitand(tmp(1),3);
    tmp(1)=bitshift(tmp(1),-2);
  end
  for j=17:25
    status(j,i)=bitand(tmp(2),3);
    tmp(1)=bitshift(tmp(2),-2);
  end
end

fclose(fid);
