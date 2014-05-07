%@(#)   decomprebu.m 1.3	 06/02/10     10:47:53
%
function buidnt=decomprebu(ibu)
[ib,jb]=size(ibu);
jj=(30:-2:0)';
jj=10.^jj;
ibu0=ibu;
for i=1:jb
  ii=16*(i-1);
  for j=1:16,
    buidnt(:,ii+j)=floor(ibu(:,i)/jj(j));
    ibu(:,i)=ibu(:,i)-floor(ibu(:,i)/jj(j))*jj(j);
  end
  ibu=ibu0;
end
buidnt=setstr(buidnt);
