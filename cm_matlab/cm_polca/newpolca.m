%@(#)   newpolca.m 1.4	 06/04/23     11:43:24
%
%function keff=newpolca(nextgr,compwork,distfil,nrad)
function keff=newpolca(nextgr,compwork,distfil,nrad)
fid=fopen(compwork,'r+');
for i=1:nrad,
  rad=fgetl(fid);
end
fseek(fid,0,0);
fprintf(fid,'CONROD*  %3i=100\nEND\n',nextgr);
fclose(fid);
neumodel=polca_version(distfil);
if strcmp(neumodel,'POLCA4'),
  polca='!polca4 ';
else
  polca='!polca ';
end
eval([polca,compwork]);
[dist,mminj,konrod,bb]=readdist(distfil);
keff=bb(96);
