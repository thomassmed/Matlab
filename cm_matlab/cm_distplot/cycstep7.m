%@(#)   cycstep7.m 1.5	 05/03/16     13:52:03
%
function cycstep7(option)
if nargin<1, option='BURNUP,TLOWP,NOPOWEND,CBH';end
load sim/simfile
[dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(bocfile);
mvec=mgrp2vec(mangrpfile);
xsave=[];
tx=readtextfile('templ/comp-ref7.sim');
stx=size(tx);
tx(1,:)=setstr(32*ones(1,stx(2)));
tx(1,1:41)=sprintf('%s%5.0f%s%5.0f%s','TITLE      Burnup case ',blist(1),' - ',blist(2),' EFPH');
row=bucatch('OPTION',tx(:,1:6));
tx(row,:)=setstr(32*ones(1,stx(2)));
%tx(row,1:44)='OPTION    BURNUP,TLOWP,NOPOWEND,CBH,NOCRDEPL';
tx(row,1:10+length(option))=['OPTION    ' option];
row=bucatch('INIT',tx(:,1:4));
if length(row)>1,row=row(1);end
p=find(tx(row,:)=='=');
inifil=bocfile;
savfil=filenames(1,:);
lf=length(inifil);
ford=tx(row,p+1:stx(2));
stx=size(tx);
tx(row,:)=setstr(32*ones(1,stx(2)));
tx(row,1:lf+26)=sprintf('%s%s%s','INIT      ',inifil,' = HISTORY,BASIC');
row=bucatch('SAVE',tx(:,1:4));
if length(row)>1,xsave=tx(row(2),:);row=row(1);end
p=find(tx(row,:)=='=');
ford=tx(row,p+1:stx(2));
li=length(ford);
lf=length(savfil);
linit=length(inifil);
tx(row,1:stx(2))=setstr(32*ones(1,stx(2)));
tx(row,1:li+lf+12)=sprintf('%s%s%s%s','SAVE      ',savfil,' =',ford);
row=row+1;
if ~isempty(xsave),tx(row,1:length(xsave))=xsave; row=row+1;end
row=bucatch('POWER',tx(:,1:5));
ll=length(pow(1,:));
stx=size(tx);
tx(row,:)=setstr(32*ones(1,stx(2)));
tx(row,1:11+ll)=sprintf('%s%s','POWER      ',pow(1,:));
row=bucatch('FLOW',tx(:,1:4));
ll=length(hc(1,:));
tx(row,1:11+ll)=sprintf('%s%s','FLOW       ',hc(1,:));
row=bucatch('TLOWP',tx(:,1:5));
ll=length(tlowp(1,:));
tx(row,1:11+ll)=sprintf('%s%s','TLOWP      ',tlowp(1,:));
row=bucatch('CONROD',tx(:,1:6));
j=[0 find(conrod(1,:)==',') length(conrod(1,:))+1];
k=find(conrod(1,:)=='=');
g=[];
w=[];
konrod=100*ones(size(konrod));
for ii=1:length(k)
  g=[g str2num(conrod(1,j(ii)+1:k(ii)-1))];
  w=[w str2num(conrod(1,k(ii)+1:j(ii+1)-1))];
  r=find(mvec==g(ii));
  konrod(r)=w(ii)*ones(1,length(r));
end
ascmap=crwd2ascmap(konrod,mminj,size(tx,2));
stx=size(tx);
sa=size(ascmap);
if stx(2)<size(ascmap,2),tx=[tx setstr(32*ones(stx(1),sa(2)-stx(2)))];end
tx=[tx(1:row,:); ascmap;tx(row+1:stx(1),:)];
row=bucatch('BURNUP',tx(:,1:6));
stx=size(tx);
bustep=sprintf('%5.0f',blist(2)-blist(1));
tx(row,:)=setstr(32*ones(1,stx(2)));
tx(row,1:18)=sprintf('%s%s%s','BURNUP     ',bustep,',1');
for i=2:size(filenames,1)
  stx=size(tx);
  row=bucatch('END',tx(:,1:3));
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:41)=sprintf('%s%5.0f%s%5.0f%s','TITLE      Burnup case ',blist(i),' - ',blist(i+1),' EFPH');
  l1=size(filenames,2);
  l2=length(ford);
  row=row+1;
  tx(row,1:13+l1+l2)=sprintf('%s%s%s%s','SAVE       ',filenames(i,:),' =',ford);
  row=row+1;
  if ~isempty(xsave),tx(row,1:length(xsave))=xsave; row=row+1;end
  tx(row,1:6)='CONROD';
  con=conrod(i,:);
  j=[0 find(con==',') length(con)+1];
  k=find(con=='=');
  g=[];
  w=[];
  konrod=100*ones(size(konrod));
  for ii=1:length(k)
    g=[g str2num(con(j(ii)+1:k(ii)-1))];
    w=[w str2num(con(k(ii)+1:j(ii+1)-1))];
    r=find(mvec==g(ii));
    konrod(r)=w(ii)*ones(1,length(r));
  end
  ascmap=crwd2ascmap(konrod,mminj,size(tx,2));
  stx=size(tx);
  sa=size(ascmap);
  if stx(2)<size(ascmap,2),tx=[tx setstr(32*ones(stx(1),sa(2)-stx(2)))];end
  tx=[tx(1:row,:); ascmap];
  row=row+size(ascmap,1)+1;
  bustep=sprintf('%5.0f',blist(i+1)-blist(i));
  tx(row,1:18)=sprintf('%s%s%s','BURNUP     ',bustep,',1');
  row=row+1;
  l1=length(pow(i,:));
  tx(row,1:11+l1)=sprintf('%s%s','POWER      ',pow(i,:));
  row=row+1;
  l1=length(hc(i,:));
  tx(row,1:11+l1)=sprintf('%s%s','FLOW       ',hc(i,:));
  row=row+1;
  tx(row,1:15)=sprintf('%s','PRESS      70.0');
  row=row+1;
  tx(row,1:15)=sprintf('%s','XCU            ');
  row=row+1;
  tx(row,1:15)=sprintf('%s','TABLE       0.3');
  row=row+1;
  l1=length(tlowp(i,:));
  tx(row,1:11+l1)=sprintf('%s%s','TLOWP      ',tlowp(i,:));
  row=row+1;
  tx(row,1:3)='END';
end
writxfile('off/comp-sim7.txt',tx);
if exist('polcacmd')
  system([polcacmd ' off/comp-sim7.txt']);
else
  !polca off/comp-sim7.txt
end