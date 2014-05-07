%@(#)   sdmcyc.m 1.8	 00/10/06     13:11:10
%
function sdmcyc
load simfile
s=size(filenames);
if length(bocfile)<s(2),bocfile=[bocfile setstr(32*ones(1,s(2)-length(bocfile)))];end
if length(bocfile)>s(2),filenames=[filenames setstr(32*ones(s(1),length(bocfile)-s(2)))];end
s=size(filenames);
filenames=[bocfile; filenames];
for i=1:size(filenames,1)-1
  tx=readtextfile('comp-sdm-ref.sim');
  stx=size(tx);
  tx(1,:)=setstr(32*ones(1,stx(2)));
  tx(1,1:25)=sprintf('%s%5.0f%s','TITLE      SDM ',blist(i),' EFPH');
  row=bucatch('INIT',tx(:,1:4));
  fil=filenames(i,:);
  lf=length(fil);
  stx=size(tx);
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:lf+19)=sprintf('%s%s%s%s','INIT      ',fil,' = BURNUP');
  row=bucatch('SAVE',tx(:,1:4));
  fil=filenames(i+1,:);
  lf=length(fil);
  stx=size(tx);
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:lf+23)=sprintf('%s%s%s','SAVE      ',fil,' = SDM,KEFSDM');
  writxfile('comp-sdm.txt',tx);
  !polca4 comp-sdm
end
