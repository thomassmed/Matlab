%@(#)   cor2cr.m 1.2	 94/08/12     12:09:53
%
%function dist=cor2cr(core,mminj)
%Reduce full core map  to control rod value vector  
%Example: core 30 by 30, mminj 30 by 1 => dist is 700 by 1 (F3)
function dist=cor2cr(core,mminj)
ll=length(mminj);
lcr=fix(ll/2);
for i=1:lcr
  for j=1:lcr
    crmap(i,j)=core(2*i,2*j);
  end
end
dist=map2cr(crmap,mminj);
