%@(#)   crmult2fil.m 1.3	 05/12/08     10:31:35
%
%Script that writes several patterns to file
distfiles=findfile(direc,'distr-*.dat');
id=size(distfiles,1);
fid=fopen('utskrift.txt','w');
for i=1:id
  distfil=distfiles(i,:);j=find(abs(distfil)==0);distfil(j)='';
  j=find(abs(distfil)==32);distfil(j)='';
  [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfil);
  fprintf(fid,' %s',rubrik);% Eller vad du nu vill
  fprintf(fid,'\n');
  crpat2fil(konrod,mminj,fid);
  fprintf(fid,'\n\n\n');
  if fix(i/3)==(i/3),fprintf(fid,'1');fprintf(fid,'\n');end
end
