%@(#)   findfree7.m 1.4	 06/11/20     10:44:26
%
%function findfree7(freedata,bufreefil,khotlim,matfil)
%Finds bundle that with restvalue=0, although guarantueed,
%burnup has not been reached.
%
%Input:
%       freedata - Name on file where data for free bundles are to be
%                  stored. This file is similar to matfil ('utfil.mat'), except
%                  that  freedata only contains the free bundles. For printout,
%                  use the sortprint command. Default= 'freedata.mat'
%       bufreefil- only one variable is stored on this file:  bufree, which
%                  contains the asyid on the free bundles. This file can be directly
%                  used as a freebundles-file. Default='bufreefil.mat'
%       matfil   - Output from bunhist (cf. that m-file),
%                  default='/cm/fx/div/bunhist/utfil.mat'
function findfree7(freedata,bufreefil,khotlim,matfil)
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
  khotlim=0.93;
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
batchcostfile=[reakdir,'/div/bunhist/fcc/batchcost.txt'];
[bunto,batchcost]=readcost(batchcostfile);
ierr=checkbuntot(buntot,bunto);
imax=size(buntot,1);
if ierr==0,
  bpc=batchcost./(antot+1e-30);
  irad=findeladd(ASYTYP,buntot,levyear);
  garbun=garburn(irad)';
  weibun=weight(irad)';
  bpcost=bpc(irad)';
  Uttag=weibun.*burnup*2.4e-8*eta;
  restburn0=(garbun-burnup/1000)./garbun;restburn=max(restburn0,0);
  khot2=ones(size(khot));
  [j,i]=find(diff(ICYC')>1);
  if length(j)>0,
    khot2(i)=getspars(KHOT,i,j);
  end
  mulfree=((lastcyc<max(lastcyc)&khot<.93)|khot2<.93)&burnup/1000<garbun&ONSITE;
  ifilt=find(mulfree);
  savesubset7(matfil,freedata,ifilt);
  bufree=ASYID(ifilt,:);
  
end
% manuellt avskrivna patroner
avskrivfil=[reakdir,'div/bunhist/freefiles/man_avskriv.txt'];
fid=fopen(avskrivfil,'r');
rad=fgetl(fid);
while isstr(rad)
    rad=fgetl(fid);
    if strmatch(rad,'END'); break;end;
    bufree=char(bufree,rad);    
end
fclose(fid);	
evsave=['save ',bufreefil,' bufree'];
eval(evsave);
