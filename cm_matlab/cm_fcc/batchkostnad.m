%@(#)   batchkostnad.m 1.2	 94/08/12     12:14:56
%
function BATCHCOST=batchkostnad(batchfil,kostnad);
[eladd,garburn,antal,levyear,enr,buntot,weight,eta,batchcost]=...
readbatch(batchfil);
eldi=max(eladd)+1-min(eladd);
if eldi==length(kostnad),
  totenergy=garburn.*weight.*antal*eta*24/1e6;
  for i=1:eldi,
    ii=find(eladd==i-1);
    stot=sum(totenergy(ii));
    BATCHCOST(ii)=kostnad(i)*totenergy(ii)/stot;
  end
else
  disp('in-vektorn kostnad ej lika lang som antalet ers.laddningar');
  disp(['max(eladd)+1-min(eladd) = ',sprintf('%2i',eldi),...
        'length(kostnad) = ',sprintf('%2i',length(kostnad))]);
end
