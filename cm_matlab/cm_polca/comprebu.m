%@(#)   comprebu.m 1.3	 06/02/15     13:15:20
%
function ibu=comprebu(asyid)
asyid=abs(asyid);
[ib,jb]=size(asyid);
j16=jb/16;
jj=(30:-2:0)';
jj=10.^jj;
ibu=zeros(ib,j16);
for i=1:j16
  ibu(:,i)=asyid(:,16*i-15:16*i)*jj;
end
