function Aij=subset(A,i,j);

% Aij=subset(A,i,j);
% Aij=A(i,j);
% avoids a time consuming bug in MATLAB
% for very sparse matrizes
%
% try
% n=100000;
% j=2:2:n;
% D=sparse(j,j,1,n,n);
% tic,subset(D,j,j);toc
% tic,D(j,j);toc



[n,m]=size(A);
if n>m
  shift=sparse(1:n,1,1,n,m);
else
  shift=sparse(1,1:m,1,n,m);
end
A=A+shift;
Aij=A(i,j)-shift(i,j);



