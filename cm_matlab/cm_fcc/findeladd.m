%@(#)   findeladd.m 1.2	 94/08/12     12:15:06
%
%function irad=findeladd(buntyp,buntot,levyear)
%Finds the batch (ers.laddn) for a given BUNTYP
% Input: buntyp  - The buntyp, for which the batch is to be found
%        buntot  - Matrix of buntyp:s batchwise
%        levyear - year of delivery
%
%The following assumption is made
%
% 1) If there is only one hit, no consideration to levyear is made
% 2) If there are two hits, the following is assumed
%     0 <= (the two last numbers in BUNTYP)-levyear < 10
%
function irad=findeladd(buntyp,buntot,levyear)
[ib,jb]=size(buntot);
irad=zeros(size(buntyp,1),1);
ierr=0;
if nargin>2,
  il=length(levyear);
  if ib~=il,
    disp('The number of batches in buntot is different from');
    disp('the number of batches in levyear');
    ierr=1;
  end
end
if ierr==0,
  for i=1:ib,
    levyear=adjustyear(levyear);
    ii=find(buntot(i,:)==',');
    if length(ii)==0,
      bun=remblank(buntot(i,:));
      mult=filtbun(buntyp,bun);
    else
       bun=remblank(buntot(i,1:ii(1)-1));
       mult=filtbun(buntyp,bun);
       for k=1:length(ii)-1,
         bun=remblank(buntot(i,ii(k)+1:ii(k+1)-1));
         mult=mult+filtbun(buntyp,bun);
       end
       bun=remblank(buntot(i,ii(length(ii))+1:size(buntot,2)));
       mult=mult+filtbun(buntyp,bun);
    end
    ibun=find(mult>0);
    ibefore=find(irad(ibun)>0);
    iabef=length(ibefore);
    ieold=irad;
    irad(ibun)=ones(size(ibun))*i;
    for ii=1:iabef,
      insar=str2num(buntyp(ibun(ibefore(ii)),3:4));
      insar=adjustyear(insar);
      if insar-levyear(i)<0,  % Last choice of batch was correct
         irad(ibun(ibefore(ii)))=ieold(ibun(ibefore(ii)));
      end
    end
  end
  irr=find(irad==0);
  if length(irr)>0,
    fprintf('\n');
    fprintf('%s','  Warning!! The following buntyp:s were not found in');
    fprintf('%s\n','  batch-data file:');
    fprintf('\n');
    disp(buntyp(irr,:))
  end
end
