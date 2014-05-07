%@(#)   findint.m 1.1	 03/08/19     08:46:23
%
%function j=findint(x1,x2)
function j=findint(x1,x2)
x1=x1(:);
j=zeros(size(x1));
for i=length(x2):-1:1;
  k= x1==x2(i);
  j(k)=i;
end
