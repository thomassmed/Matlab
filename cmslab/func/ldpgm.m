function m=ldpgm(file)
% m=ldpgm(file)
fid=fopen(file);
str=fgetl(fid);
str=fgetl(fid);
str=fgetl(fid);
i=find(str==' ');
x=str2num(deblank(str(1:i)));
y=str2num(deblank(str((i+1):length(str))));
fgetl(fid);
for n=1:y,
  m(n,1:x)=fscanf(fid,'%3d',x)';
end  
fclose(fid);
