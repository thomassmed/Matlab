function neumodel=polca_version(distfil)
fid=fopen(distfil,'r','b');
a=fread(fid,50,'int');
if a(1)~=1
  fclose(fid);
  fid=fopen(distfil,'r','l');
  a=fread(fid,50,'int32');
end
if length(a)>49,
  if a(50)==12348,
    neumodel='POLCA4';
  elseif a(50)==92348,
    neumodel='POLCA7';
  else
    neumodel='UNKNOWN';
  end
else
  neumodel='UNKNOWN';  
end

