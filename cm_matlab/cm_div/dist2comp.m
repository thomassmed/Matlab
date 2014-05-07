function dist2comp(distfil,run)
%
% dist2comp(distfil,run)
%
% Creates a complementfile from a distribution file
%

if nargin<2, run=0;end
cfil=strip(distfil);
i=findstr(cfil,'.dat');
if length(i)>0,
  cfil=cfil(1:i-1);
end
savfil=[cfil,'_all.dat'];
cfil=['comp-',cfil,'.txt'];
fid=fopen(cfil,'W');

[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfil);
if length(findstr(staton,'1'))>0, iden='F1,  F1-OFF';end
if length(findstr(staton,'2'))>0, iden='F2,  F2-OFF';end
if length(findstr(staton,'3'))>0, iden='F3,  F3-OFF';end




fprintf(fid,'TITLE    %s\n',rubrik);
fprintf(fid,'MASFIL   %s\n',masfil);
fprintf(fid,'PRIFIL   print.lis\n');
fprintf(fid,'IDENT    %s\n',iden);
fprintf(fid,'OPTION   POWER,TLOWP,HOLDXE\n');
fprintf(fid,'ITERA    15, 10, 0.4, 0.985 ,0.982, 0.85, 0.85, 0.85, 0.85,0.00448,0.5\n');
fprintf(fid,'INIT     %s =BURNUP,IODINE,XENON\n',distfil);
fprintf(fid,'PRINT    POWER=2\n');
fprintf(fid,'SAVE     %s =BURN,EFPH,VHI,SSHI,POWER,XENON,IODINE,VOID,\n',savfil);
fprintf(fid,'SAVE  *     FLEAK1,FLEAK2,FLOWB1,FLOWB2,CHFLOW,FUEROD,BUNTYP\n');
fprintf(fid,'SUMFIL    \n');
fprintf(fid,'CONRODJALIST      \n');
[map,mpos]=cr2map(konrod,mminj);
n=1;
for i=1:max(mpos(:,1)),
   for j=1:mpos(n,2)-1
     fprintf(fid,'    ');
   end
   while mpos(n)==i,  
     fprintf(fid,'%4i',round(konrod(n)/10));
     n=n+1;
   end
   fprintf(fid,'\n');
end
fprintf(fid,'PROSIM    %4.1f,%6i,%4.1f,%4.1f,%6.2f\n',hy(11)*100,round(hy(2)),70.0,0.3,hy(14));
fprintf(fid,'END      \n');
fclose(fid);
if run>0,
  disp(['polca ',cfil]);
  eval(['!polca ',cfil]);
end
