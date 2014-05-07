function NodalCode=polca_version(distfil)
txt=findstr(distfil,'.txt');
fid=fopen(distfil,'r','b');
a=fread(fid,50,'int');
if a(1)~=1
  fclose(fid);
  fid=fopen(distfil,'r','l');
  a=fread(fid,50,'int32');
end
if length(a)>49,
  if a(50)==12348,
    NodalCode='POLCA4';
 elseif a(50)==92348,
    NodalCode='POLCA7';
  else
    NodalCode='UNKNOWN';
  end
else
    NodalCode='UNKNOWN';  
end
fclose(fid);
