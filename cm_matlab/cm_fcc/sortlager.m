%@(#)   sortlager.m 1.2	 94/08/12     12:15:45
%
%function [antal,uttag,garut,rest,restsek,specburn,garburn,meanburn,speccost]=...
%sortlager(BUNTYP,burnup,batchfil,batchcostfil,freenum);
%Sorts buntyp and burnup into batches
%
%Input: BUNTYP   - Vector of BUNTYP, BUNTYP and burnup defines the "fuel population"
%       burnup   - Vector of average bundle burnup
%       batchfil - Batchdata-file (default /cm/fx/div/bunhist/batch-data.txt)
%   batchcostfil - Batchcost-file (default /cm/fx/fcc/batchcost.txt) May not be readable for all users
%   freenum      - channel number for bundles with restvalue zero due too kinf<.93 in pool (reused)
%
%
%Output: antal - number of bundles batchwise in population
%        uttag - Energy extracted from batch
%        garut - Garantueed energy extraction from batch
%         rest - Rest energy (garut-uttag)
%      restsek - Rest value is MSEK for batch
%      specburn- Av. burnup for each bundle in batch
function [antal,uttag,garut,rest,restsek,specburn,garburn,meanburn,speccost]=...
sortlager(BUNTYP,burnup,batchfil,batchcostfil,freenum);
if size(burnup,2)==1, burnup=burnup';end
if nargin<5,
  freenum= [];
end
if nargin<4,
  reakdir=findreakdir;
end
if nargin<3,
  batchfil=[reakdir,'div/bunhist/batch-data.txt'];
end
[eladd,garburn,andum,levyear,enr,buntot,weight,eta,typ,stav]=readbatch(batchfil);
if nargin<4,
  batchcostfil=[reakdir,'fcc/batchcost.txt'];
end
if ~isstr(batchcostfil),
  if length(eladd)~Mlength(batchcost),
    batchcost=0*ones(eladd);ierr=0;
    disp(' Input argument batchcost is different in size from the number of');
    disp(' batches, so the batchcost will be assumed to be zero');
  else
    batchcost=batchcostfil;
  end
else
  [bunto,batchcost]=readcost(batchcostfil);
  ierr=checkbuntot(buntot,bunto);
end
if ierr==0,
   speccost=batchcost./(garburn.*weight.*andum*24)*1e6;
   bpcost=batchcost./andum;
   imax=length(eladd);
   antal=zeros(1,imax);
   uttag=zeros(1,imax);
   garut=zeros(1,imax);
   meanburn=zeros(1,imax);
   rest=zeros(1,imax);
   restsek=zeros(imax,2);
   specburn=zeros(imax,500);
   lmax=0;
   ett=ones(size(BUNTYP,1),1);
   irad=findeladd(BUNTYP,buntot,levyear);
   burnfree=burnup;
   if length(freenum)>0,
      burnfree(freenum)=garburn(irad(freenum))*1000;
   end
   for i=1:imax
     ibun=find(irad==i);
     libun=length(ibun);
     if libun>0
       if libun>lmax, lmax=libun;end
       antal(i)=libun;
       specburn(i,1:libun)=sort(burnup(ibun));
       rburn=garburn(i)-burnfree(ibun)/1000;
       ir=find(rburn>0);
       if length(ir)>0,
         restburn(i)=sum(rburn(ir));
       else
         restburn(i)=0;
       end
       sumburn=sum(burnup(ibun))/1000;
       meanburn(i)=sumburn/antal(i);
       uttag(i)=sumburn*weight(i)*24/1e6;
       garut(i)=(weight(i)*garburn(i)*antal(i))*24/1e6;
       rest(i)=restburn(i)*weight(i)*24/1e6;
       restsek(i,1)=speccost(i)*rest(i);
       restsek(i,2)=speccost(i)*(garut(i)-uttag(i));
     end
   end
   rest=rest*eta;
   uttag=uttag*eta;
   garut=garut*eta;
   specburn=specburn(:,1:lmax);
   speccost=speccost/eta;
end
