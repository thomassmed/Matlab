%@(#)   crseq.m 1.3	 05/12/08     13:18:32
%
%Script that writes several patterns to file
%function crseq(filvec,outfile)
function crseq(filvec,outfile)
if nargin==1,outfile='print.txt';end
id=size(filvec,1);
fid=fopen(outfile,'w');
for i=1:id
  distfil=remblank(filvec(i,:));
  [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfil);
  fprintf(fid,' %s',rubrik);
  fprintf(fid,'\n');
  crpat2fil(konrod,mminj,fid);
  fprintf(fid,'\n\n\n');
  if fix(i/3)==(i/3),fprintf(fid,'1');fprintf(fid,'\n');end
end
