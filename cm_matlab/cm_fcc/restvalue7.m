%@(#)   restvalue7.m 1.2	 04/10/11     13:35:34
%
%
%function restvalue7(distfile)
%function [iut,rest]=restvalue7(distfile,nslut)
%function [iut,rest]=restvalue7(distfile,khotlim)
%function [iut,rest]=restvalue7(distfile1,distfile2,khotlim,noplot)
%function [iut,rest]=restvalue7(asytyp,burnup)
%Computes the rest-value of unloaded fuel
%Input:
%       distfile - eoc-distribution file
%       nslut    - Number of bundles unloaded
%       khotlim  - khot-limit for unloaded fuel
%       noplot   - If a 4th input arg. exist, do not present a plot. 
%Output:
%       asytyp   - asytyp for unloaded bundles
%       burnup   - mean burnup for unloaded bundles
%  To calculate the "straight" restvalue7 for all bundles in a distr.file,
%  use the function restvalue7_distfil

%  opt=1  : distfile
%  opt=2  : distfile,nslut
%  opt=3  : distfile,khotlim
%  opt=4  : distfile,distfile2,khotlim
%  opt=5  : asytyp,burnup
%  
%  
function [iut,rest]=restvalue7(x1,x2,x3,x4)
if nargin==1,
  opt=1;
  distfile=x1;
  burnup=mean(readdist7(distfile,'burnup'))*1000;
  [asytyp,mminj,konrod,bb,hy,mz,ks,asytyp,bunref,...
  distlist,staton,masfil]=readdist7(distfile,'asytyp');
  staton=[staton,' ',stripfile(distfile)];
  reakdir=findreakdir;
  batchfile=[reakdir,'div/bunhist/batch-data.txt'];
  x2=1;
  iut=(1:length(burnup));
elseif length(x2)>1,
  if isstr(x2),
    opt=4;
    distfile=x1;
    distfile2=x2;
    buid1=readdist7(distfile,'asyid');
    buid2=readdist7(distfile2,'asyid');
    kkan=size(buid1,1);
    [from,to,ready,fuel]=initvec(buid1,buid2,ones(kkan,1));
    iut=find(to==0);
    if nargin>2, 
      khotlim=x3;
      khot=readdist7(distfile,'khot');
      ik=(khot>khotlim)';
      iut=find(to+ik==0);
    end    
    burnup=mean(readdist7(distfile,'burnup'))*1000;
    [asytyp,mminj,konrod,bb,hy,mz,ks,asytyp,bunref,...
    distlist,staton,masfil]=readdist7(distfile,'asytyp');
    staton=[staton,' ',stripfile(distfile2),' - ',stripfile(distfile)];
    reakdir=findreakdir;
    batchfile=[reakdir,'div/bunhist/batch-data.txt'];
    burnup=burnup(iut)';    
    asytyp=asytyp(iut,:);
  else
    opt=5;
    asytyp=x1;
    burnup=x2;
    reakdir=findreakdir;
    batchfile=[reakdir,'div/bunhist/batch-data.txt'];
    ir=find(reakdir=='/');
    staton=reakdir(ir(2)+1:ir(3)-1);
    iut=0;
  end
elseif x2~=0
  distfile=x1;
  khot=readdist7(distfile,'khot');
  if x2<1.5,
    opt=3;
    khotlim=x2;
    nslut=length(find(khot<khotlim));
  else
    opt=2;
    nslut=x2;
  end
  [ki,is]=sort(khot);
  burnup=mean(readdist7(distfile,'burnup'))*1000;
  [asytyp,mminj,konrod,bb,hy,mz,ks,asytyp,bunref,...
  distlist,staton,masfil]=readdist7(distfile,'asytyp');
  staton=[staton,' ',stripfile(distfile)];
  reakdir=findreakdir;
  batchfile=[reakdir,'div/bunhist/batch-data.txt'];
  asytyp=asytyp(is(1:nslut),:);
  burnup=burnup(is(1:nslut));
  iut=is(1:nslut);
end
[eladd,garburn,andum,levyear,enr,buntot]=readbatch(batchfile);
ii=find(batchfile=='/');batchcostfile=[batchfile(1:ii(5)),'fcc/batchcost.txt'];
[antal,uttag,garut,rest,restsek,specburn,garburn,meanburn,speccost]=...
sortlager(asytyp,burnup,batchfile,batchcostfile);
rest=sum(restsek(:,1));
priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,'restvalue7.lis',staton);
if x2~=0&nargin<4,
  stege(antal,restsek,specburn,garburn,buntot,staton);
end
disp([batchfile,' and ',batchcostfile,' have been used']);
disp('A summary of the results will be printed on restvalue7.lis');
