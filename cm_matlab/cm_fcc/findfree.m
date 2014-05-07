%@(#)   findfree.m 1.3	 95/10/02     13:08:56
%
%function findfree(freedata,bufreefil,kinflim,matfil)
%Finds bundle that with restvalue=0, although guarantueed,
%burnup has not been reached.
%
%Input:
%       freedata - Name on file where data for free bundles are to be
%                  stored. This file is similar to matfil ('utfil.mat'), except
%                  that  freedata only contains the free bundles. For printout,
%                  use the sortprint command. Default= 'freedata.mat'
%       bufreefil- only one variable is stored on this file:  bufree, which
%                  contains the buidnt on the free bundles. This file can be directly
%                  used as a freebundles-file. Default='bufreefil.mat'
%       matfil   - Output from bunhist (cf. that m-file),
%                  default='/cm/fx/div/bunhist/utfil.mat'
function findfree(freedata,bufreefil,kinflim,matfil)
reakdir=findreakdir;
if nargin<1
  freedata='freedata.mat';
  disp('Data for free bundles will be stored on freedata.mat')
end
if nargin<2
  bufreefil='bufreefil.mat';
end
disp(['List of free bundles will be stored on ',bufreefil,' in variable bufree'])
if nargin<3
  kinflim=0.93;
end
if nargin<4,
  matfil=[reakdir,'div/bunhist/utfil.mat'];
end
load(matfil);
ii=find(reakdir=='/');
staton=upper(reakdir(ii(2)+1:ii(3)-1));
nbu=length(ITOT);
batchfile=[reakdir,'div/bunhist/batch-data.txt'];
[eladd,garburn,antot,levyear,enr,buntot,weight,eta]=readbatch(batchfile);
batchcostfile=[reakdir,'fcc/batchcost.txt'];
[bunto,batchcost]=readcost(batchcostfile);
ierr=checkbuntot(buntot,bunto);
imax=size(buntot,1);
if ierr==0,
  bpc=batchcost./(antot+1e-30);
  irad=findeladd(BUNTYP,buntot,levyear);
  garbun=garburn(irad)';
  weibun=weight(irad)';
  bpcost=bpc(irad)';
  Uttag=weibun.*burnup*2.4e-8*eta;
  restburn0=(garbun-burnup/1000)./garbun;restburn=max(restburn0,0);
  kkinf=ones(size(kinf));
  [j,i]=find(diff(ICYC')>1);
  if length(j)>0,
    kkinf(i)=getspars(KINF,i,j);
  end
  mulfree=((lastcyc<max(lastcyc)&kinf<.93)|kkinf<.93)&burnup/1000<garbun&ONSITE;
  ifilt=find(mulfree);
  savesubset(matfil,freedata,ifilt);
  bufree=BUIDNT(ifilt,:);
  evsave=['save ',bufreefil,' bufree'];
  eval(evsave);
end
