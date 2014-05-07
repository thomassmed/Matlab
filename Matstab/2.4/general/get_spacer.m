function [vhspx,rhspx,zsp,ispac]=get_spacer(spacer_p7,f_master,buntyp)
% [vhspx,rhspx,zsp,ispac]=get_spacer(spacer_p7,f_master,buntyp)

fid=fopen(spacer_p7,'r');
file = fread(fid);
po=[0;find(file==10)];


mz=mast2mlab(f_master,5,'I');
ntot=mz(29);

i=1;
while ~strcmp(setstr(file(po(i)+1:po(i)+6)'),'SPACER'),
  i=i+1;
end


ityp=1;

BUNT=zeros(ntot,ntot*4);BUNT=setstr(BUNT);
lspmax=1;

for i0=1:ntot,
  bunt= sscanf(setstr(file(po(i)+7:po(i+1)-1)'),'%s');
  ib=find(bunt=='=');
  while isempty(ib),
    i=i+1;
    bunt=[bunt sscanf(setstr(file(po(i)+8:po(i+1)-1)'),'%s')];
    ib=find(bunt=='=');
  end

  ikom=find(bunt(1:ib-1)==',');
  ikom=[0 ikom ib];
  for ii=1:length(ikom)-1
    BUNT(ityp,(ii-1)*4+1:ii*4)=sprintf('%4s',bunt(ikom(ii)+1:ikom(ii+1)-1));
  end
  sp_data=sscanf(bunt(ib+1:length(bunt)),'%f,');
  i=i+1;
  if i>length(po)-1, break;end
  rad=setstr(file(po(i)+1:po(i+1)-1));rad=rad(:)';
  if length(rad)<7, rad=[rad,'       '];end
  while ~(strcmp(rad(1:6),'SPACER')&~strcmp(rad(7),'*')),
     if strcmp(rad(1:7),'SPACER*')
        sp_data=[sp_data;sscanf(rad(8:length(rad)),'%f,')];
     end
     i=i+1;
     if i>length(po)-1, break;end
     rad=setstr(file(po(i)+1:po(i+1)-1));rad=rad(:)';
     if length(rad)<7, rad=[rad,'       '];end
  end
  lsp=length(sp_data)/5;
  zspx(ityp,1:lsp)=sp_data(3:5:5*lsp)';
  rhsp(ityp,1:lsp)=sp_data(5:5:5*lsp)';
  vhsp(ityp,1:lsp)=-sp_data(4:5:5*lsp)'./1e5.^rhsp(ityp,1:lsp);
  if lsp>lspmax, lspmax=lsp; end
  if i>length(po)-1, break;end
  ityp=ityp+1;
end
zspx=zspx(1:ityp,1:lspmax);
vhsp=vhsp(1:ityp,1:lspmax);
rhsp=rhsp(1:ityp,1:lspmax);
bu=abs(BUNT);
for i1=size(BUNT,2):-1:5,
  if~any(abs(BUNT(:,i1))), BUNT(:,i1)=[];end
end
BUNT(ityp+1:size(BUNT,1),:)=[];

[zspxsort,izspx]=sort(zspx(:));
pos=find(round(1e4*diff(zspxsort)));
pos=pos(:);
if zspxsort(1)==0, 
  pos=pos+1; 
end

zsp=zspx(izspx(pos)); 
zsp=zsp(:);
if max(round(max(zsp)*1e4))<max(round(max(zspxsort)*1e4)),
   zsp=[zsp;max(zspxsort)];
end

ispac=length(zsp);

ntyp=size(buntyp,1);
vhspx=zeros(ntyp,ispac);
rhspx=vhspx;


ityp2=size(BUNT,2);
for i1=1:size(BUNT,1), 
  Bunt=reshape(BUNT(i1,:)',4,ityp2/4)';
  ibu=mbucatch(buntyp,Bunt);
  ibu=find(ibu);
  lsp=length(find(zspx(i1,:)));
  for i2=1:lsp,
    [dum,iz]=min(abs(zspx(i1,i2)-zsp));
    vhspx(ibu,iz)=ones(size(ibu))*vhsp(i1,i2);
    rhspx(ibu,iz)=ones(size(ibu))*rhsp(i1,i2);
  end
end  
zsp=zsp/100;

% check if any buntyp is missing
no_spacer=find(sum(vhspx,2)==0);
no_spacer=buntyp(no_spacer,:);
if ~isempty(no_spacer)
  bunt=[];
  i1=0;
  while ~isempty(no_spacer); 
    i1=i1+1;
    bunt(i1,:)=no_spacer(1,:);
    i2=strmatch(bunt(i1,:),no_spacer);
    no_spacer(i2,:)=[];
  end
  disp(['The following buntyps could not be found in ' spacer_p7  10])
  disp(char(bunt))
  error('Check your spacer file!')
end

%@(#)   get_spacer.m 1.3   00/03/20     10:03:00
