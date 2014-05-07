%@(#)   fuelcost7.m 1.3	 04/09/29     13:59:34
%
%function [TWh,orekWhtot,kostnad]=fuelcost7(distfil1,distfil2,TWh,prifil,batchfil,freefil);
%function [TWh,orekWhtot,kostnad]=fuelcost7(distfil1,distfil2,TWh,prifil,batchfil,mulfree);
%Calculates specific fuel cost for a period of time between  
%two distribution files.
%
%Input:
%       distfil1 - distribution file 1
%       distfil2 - distribution file 2
%            TWh - Production in TWhe. If TWh=0, TWh is
%                  estimated by means of eta given in batchfil, default TWh=0
%         prifil - Resultfile, default='fuelcost7.lis', if 0 is given, the
%                  default value will be used
%       batchfil - Batchdata-file, default /cm/fx/div/bunhist/batch-data.txt
%                  if 0 is given, the default value will be used
%       freefil  - File with list of free bundles
%       mulfree  - multiplication vector for free bundles, if a sclar is given,
%                  mulfree will be assumed to be ones(1,kkan);
%Example:  fuelcost7('/cm/f3/c8/dist/eoy-92','/cm/f3/c8/dist/eofapr',0,...
%          'fuelcost7.lis','/cm/f3/div/bunhist/batch-data.txt')
%          fuelcost7('eoy-92','eoc8',3.864,0,0,0) % gives fuel cost with no reduction
%                                                % for reused fuel with kinf < 0.93
%                                                % Useful if the freebundles-file is
%                                                % incompatible with studied files
%                                                % (due to time difference)
function [TWh,orekWhtot,kostnad]=fuelcost7(distfil1,distfil2,TWh,prifil,batchfil,freefil);
[burn1,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist(distfil1,'burnup');
burn1=burn1.*1000;
reakdir=findreakdir;
if nargin<3, TWh=0;end
if nargin<4, prifil='fuelcost7.lis';fprintf('\n%s\n\n','Result is printed on fuelcost7.lis');end
if nargin<5, batchfil=[reakdir,'div/bunhist/batch-data.txt'];end
if nargin<6, freefil=[reakdir,'div/bunhist/freebundles.mat'];end
if isstr(TWh), TWh=str2num(TWh);end
if ~isstr(batchfil),
  batchfil=[reakdir,'div/bunhist/batch-data.txt'];
end
batchcostfil=[reakdir,'/div/bunhist/fcc/batchcost.txt'];
if isstr(freefil),
  if exist(freefil)==2,
    load(freefil);
    buidnt=readdist(distfil1,'buidnt');
    [dum,dum,freenum]=find(mbucatch(bufree,buidnt));
    mulfree=ones(1,size(buidnt,1));
    mulfree(freenum)=zeros(size(freenum));
  else
    disp([freefil,' was not found.']);
    disp(['Assuming no bundles in core are free']);
    bu=readdist(distfil1,'burnup');
    bu=bu.*1000;
    mulfree=ones(1,size(bu,2));
  end
elseif length(freefil)>1,
  mulfree=freefil;
  if size(mulfree,1)>1, mulfree=mulfree';end
else
  bu=readdist(distfil1,'burnup');
  bu=bu.*1000;
  mulfree=ones(1,size(bu,2));
end
fid=[];
if isstr(prifil),
  fid=fopen(prifil,'w');
elseif fid>0,
  fid=prifil;
else
  fprintf('\n%s\n\n','Result is printed on fuelcost7.lis');
  prifil='fuelcost7.lis';
  fid=fopen(prifil,'w');
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
  burn2=mean(burn2).*1000;
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
  if TWh==0, TWh=sum(uttaget)/1000;end
  ETA=eta*TWh/sum(uttaget);
  orekWhtot=sum(kostnad)/TWh/10;
  orekWh=kostnad./(TWh*(uttaget+1.0e-9)/sum(uttaget))/10;
  priorekwh(fid,antal,orekWh,orekWhtot,eladd,levyear,buntot,garburn,burneladd,Dburneladd,kkan,TWh,kostnad,nomkostnad,ETA,distfil1,distfil2);
end
