function [aby,dhby,vhiby,vhoby,vhspx,rhspx,ispac,zsp,acj,dhcj,phcj,pwcj,vhicj,vhocj]=get_thdata
% [aby,dhby,vhiby,vhoby,vhspx,rhspx,ispac,zsp,acj,dhcj,phcj,pwcj,vhicj,vhocj]=get_thdata;

%code translated from rm1day

%@(#)   get_thdata.m 1.15   02/02/27     12:14:21

%discarge coefficient from rm1day, default 0.5
%0.33 for plr bundles
pdcout=0.5;
pdcout_plr=0.33;
%bypass outlet pres. loss coefficient
vhoby=0;
vhiby=-1200;

global polcadata msopt geom

mastfile=msopt.MasterFile;

orific=mast2mlab(mastfile,34,'F');
thadr=mast2mlab(mastfile,41,'I');
thdata=mast2mlab(mastfile,81,'F');
orityp=mast2mlab(mastfile,85,'I');
bunref=mast2mlab(mastfile,45,'C2');
%Task: Check if the next two lines are necessary (why not polcadata.mz)
mz=mast2mlab(mastfile,5,'I');
hy=mast2mlab(mastfile,8,'F');

buntyp=polcadata.buntyp;
staton=polcadata.staton;

kmax=mz(4);
kormax=mz(65);
kkan=mz(22);
kan=kkan/get_sym;
arean=hy(14);
ntot=mz(29);
data=zeros(ntot,6);


bunref=reshape(bunref(1:4*ntot),4,ntot)';
ifm=mbucatch(buntyp,bunref);

if any(ifm==0)
  error(['Error, some fueltypes are missing in the polca master file ', mastfile]);
end

knum=geom.knum(:,1);

orityp=orityp(kkan+1:2*kkan);
ifm=ifm(knum);
orityp=orityp(knum);

for i=ntot:-1:1
  th=thdata(thadr(i)+1:thadr(i)+60);
  acj(i)=th(1);
  dhcj(i)=th(3);
  dzout(i)=th(5);
  dzsp(i)=th(6);
  vhocj(i)=th(7);
  abot(i)=th(8);
  acrud(i)=th(9);
  hfe(i)=th(11);
  ph1u(i)=th(12);
  itrtyp(i)=th(14);
  if th(14) < 0.01
     itrtyp(i)=round(itrtyp(i)/1.4013e-45);  
     %1.4e-45 because of wrong translation of integer/real
  end
  phcj(i)=th(15);
  ph3u(i)=th(16);
  fsp2(i)=th(17);
  fsp3(i)=th(18);
  afewc(i)=th(32);
  phwc(i)=th(33);
  dhwc(i)=th(34);
  afeww(i)=th(47);
  phww(i)=th(48);
  dhww(i)=th(49);
end

%spacers

rhsp= fsp3;
vhsp= -1*fsp2'.*acrud'./(1e5).^fsp3';

zspx=zeros(ntot,10);
for i=1:ntot
  pos=(dzsp(i)+1e-4:dzsp(i):hfe(i));
  zspx(i,1:length(pos))=pos;
end

[zspxsort,izspx]=sort(zspx(:));
pos=find(round(1e4*diff(zspxsort)))+1;
zsp=zspx(izspx(pos)); 
ispac=length(zsp);

vhspx=zeros(ntot,ispac);
rhspx=vhspx;
for i=1:ntot
  x=round(100*(zsp/(dzsp(i)+1e-4)))/100;
  pos=find((x-floor(x))==0)';
  vhspx(i,pos)=ones(size(pos))*vhsp(i);
  rhspx(i,pos)=ones(size(pos))*rhsp(i);
end

acj=acj'*ones(1,kmax);
dhcj=dhcj'*ones(1,kmax);
phcj=phcj'*ones(1,kmax);

%Part length rod data

if ~strcmp(staton,'l')
  [zzarea,zzdh,zzhta]=readplr(mastfile);
else
  zzarea=ones(size(acj));
  zzdh=ones(size(dhcj));
  zzhta=ones(size(phcj));
end

if length(zzarea)>0,
  acj=acj(ifm,:).*zzarea(ifm,:);
  dhcj=dhcj(ifm,:).*zzdh(ifm,:);
  phcj=phcj(ifm,:).*zzhta(ifm,:);
else
  acj=acj(ifm,:);
  dhcj=dhcj(ifm,:);
  phcj=phcj(ifm,:);
end

isplr = zzarea(:,kmax)~=1; %Look for plr bundles

pwcj=(4*acj./dhcj-phcj);

vhspx=vhspx(ifm,:);
rhspx=rhspx(ifm,:);
vhocj=vhocj(ifm)' + pdcout.*(~isplr(ifm)) + pdcout_plr.*isplr(ifm);
abot=abot(ifm)';
itrtyp=itrtyp(ifm)';
afewc=afewc(ifm)';
afeww=afeww(ifm)';
phwc=phwc(ifm)';
phww=phww(ifm)';

throtl=orific(orityp+(itrtyp-1)*kormax);

vhicj=-(abot+throtl.*(acj(:,1)/arean).^2);

% bypass
aby0=thdata(1)/get_sym;
aby =aby0+sum(afewc)+sum(afeww);
dhby0=thdata(3);
phby0=4*aby/dhby0;
dhby=4*aby/(phby0+sum(phwc)+sum(phww));
