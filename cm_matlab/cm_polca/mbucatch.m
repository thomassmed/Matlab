%@(#)   mbucatch.m 1.3	 97/08/03     19:54:37
%
%function j=mbucatch(buid1,buid2) 
%
function j=mbucatch(buid1,buid2) 
n=size(buid1,1);
j=zeros(n,1);
for i=1:n
  jj=strmatch(buid1(i,:), buid2);
  if ~isempty(jj)
    j(i)=jj;
  end
end
