%@(#)   restvalue.m 1.5	 00/06/05     15:51:58
%
%function restvalue(distfile)
%function [iut,rest]=restvalue(distfile,nslut)
%function [iut,rest]=restvalue(distfile,kinflim)
%function [iut,rest]=restvalue(distfile1,distfile2,kinflim,noplot)
%function [iut,rest]=restvalue(buntyp,burnup)
%Computes the rest-value of unloaded fuel
%Input:
%       distfile - eoc-distribution file
%       nslut    - Number of bundles unloaded
%       kinflim  - kinf-limit for unloaded fuel
%       noplot   - If a 4th input arg. exist, do not present a plot. 
%Output:
%       buntyp   - buntyp for unloaded bundles
%       burnup   - mean burnup for unloaded bundles
%  To calculate the "straight" restvalue for all bundles in a distr.file,
%  use the function restvalue_distfil

%  opt=1  : distfile
%  opt=2  : distfile,nslut
%  opt=3  : distfile,kinflim
%  opt=4  : distfile,distfile2,kinflim
%  opt=5  : buntyp,burnup
%  
%  
function [iut,rest]=restvalue(x1,x2,x3,x4)
if nargin==1,
  opt=1;
  distfile=x1;
  burnup=mean(readdist(distfile,'burnup'));
  [buntyp,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil]=readdist(distfile,'buntyp');
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
    buid1=readdist(distfile,'buidnt');
    buid2=readdist(distfile2,'buidnt');
    kkan=size(buid1,1);
    [from,to,ready,fuel]=initvec(buid1,buid2,ones(kkan,1));
    iut=find(to==0);
    if nargin>2, 
      kinflim=x3;
      kinf=kinf2mlab(distfile);
      ik=(kinf>kinflim)';
      iut=find(to+ik==0);
    end    
    burnup=mean(readdist(distfile,'burnup'));
    [buntyp,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
    distlist,staton,masfil]=readdist(distfile,'buntyp');
    staton=[staton,' ',stripfile(distfile2),' - ',stripfile(distfile)];
    reakdir=findreakdir;
    batchfile=[reakdir,'div/bunhist/batch-data.txt'];
    burnup=burnup(iut)';    
    buntyp=buntyp(iut,:);
  else
    opt=5;
    buntyp=x1;
    burnup=x2;
    reakdir=findreakdir;
    batchfile=[reakdir,'div/bunhist/batch-data.txt'];
    ir=find(reakdir=='/');
    staton=reakdir(ir(2)+1:ir(3)-1);
    iut=0;
  end
elseif x2~=0
  distfile=x1;
  kinf=kinf2mlab(distfile);
  if x2<1.5,
    opt=3;
    kinflim=x2;
    nslut=length(find(kinf<kinflim));
  else
    opt=2;
    nslut=x2;
  end
  [ki,is]=sort(kinf);
  burnup=mean(readdist(distfile,'burnup'));
  [buntyp,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil]=readdist(distfile,'buntyp');
  staton=[staton,' ',stripfile(distfile)];
  reakdir=findreakdir;
  batchfile=[reakdir,'div/bunhist/batch-data.txt'];
  buntyp=buntyp(is(1:nslut),:);
  burnup=burnup(is(1:nslut));
  iut=is(1:nslut);
end
[eladd,garburn,andum,levyear,enr,buntot]=readbatch(batchfile);
ii=find(batchfile=='/');batchcostfile=[batchfile(1:ii(4)),'fcc/batchcost.txt'];
[antal,uttag,garut,rest,restsek,specburn,garburn,meanburn,speccost]=...
sortlager(buntyp,burnup,batchfile,batchcostfile);
rest=sum(restsek(:,1));
priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,'restvalue.lis',staton);
if x2~=0&nargin<4,
  stege(antal,restsek,specburn,garburn,buntot,staton);
end
disp([batchfile,' and ',batchcostfile,' have been used']);
disp('A summary of the results will be printed on restvalue.lis');
end
