%@(#)   findmove.m 1.1	 05/07/13     10:29:31
%
%
function [ifrom,ito]=findmove(curpos,OK,from,to,fuel,mminj);
filt1=zeros(size(OK)); filt2=filt1; filt3=filt1; filt0=filt1;
i1=find(OK==1);filt1(i1)=ones(size(i1));
i2=find(fuel==0);filt2(i2)=ones(size(i2));
i0=find(from>0);filt0(i0)=ones(size(i0));
filt3=filt0.*filt1.*filt2;
i3=find(filt3==1);
ipo=length(i3);
possible=from(i3);
if ipo>0,
  cpossible=knum2cpos(possible,mminj);
  chek=abs(cpossible(:,1)-curpos(1))+abs(cpossible(:,2)-curpos(2));
  [x,imin]=sort(chek);
  ifrom=possible(imin); ito=to(possible(imin));
else
  ifrom=0;ito=0;
end
