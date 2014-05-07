%@(#)   newpolca7.m 1.1	 05/12/08     10:16:39
%
%@(#)   newpolca7.m 1.1   03/08/06     15:07:26
%
function keff=newpolca7(nextgr,compwork,distfil,nrad)
fid=fopen(compwork,'r+');
for i=1:nrad,
  rad=fgetl(fid);
end
fseek(fid,0,0);
fprintf(fid,'CONROD*  %3i=100\nEND\n',nextgr);
fclose(fid);
eval(['!polca ',compwork]);
[dist,mminj,konrod,bb]=readdist7(distfil);
keff=bb(96);
