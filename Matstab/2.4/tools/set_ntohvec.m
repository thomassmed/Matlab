function y = set_ntohvec(neutvec,ihydr,col);
%
% y = set_ntohvec(neutvec,ihydr,col)
%
% INDATA : Bränsletemperaturen som en N x 1 vektor samt hur många kolumner
%          man önskar att den skall ha.      
%
% UTDATA : Bränsletemperaturen som N/col x col vektor.
%

%@(#)   set_ntohvec.m 2.3   02/02/27     12:05:06

if nargin < 3
  col=1;
end

global geom 

kan=geom.kan;
ncc=geom.ncc;
nsec=geom.nsec;

n=hist(ihydr,1:ncc);
ni=find(n>1);

y = reshape(neutvec,col,kan*nsec(5));
y = y';

temp = zeros((ncc+1)*nsec(5)+ncc+1+sum(nsec(1:4))+nsec(6)+6,col);
 
for j=1:col
  temp1 = reshape(y(:,j),nsec(5),kan);
 
  for i=1:length(ni)
    q=find(ihydr==ni(i));
    temp1(:,q)=mean(temp1(:,q)')'*ones(1,length(q));
  end

  temp2(:,ihydr)=temp1;
  temp1=[temp2  zeros(nsec(5),1)]';
  temp1 = temp1(:);
  temp1 = [zeros(1,sum(nsec(1:4)+1)+1+ncc+1) temp1' zeros(1,nsec(6)+1)];
  temp(:,j) = temp1';
end
y = temp;

return;
