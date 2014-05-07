%@(#)   burstep.m 1.10	 00/10/06     12:37:29
%
function burstep(proc)
if nargin==0,proc='bg';end
hval=get(gcf,'userdata');
load simfile
efph=str2num(get(hval(6),'string'));
point=find(efph==blist);
tx=readtextfile('comp-ref.sim');
stx=size(tx);
if point<size(filenames,1)
  tx(1,:)=setstr(32*ones(1,stx(2)));
  tx(1,1:38)=sprintf('%s%5.0f%s%5.0f%s','TITLE     Burnup case',blist(point),' -',blist(point+1),' EFPH');
  row=bucatch('OPTION',tx(:,1:6));
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:29)='OPTION    BURNUP,TLOWP,NPOEND';
  row=bucatch('INIT',tx(:,1:4));
  if length(row)>1,row=row(1);end
  p=find(tx(row,:)=='=');
  if point==1
    inifil=bocfile;
  else
    inifil=filenames(point-1,:);
  end
  lf=length(inifil);
  ford=tx(row,p+1:stx(2));
  li=length(ford);
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
  stx=size(tx);
  row=bucatch('PROSIM',tx(:,1:6));
  ll=0;
  ll=length(get(hval(3),'string'));
  ll=ll+length(get(hval(4),'string'));
  ll=ll+length(get(hval(5),'string'));
  stx=size(tx);
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:26+ll)=sprintf('%s%s%s%s%s%s','PROSIM     ',get(hval(5),'string'),...
  ', ',get(hval(4),'string'),', 70.0, 0.3, ',get(hval(3),'string'));
  row=bucatch('CONROD',tx(:,1:6));
  j=find(get(hval(1),'string')==',');
  for i=stx(1):-1:row,tx(i+1,:)=tx(i,:);end
  stx=size(tx);
  con=get(hval(1),'string');
  if length(j)>6
    for i=stx(1):-1:row,tx(i+1,:)=tx(i,:);end
    xcon=con(j(6)+1:length(con));
    con=con(1:j(6));
  end
  row=row+1;
  lrod=length(con);
  tx(row,1:11+lrod)=sprintf('%s%s','CONROD*    ',con);
  if length(j)>6
    lrod=length(xcon);
    tx(row+1,1:11+lrod)=sprintf('%s%s','CONROD*    ',xcon);
  end
  row=bucatch('BURNUP',tx(:,1:6));
  bustep=sprintf('%5.0f',blist(point+1)-blist(point));
  stx=size(tx);
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:18)=sprintf('%s%s%s','BURNUP     ',bustep,',1');
  writxfile('comp-bur.txt',tx);
  if strcmp(proc,'bg');!polca4 comp-bur.txt&
  else !polca4 comp-bur.txt
  end
  prestep('fwd');
else error('No burnup step done (Last simulation point)');
end
