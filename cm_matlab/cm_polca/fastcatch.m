%@(#)   fastcatch.m 1.3	 98/03/23     13:36:58
%
%function j=fastcatch(buid,BUIDNT) 
%
function j=fastcatch(buid,BUIDNT)
i=find(buid==' ');buid(i)='';
buid=sprintf('%6s',buid); 
jj=(10:-2:0)';
jj=10.^jj;
x=abs(BUIDNT)*jj;
x1=abs(buid)*jj;
j=find(x==x1);

