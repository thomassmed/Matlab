%@(#)   knum2cpos.m 1.3	 01/03/05     08:22:21
%
%function yx=knum2cpos(kannum,mminj)
function yx=knum2cpos(kannum,mminj)
ll=length(mminj)+2;
csum=cumsum(ll-2*mminj);
yx=[];
for i=1:length(kannum)
  if kannum(i)>sum(ll-2*mminj)
    yx='kannum is greater than number of channels in core'
  else
    k=min(find(kannum(i)<=csum));
    yx(i,1)=k;
    if k==1, cs=0;else cs=csum(k-1);end
    yx(i,2)=kannum(i)-cs+mminj(k)-1;
  end
end
