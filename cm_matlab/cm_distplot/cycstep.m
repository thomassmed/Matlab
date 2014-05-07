%@(#)   cycstep.m 1.13	 00/10/06     12:38:39
%
function cycstep
load simfile
tx=readtextfile('comp-ref.sim');
stx=size(tx);
tx(1,:)=setstr(32*ones(1,stx(2)));
tx(1,1:41)=sprintf('%s%5.0f%s%5.0f%s','TITLE      Burnup case ',blist(1),' - ',blist(2),' EFPH');
row=bucatch('OPTION',tx(:,1:6));
tx(row,:)=setstr(32*ones(1,stx(2)));
tx(row,1:29)='OPTION    BURNUP,TLOWP,NPOEND';
row=bucatch('INIT',tx(:,1:4));
if length(row)>1,row=row(1);end
p=find(tx(row,:)=='=');
inifil=bocfile;
savfil=filenames(1,:);
lf=length(inifil);
ford=tx(row,p+1:stx(2));
stx=size(tx);
tx(row,:)=setstr(32*ones(1,stx(2)));
tx(row,1:lf+31)=sprintf('%s%s%s','INIT      ',inifil,' = BURNUP,BUIDNT,EFPH');
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
row=bucatch('PROSIM',tx(:,1:6));
ll=0;
ll=length(pow(1,:));
ll=ll+length(hc(1,:));
ll=ll+length(tlowp(1,:));
stx=size(tx);
tx(row,:)=setstr(32*ones(1,stx(2)));
tx(row,1:26+ll)=sprintf('%s%s%s%s%s%s','PROSIM     ',pow(1,:),...
', ',hc(1,:),', 70.0, 0.3, ',tlowp(1,:));
row=bucatch('CONROD',tx(:,1:6));
j=find(conrod(1,:)==',');
for i=stx(1):-1:row,tx(i+1,:)=tx(i,:);end
stx=size(tx);
con=conrod(1,:);
if length(j)>6
  for i=stx(1):-1:row,tx(i+1,:)=tx(i,:);end
  xcon=con(j(6)+1:length(con));
  con=con(1:j(6));
end
row=row+1;
rad=sprintf('%s%s','CONROD*    ',con);
lrod=length(rad);
tx(row,1:lrod)=rad;
if length(j)>6
  lrod=length(xcon);
  tx(row+1,1:11+lrod)=sprintf('%s%s','CONROD*    ',xcon);
end
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
  tx(row,1:20)='CONROD     1-73=100,';
  row=row+1;
  con=conrod(i,:);
  j=find(con==',');
  if length(j)>6
    xcon=con(j(6)+1:length(con));
    con=con(1:j(6));
  end
  rad=sprintf('%s%s','CONROD*    ',con);
  lrod=length(rad);
  tx(row,1:lrod)=rad;
  if length(j)>6
    row=row+1;
    rad=sprintf('%s%s','CONROD*    ',xcon);
    lrod=length(rad);
    tx(row,1:lrod)=rad;
  end
  row=row+1;
  bustep=sprintf('%5.0f',blist(i+1)-blist(i));
  tx(row,1:18)=sprintf('%s%s%s','BURNUP     ',bustep,',1');
  row=row+1;
  l1=length(pow(i,:));
  l2=length(hc(i,:));
  l3=length(tlowp(i,:));
  tx(row,1:26+l1+l2+l3)=sprintf('%s%s%s%s%s','PROSIM     ',pow(i,:),', ',hc(i,:),', 70.0, 0.3, ',tlowp(i,:));
  row=row+1;
  tx(row,1:3)='END';
end
writxfile('comp-sim.txt',tx);
!polca4 comp-sim.txt&
