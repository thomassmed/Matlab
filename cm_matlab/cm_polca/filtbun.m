%@(#)   filtbun.m 1.2	 94/08/12     12:10:16
%
%function mult=filtbun(buntyp,bunchoice)
function mult=filtbun(buntyp,bunchoice)
lb=size(buntyp,1);
lbc=length(bunchoice);
mul=zeros(lb,lbc);
mult=zeros(lb,1);
for i=1:lbc,
    mul(:,i)=buntyp(:,i)==bunchoice(i);
end
if lbc>1,
  mult=min(mul')';
else
  mult=mul;
end
