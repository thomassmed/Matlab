%@(#)   printshfmod.m 1.1	 02/06/03     14:50:54
%
%function printshfmod(fid,SHFM,mminj)
function printshfmod(fid,SHFM,mminj)
lc=length(mminj)/2;
corsize=lc+1-mminj;
fprintf(fid,'SHFMOD\n');
for i=1:2*lc,
  fprintf(fid,'ROW    ');
  if i<10, fprintf(fid,' ');end
  fprintf(fid,'%.0f',i);
  fprintf(fid,' /');
  ii=2*corsize(i);
  if ii<14,
   for j=16-corsize(i):14+corsize(i), fprintf(fid,'%.2f,',SHFM(i,j));end
   j=15+corsize(i);
   fprintf(fid,'%.2f',SHFM(i,j));
  elseif ii<27,
   for j=16-corsize(i):28-corsize(i), fprintf(fid,'%.2f,',SHFM(i,j));end
   fprintf(fid,'\n');
   fprintf(fid,'ROW   *    ');
   for j=29-corsize(i):14+corsize(i), fprintf(fid,'%.2f,',SHFM(i,j));end
   j=15+corsize(i);
   fprintf(fid,'%.2f',SHFM(i,j));
  else
   for j=16-corsize(i):28-corsize(i), fprintf(fid,'%.2f,',SHFM(i,j));end
   fprintf(fid,'\n');
   fprintf(fid,'ROW   *    ');
   for j=29-corsize(i):41-corsize(i), fprintf(fid,'%.2f,',SHFM(i,j));end
   fprintf(fid,'\n');
   fprintf(fid,'ROW   *    ');
   for j=42-corsize(i):14+corsize(i), fprintf(fid,'%.2f,',SHFM(i,j));end
   j=15+corsize(i);
   fprintf(fid,'%.2f',SHFM(i,j));
  end
  fprintf(fid,'/');
  fprintf(fid,'\n');
end
diary off
