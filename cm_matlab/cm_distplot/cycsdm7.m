%@(#)   cycsdm7.m 1.8	 06/05/22     13:58:18
%
function cycsdm7
load sim/simfile
s=size(filenames);
if length(bocfile)<s(2),bocfile=[bocfile setstr(32*ones(1,s(2)-length(bocfile)))];end
if length(bocfile)>s(2),filenames=[filenames setstr(32*ones(s(1),length(bocfile)-s(2)))];end
s=size(filenames);
filenames=[bocfile; filenames];
for i=1:size(filenames,1)-1
  tx=readtextfile('templ/comp-sdm-ref7.sim');
  stx=size(tx);
  tx(1,:)=setstr(32*ones(1,stx(2)));
  tx(1,1:25)=sprintf('%s%5.0f%s','TITLE      SDM ',blist(i),' EFPH');
  row=bucatch('INIT',tx(:,1:4));
  fil=filenames(i,:);
  lf=length(fil);
  stx=size(tx);
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:lf+26)=sprintf('%s%s%s%s','INIT      ',fil,' = HISTORY,BASIC');
  row=bucatch('SAVE',tx(:,1:4));
  fil=sdmfiles(i,:);
  lf=length(fil);
  stx=size(tx);
  tx(row,:)=setstr(32*ones(1,stx(2)));
  tx(row,1:lf+27)=sprintf('%s%s%s','SAVE      ',fil,' = SDM,SDM3D,EFPH');
  writxfile('off/comp-sdm7.txt',tx);
  if exist('polcacmd')
    system([polcacmd ' off/comp-sdm7']);
  else
    !polca off/comp-sdm7
  end
end
