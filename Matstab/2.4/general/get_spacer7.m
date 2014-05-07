function [vhspx,rhspx,zsp,ispac]=get_spacer7(buntyp)
% [vhspx,rhspx,zsp,ispac]=get_spacer7(buntyp)

global polcadata msopt srcdata geom;

srcvalues=srcdata.SPACER;
% mz=polcadata.mz;				% Eliminerar samtliga läsningar direkt ur "polca-vektorer"
						% mz(44) läses in i get_polcadata som parameter geom.nastyp
						% Emma Lundgren, 05-12-09
% Total number of fuel-types in distfile
%	ntot=mz(44);
ntot = geom.nastyp;				% användandet av ntot ej lämpligt då ntot tidigare satts
						% till totala antalet neutroniknoder... eml, 05-12-09


BUNT=zeros(ntot,ntot*4);BUNT=setstr(BUNT);
lspmax=1;

% Sätt räknare, första bränsletyp, SPACER-förekomst
ityp=0;
i=1;

while i<=size(srcvalues,2)
  ityp=ityp+1;
  spacer=srcvalues(i).SPACER;
  bunt= sscanf(spacer,'%s');

%	Hitta avgränsare
  ib=find(bunt=='=');
  ikom=find(bunt(1:ib-1)==',');
  ikom=[0 ikom ib];

%	Lägg till fuel-types beteckning i BUNT
  for ii=1:length(ikom)-1
    BUNT(ityp,(ii-1)*4+1:ii*4)=sprintf('%4s',bunt(ikom(ii)+1:ikom(ii+1)-1));
  end
  
 %	Hämta spacer-data
  sp_data=sscanf(bunt(ib+1:length(bunt)),'%f,');  
  
 % 	Lägg till data i rätt variabel
  lsp=length(sp_data)/5;
  zspx(ityp,1:lsp)=sp_data(3:5:5*lsp)';
  rhsp(ityp,1:lsp)=sp_data(5:5:5*lsp)';
  vhsp(ityp,1:lsp)=-sp_data(4:5:5*lsp)'./1e5.^rhsp(ityp,1:lsp);
  if lsp>lspmax, lspmax=lsp; end

%	Stega räknare, spacerrad + bränsletyp
  i=i+1;

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
  disp(['The following buntyps could not be found in ' msopt.Soufil  10])
  disp(char(bunt))
  error('Check your source file!')
end
%@(#)   get_spacer.m 1.5   01/05/08     15:16:28
