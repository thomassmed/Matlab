%@(#)   powstep.m 1.10	 00/10/06     12:36:48
%
function powstep(proc)
if nargin==0,proc='bg';end
hval=get(gcf,'userdata');
load simfile
%i=find(filenames(1,:)=='/');
%block=filenames(1,i(3)+1:i(4)-1);
efph=str2num(get(hval(6),'string'));
point=find(efph==blist);
tx=readtextfile('comp-ref.sim');
stx=size(tx);
tx(1,:)=setstr(32*ones(1,stx(2)));
tx(1,1:30)=sprintf('%s%5.0f%s','TITLE     Power case',blist(point),' EFPH');
row=bucatch('OPTION',tx(:,1:6));
tx(row,:)=setstr(32*ones(1,stx(2)));
tx(row,1:21)='OPTION    POWER,TLOWP';
row=bucatch('INIT',tx(:,1:4));
if length(row)>1,row=row(1);end
p=find(tx(row,:)=='=');

% las bocfilel om point==1
if (point == 1)
  fil=bocfile;
else
  fil=filenames(point-1,:);
end;

lf=length(fil);
ford=tx(row,p+1:stx(2));
li=length(ford);
tx(row,1:li+lf+12)=sprintf('%s%s%s','INIT      ',fil,' =',ford);
row=bucatch('SAVE',tx(:,1:4));
if length(row)>1,row=row(1);end
p=find(tx(row,:)=='=');
ford=tx(row,p+1:stx(2));
li=length(ford);

% spara pa distfilen
fil=filenames(point,:);
lf=length(fil);

tx(row,1:li+lf+12)=sprintf('%s%s%s','SAVE      ',fil,' =',ford);
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
  tx(row+1,:)=setstr(32*ones(1,size(tx,2)));
  tx(row+1,1:11+lrod)=sprintf('%s%s','CONROD*    ',xcon);
end
row=bucatch('BURNUP',tx(:,1:6));
tx(row,:)=[];
writxfile('comp-pow.txt',tx);
%if strcmp(block,'r1')
%  !/home/prog/pbtmp/cm/codes/941010/polca/bin/polca comp-pow.txt&
%end
%if strcmp(block,'f1')|strcmp(block,'f2')|strcmp(block,'f3')
%  !polca comp-pow.txt&
%end
if strcmp(proc,'bg')
  !polca4 comp-pow.txt&
end
if strcmp(proc,'fg')
  !polca4 comp-pow.txt
end
