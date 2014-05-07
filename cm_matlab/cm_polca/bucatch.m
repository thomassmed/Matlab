%@(#)   bucatch.m 1.4   03/10/09     08:41:27
%
%function j=bucatch(buid,BUIDNT) 
%
function j=bucatch(buid,BUIDNT)
[iB,jB]=size(BUIDNT);
[iB1,jB1]=size(buid);
if jB~=jB1,
  error('Length of both strings must be the same');
end
jj=((jB*2-2):-2:0)';
jj=10.^jj;
x=abs(BUIDNT)*jj;
x1=abs(buid)*jj;
j=find(x==x1);
