%@(#)   monthcost.m 1.3	 94/08/12     12:15:20
%
%function monthcost(TWh,EFPHstart,EFPHend,prifil)
%Should be run from /cm/fx/cy/dist
%The function will use the tip-files on the current directory
%that are closest to the specified EFPH:s, and, if necessary,
%poldis.dat.
%
%Input:
%    TWh     - TWhe produced in the period
%  EFPHstart - EFPH at start of month
%  EFPHend   - EFPH at end of month
%  prifil    - print file, default = 'monthcost.lis'
%
% Note: the following files will be used:
%     bocx - BUIDNT and BUNTYP from the BOC-file
%     /cm/fx/fcc/batchcost.txt 
%     /cm/fx/div/bunhist/batchdata.txt
%     /cm/fx/div/bunhist/freebundles.txt - Bundles with restvalue 0
%
function monthcost(TWh,EFPHstart,EFPHend,prifil)
tipfiles=findfile('tip-??????.dat');
reakdir=findreakdir;
lr=length(reakdir);
[ierr,cwd]=unix('pwd');
ic=find(cwd=='/');
icc=ic(min(find(ic>lr)));
cycle=cwd(lr+1:icc-1);
batchfil=[reakdir,'div/bunhist/batch-data.txt'];
freefil=[reakdir,'div/bunhist/freebundles.mat'];
batchcostfil=[reakdir,'fcc/batchcost.txt'];
if nargin<4,
  disp('Result will be printed on monthcost.lis');
  prifil='monthcost.lis';
end
fid=fopen(prifil,'w');
% Find TIP-files on directory
for i=1:size(tipfiles,1),
  efph(i)=min(readdist(tipfiles(i,:),'EFPH'));
end
errflag=0;
bocfil=['bo',cycle];
disp(['BOC-file ',bocfil,' will be used']);
buntyp=readdist(bocfil,'buntyp');
if length(buntyp)==1,
 disp('I need to have BUNTYP on poldis.dat, fix that and try again!');
 errflag=1;
end
buidnt=readdist(bocfil,'buidnt');
if length(buidnt)==1,
 disp('I need to have BUIDNT on poldis.dat, fix that and try again!');
 errflag=1;
end
[eladd,garburn,antal,levyear,enr,buntot,weight,eta]=readbatch(batchfil);
[bunto,batchcost]=readcost(batchcostfil);
ierr=checkbuntot(buntot,bunto);
imax=size(buntot,1);
errflag=max(ierr,errflag);
if exist(freefil)==2,
  load(freefil);
  [dum,dum,freenum]=find(mbucatch(bufree,buidnt));
   mulfree=ones(1,size(buidnt,1));
   mulfree(freenum)=zeros(size(freenum));
else
  errflag=1;  
  disp([freefil,' does not exist, fix one and try again!']);
end
if errflag==0,
  ist=max(find(EFPHstart>efph));
  w1=(efph(ist+1)-EFPHstart)/(efph(ist+1)-efph(ist));
  burn1=readdist(tipfiles(ist,:),'burnup');
  burn2=readdist(tipfiles(ist+1,:),'burnup');
  burnupstart=w1*burn1+(1-w1)*burn2;
  iend=max(find(EFPHend>efph));
  burn1=readdist(tipfiles(iend,:),'burnup');
  if max(efph)>EFPHend,
    burn2=readdist(tipfiles(iend+1,:),'burnup');
  else
    burn2=readdist('poldis','burnup');
    efph(iend+1)=min(readdist('poldis','efph'));
  end
  w1=(efph(iend+1)-EFPHend)/(efph(iend+1)-efph(iend));
  burnupend=w1*burn1+(1-w1)*burn2;
  burn1=burnupstart;
  burn2=burnupend;
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
  if TWh==0, TWh=sum(uttaget)/1000;end
  ETA=eta*TWh/sum(uttaget);
  orekWhtot=sum(kostnad)/TWh/10;
  orekWh=kostnad./(TWh*(uttaget+1.0e-9)/sum(uttaget))/10;
  priorekwh(fid,antal,orekWh,orekWhtot,eladd,levyear,buntot,garburn,burneladd,Dburneladd,kkan,TWh,kostnad,nomkostnad,ETA);
end
