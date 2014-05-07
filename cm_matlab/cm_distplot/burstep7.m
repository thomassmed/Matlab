%@(#)   burstep7.m 1.6	 07/03/09     10:16:37
%
function burstep7(proc)
xsave=[];
if nargin==0,proc='bg';end
hval=get(gcf,'userdata');
load sim/simfile
efph=str2num(get(hval(21),'string'));
point=find(efph==blist);
tx=readtextfile('templ/comp-ref7.sim');
stx=size(tx);
if point<=size(filenames,1)
  tx(1,:)=setstr(32*ones(1,stx(2)));
  tx(1,1:38)=sprintf('%s%5.0f%s%5.0f%s','TITLE     Burnup case',blist(point),' -',blist(point+1),' EFPH');
  row=bucatch('OPTION',tx(:,1:6));
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:35)='OPTION    BURNUP,TLOWP,NOPOWEND,CBH';
  row=bucatch('INIT',tx(:,1:4));
  if length(row)>1,row=row(1);end
  p=find(tx(row,:)=='=');
  if point==1
    inifil=bocfile;
  else
    inifil=filenames(point-1,:);
  end
  [d,mminj,konrod]=readdist7(inifil);
  lf=length(inifil);
  ford=tx(row,p+1:stx(2));
  li=length(ford);
  stx=size(tx);
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:li+lf+12)=sprintf('%s%s%s','INIT      ',inifil,' =',ford);
  row=bucatch('SAVE',tx(:,1:4));
  if length(row)>1,xsave=tx(row(2),:);row=row(1);end
  p=find(tx(row,:)=='=');
  ford=tx(row,p+1:stx(2));
  li=length(ford);
  savfil=filenames(point,:);
  lf=length(savfil);
  linit=length(inifil);
  tx(row,1:li+lf+12)=sprintf('%s%s%s','SAVE      ',savfil,' =',ford);
  row=row+1;
  if ~isempty(xsave),tx(row,1:length(xsave))=xsave; row=row+1;end
  row=bucatch('POWER',tx(:,1:5));
  ll=length(pow(1,:));
  stx=size(tx);
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:11+ll)=sprintf('%s%s','POWER      ',pow(point,:));
  row=bucatch('FLOW',tx(:,1:4));
  ll=length(hc(1,:));
  tx(row,1:11+ll)=sprintf('%s%s','FLOW       ',hc(point,:));
  row=bucatch('TLOWP',tx(:,1:5));
  ll=length(tlowp(1,:));
  tx(row,1:11+ll)=sprintf('%s%s','TLOWP      ',tlowp(point,:));
  mvec=mgrp2vec(mangrpfile);
  row=bucatch('CONROD',tx(:,1:6));
  j=[0 find(conrod(point,:)==',') length(conrod(point,:))+1];
  k=find(conrod(point,:)=='=');
  g=[];
  w=[];
  konrod=100*ones(size(konrod));
  for ii=1:length(k)
    g=[g str2num(conrod(point,j(ii)+1:k(ii)-1))];
    w=[w str2num(conrod(point,k(ii)+1:j(ii+1)-1))];
    r=find(mvec==g(ii));
    konrod(r)=w(ii)*ones(1,length(r));
  end
  ascmap=crwd2ascmap(konrod,mminj,size(tx,2));
  stx=size(tx);
  sa=size(ascmap);
  if stx(2)<size(ascmap,2),tx=[tx setstr(32*ones(stx(1),sa(2)-stx(2)))];end
  tx=[tx(1:row,:); ascmap;tx(row+1:stx(1),:)];
  row=bucatch('BURNUP',tx(:,1:6));
  bustep=sprintf('%5.0f',blist(point+1)-blist(point));
  stx=size(tx);
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:18)=sprintf('%s%s%s','BURNUP     ',bustep,',1');
  writxfile('off/comp-bur7.txt',tx);
  if strcmp(proc,'bg');!polca off/comp-bur7.txt&
  else !polca off/comp-bur7.txt
  end
%  prestep7('fwd');
else error('No burnup step done (Last simulation point)');
end
