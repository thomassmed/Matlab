%% Exercise 9b.1
A=[0      1
  -1.01  -.2];
eig(A)
%% What happens with the eigenvalues if you compute eig(A-a*eye(2))
% Try with a=1, 1i, 0.5+0.5i
I=eye(2);
eig(A-I)
eig(A-1i*I)
eig(A-(0.5+0.5i)*I)
%% Exercise 9b.2 
lam=2i;
v=[1;1];
%% Repeat this cell until convergence
for i=1:4,
v=(lam*I-A)\v;
v=v/norm(v);
lam=v'*A*v
err=abs(-.1+1i-lam)
end