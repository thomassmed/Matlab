function [dr,f]=calcdr(th);
dden=th;
dden=[ones(15000,1) dden]
for n=1:15000,
  rts(n,1:4)=roots(dden(n,:))';
end
[r,f]=dr(rts,0.1);
