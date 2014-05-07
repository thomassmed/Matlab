function [soufil]=get_soufil(filename);

if nargin >0
  filename=deblank(filename);
end


fid=fopen(expand(filename,'dat'),'r','b');
ind=fread(fid,50,'int32');
if ind(1)~=1
  fclose(fid);
  fid=fopen(expand(filename,'dat'),'r','l');
  ind=fread(fid,50,'int32');
end


fseek(fid,4*ind(28)-4,-1);
soufil=remblank(setstr(fread(fid,80))');

fclose(fid);
