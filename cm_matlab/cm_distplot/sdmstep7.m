%@(#)   sdmstep7.m 1.6	 06/05/22     13:59:11
%
function sdmstep7
hval=get(gcf,'userdata');
load sim/simfile
efph=str2num(get(hval(21),'string'));
point=find(efph==blist);
tx=readtextfile('templ/comp-sdm-ref7.sim');
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
sdmfil=sdmfiles(point,:);

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
%fil=filenames(point,:);
lf=length(sdmfil);

tx(row,1:lf+27)=sprintf('%s%s%s','SAVE      ',sdmfil,' = SDM,SDM3D,EFPH');
writxfile('off/comp-sdm7.txt',tx);

if exist('polcacmd')
  system([polcacmd ' off/comp-sdm7']);
else
  !polca off/comp-sdm7
end