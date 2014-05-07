function dist2comp7(distfil,run)
%
% dist2comp7(distfil,run)
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

[dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfil);

if length(findstr(staton,'1'))>0, iden='F1';end
if length(findstr(staton,'2'))>0, iden='F2';end
if length(findstr(staton,'3'))>0, iden='F3';end

% Check that distibutions from the HISTORY family are saved on distribution file.
historydist=upper({'BURNUP','BURSID','BURCOR','DNSHIS','CRHIS','CRHFRC','CREIN',...
'CREOUT','EFPH','U235','U236','U238','Np239','Pu239','Pu240','Pu241','Pu242',...
'Am241','Am242','Ru103','Rh103','Rh105','Ce143','Pr143','Nd143',...
'Nd147','Pm147','Pm148','Pm148m','Pm149','Sm147','Sm149','Sm150',...
'Sm151','Sm152','Sm153','Eu153','Eu154','Eu155','Gd155','BAeff','CREFPH',...
'CRDEPL','CRFLUE','PRMEFPH','PRMU234','PRMU235','BOXEFPH','BOXFLU'});
hashist=zeros(length(historydist),1);
for i=1:length(historydist)
  hashist(i)=any(strcmpi(historydist(i),distlist));
end
hashist=all(hashist);

% check source file
if isempty(dir(soufil))
  disp(['Source file could not be found:' 10 soufil 10 ...
  'Please, edit comp-file manually: ' cfil])
end

fprintf(fid,'TITLE    %s\n',rubrik);
fprintf(fid,'SOUFIL   %s\n',soufil);
fprintf(fid,'PRIFIL   print.lis\n');
fprintf(fid,'IDENT    %s\n',iden);
fprintf(fid,'OPTION   POWER,TLOWP,CBH,HOLDXE,RAMONA\n');
if hashist
  fprintf(fid,'INIT     %s =HISTORY,IODINE,XENON\n',distfil);
else
  fprintf(fid,'INIT     %s =IODINE,XENON\n',distfil);
  fprintf(fid,'INIT     ????? =HISTORY\n',distfil);
  disp(['HISTORY could not be found on file:' 10 distfil 10 ...
  'Please, edit comp-file manually: ' cfil])
end
fprintf(fid,'PRINT    POWER=2\n');
fprintf(fid,'SAVE     %s =POWER,HISTORY,BASIC,CHFLOW,FLWWC,\n',savfil);
fprintf(fid,'SAVE  *     VOID,IODINE,XENON,LEKBP2,LEKBP3\n');
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
fprintf(fid,'POWER     %4.1f\n',hy(11)*100);
fprintf(fid,'FLOW      %6i\n',round(hy(2)));
fprintf(fid,'PRESS     %4.1f\n',70.0);
fprintf(fid,'TLOWP     %6.2f\n',hy(14));
fprintf(fid,'END      \n');
fclose(fid);
if run>0,
  disp(['polca ',cfil]);
  eval(['!polca ',cfil]);
end
%@(#)   dist2comp.m 1.2   98/08/17     15:56:57
