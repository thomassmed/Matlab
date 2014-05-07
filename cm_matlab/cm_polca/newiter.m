%@(#)   newiter.m 1.2	 98/09/10     10:03:57
%
function newiter(nextgr,compwork,nrad)
fid=fopen(compwork,'r+');
for i=1:nrad,
  rad=fgetl(fid);
end
fseek(fid,0,0);
fprintf(fid,'CONROD*  %3i=100,\n',nextgr);
fclose(fid);
end
