%@(#)   readcomp.m 1.3	 05/12/08     10:31:36
%
function [MANGRP,mangrp,crut,crantal,distfil,nrad,ierr]=readcomp(compfile,compwork)
if nargin<2, compwork='comp-slask.txt';end
fut=fopen(compwork,'w');
fid=fopen(compfile,'r');
nrad=0;
rad=fgetl(fid);nrad=nrad+1;
fprintf(fut,'%s\n',rad);
while ~strcmp(upper(rad(1:4)),'SAVE')
  rad=fgetl(fid);nrad=nrad+1;
  fprintf(fut,'%s\n',rad);
end
[A,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%s',1);
rad=rad(NEXTINDEX:length(rad));
[distfil,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%s',1);
i=find(distfil=='=');
if length(i)>0, distfil=distfil(1:i-1); end
rad=fgetl(fid);nrad=nrad+1;
fprintf(fut,'%s\n',rad);
while ~strcmp(upper(rad(1:4)),'MANG')
  rad=fgetl(fid);nrad=nrad+1;
  fprintf(fut,'%s\n',rad);
end
[d,mminj]=readdist7(distfil);
nc=floor(length(mminj)/2);
mgrp=[];
for i=1:nc
  rad=fgetl(fid);nrad=nrad+1;
  fprintf(fut,'%s\n',rad);
  [n,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%i',nc);  
  mgrp=[mgrp;n];
end
mgrp=sort(mgrp);
i=find([-99999;diff(mgrp);99999]);
crantal=diff(i)';
i=i(1:length(i)-1);
MANGRP=mgrp(i)';
rad=fgetl(fid);nrad=nrad+1;  % Antar att denna rad ar CONROD 1-100=0
fprintf(fut,'%s\n',rad);
ierr=0;
fircon='CONROD   1-100=0,';
if length(rad)<17,
  ierr=1;
elseif length(rad)>18,
  rslut=remblank(rad(18:length(rad)));
  if length(rslut)>0, ierr=1;end
elseif ~strcmp(upper(rad(1:17)),fircon),
  ierr=1;  
else
  mangrp=100;
  crut=0;
end
if ierr==0,
  slutflag=0;
  while ~strcmp(upper(rad(1:3)),'END'),
    rad=fgetl(fid);nrad=nrad+1;
    rrad=rad;
    if slutflag>0, break;end
    if ~strcmp(upper(rad(1:4)),'COMM'),
      [n,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%s',1);
      rad=rad(NEXTINDEX:length(rad));
      rad=remblank(rad);
      i=find(rad=='=');i1=find(rad==',');i1=[0 i1];
      if max(i)>max(i1), slutflag=1;i1=[i1 length(rad)+1];rrad=[rrad,','];end
      for j=1:length(i),
        mangrp=[mangrp sscanf(rad(i1(j)+1:i(j)-1),'%i',1)];
        crut=[crut sscanf(rad(i(j)+1:i1(j+1)-1),'%i',1)];
      end
    end
    fprintf(fut,'%s\n',rrad);
  end
else
  disp(['Error in ',compfile]);
  disp(rad);
  disp('This row MUST be:')
  disp(fircon);
end
nrad=nrad-1;
fclose(fut);
fclose(fid);
