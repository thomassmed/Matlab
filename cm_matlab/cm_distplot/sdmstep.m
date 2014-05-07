%@(#)   sdmstep.m 1.10	 00/10/06     12:38:10
%
function sdmstep
hval=get(gcf,'userdata');
load simfile
%i=find(filenames(1,:)=='/');
%block=filenames(1,i(3)+1:i(4)-1);
efph=str2num(get(hval(6),'string'));
point=find(efph==blist);
tx=readtextfile('comp-sdm-ref.sim');
stx=size(tx);
tx(1,:)=setstr(32*ones(1,stx(2)));
tx(1,1:28)=sprintf('%s%5.0f%s','TITLE     SDM case',blist(point),' EFPH');
row=bucatch('INIT',tx(:,1:4));
if length(row)>1,row=row(1);end
p=find(tx(row,:)=='=');

% Lottas fix - las bocfilel om point==1
if (point == 1)
  fil=bocfile;
else
  fil=filenames(point-1,:);
end;

lf=length(fil);
ford=tx(row,p+1:stx(2));
li=length(ford);
stx=size(tx);
tx(row,:)=setstr(32*ones(1,stx(2)));
tx(row,1:li+lf+12)=sprintf('%s%s%s%s','INIT      ',fil,' =',ford);
row=bucatch('SAVE',tx(:,1:4));
if length(row)>1,row=row(1);end
stx=size(tx);
tx(row,:)=setstr(32*ones(1,stx(2)));

% spara alltid resultatet pa aktuell utbranningspunkt
fil=filenames(point,:);
lf=length(fil);

tx(row,1:lf+23)=sprintf('%s%s%s','SAVE      ',fil,' = SDM,KEFSDM');
writxfile('comp-sdm.txt',tx);
%if strcmp(block,'r1')
%  !/home/prog/pbtmp/cm/codes/941010/polca/bin/polca comp-sdm.txt&
%end
%if strcmp(block,'f1')|strcmp(block,'f2')|strcmp(block,'f3')
%  !polca comp-sdm.txt&
%end
!polca4 comp-sdm&
