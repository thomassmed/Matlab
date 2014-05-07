%@(#)   area2knum.m 1.1	 04/07/02     08:04:09
%
%function knumvec=area2knum(antal_areor,mminj);
function knumvec=area2knum(antal_areor,mminj);
lm=length(mminj);
rad=lm/2;
antal=0;
for i=1:lm
  antal=antal+2*(rad+1-mminj(i));
end
for i=1:antal
  ij=knum2cpos(i,mminj);
  l(i)=sqrt((ij(1)-rad-.5)^2+(ij(2)-rad-.5)^2);
end
m=max(l);
for i=1:antal_areor
  steg(i)=m*sqrt(i/antal_areor);
  ii=find(l<=steg(i));
  knumvec(ii)=i;
  l(ii)=99;
end
