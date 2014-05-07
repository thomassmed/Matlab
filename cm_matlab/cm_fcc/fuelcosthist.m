%@(#)   fuelcosthist.m 1.2	 94/08/12     12:15:13
%
%function TWh=fuelcost(distfil1,distfil2,TWh,prifil,batchfil,freefil);
%Calculates specific fuel cost for a period of time between  
%two distribution files.
%
%Input:
%       distfil1 - distribution file 1
%       distfil2 - distribution file 2
%            TWh - Production in TWhe. If TWh=0, TWh is
%                  estimated by means of eta given in batchfil, default TWh=0
%         prifil - Resultfile, default='fuelcost.lis'
%       batchfil - Batchdata-file, default /cm/fx/div/bunhist/batch-data.txt
%       freefil  - File with list of free bundles
%
%Example:  fuelcost('/cm/f3/c8/dist/eoy-92','/cm/f3/c8/dist/eofapr',0,...
%          'fuelcost.lis','/cm/f3/div/bunhist/batch-data.txt')
%
function TWh=fuelcost(distfil1,distfil2,TWh,prifil,batchfil);
[burn1,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist(distfil1,'burnup');
reakdir=findreakdir;
if nargin<3, TWh=0;end
if nargin<4, prifil='fuelcost.lis';fprintf('\n%s\n\n','Result is printed on fuelcost.lis');end
if nargin<5, batchfil=[reakdir,'div/bunhist/batch-data.txt'];end
batchcostfil=[reakdir,'fcc/batchcost.txt'];
buidnt=readdist(distfil1,'buidnt');
mulfree=ones(1,size(buidnt,1));
if isstr(prifil),
  fid=fopen(prifil,'w');
else
  fid=prifil;
end
[eladd,garburn,antal,levyear,enr,buntot,weight,eta]=readbatch(batchfil);
[bunto,batchcost]=readcost(batchcostfil);
ierr=checkbuntot(buntot,bunto);
imax=size(buntot,1);
if ierr==0,
  bpc=batchcost./(antal+1e-30);
  irad=findeladd(buntyp,buntot,levyear);
  garbun=garburn(irad);
  weibun=weight(irad);
  bpcost=bpc(irad);
  burn1=mean(burn1);
  kkan=length(burn1);
  restburn0=(garbun-burn1/1000)./garbun;restburn=max(restburn0,0);
  restsek1=mulfree.*restburn.*bpcost;
  restseknom1=restburn0.*bpcost;
  uttag1=weibun.*burn1*2.4e-5*eta;
  burn2=readdist(distfil2,'burnup');
  burn2=mean(burn2);
  restburn0=(garbun-burn2/1000)./garbun;restburn=max(restburn0,0);
  restsek2=mulfree.*restburn.*bpcost;
  restseknom2=restburn0.*bpcost;
  uttag2=weibun.*burn2*2.4e-5*eta;
  for i=1:imax
    ibun=find(irad==i);
    antal(i)=length(ibun);
    if antal(i)>0,
      kostnad(i)=sum(restsek1(ibun)-restsek2(ibun));
      nomkostnad(i)=sum(restseknom1(ibun)-restseknom2(ibun));
      burneladd(i)=mean(burn2(ibun))/1000;
      Dburneladd(i)=burneladd(i)-mean(burn1(ibun))/1000;
      ut1(i)=sum(uttag1(ibun));
      ut2(i)=sum(uttag2(ibun));
    end
  end
  uttaget=ut2-ut1;
  if nargin<3, TWh=sum(uttaget)/1000;end
  if TWh==0, TWh=sum(uttaget);end
  orekWhtot=sum(kostnad)/TWh/10;
  orekWh=kostnad./(TWh*(uttaget+1.0e-9)/sum(uttaget))/10;
  priorekwh(fid,antal,orekWh,orekWhtot,eladd,levyear,buntot,garburn,burneladd,Dburneladd,kkan,TWh,kostnad,nomkostnad);
end
