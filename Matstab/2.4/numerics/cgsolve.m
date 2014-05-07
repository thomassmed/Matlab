function x = cgsolve(A,b,x0,tol,maxiter,disp_mode)
%x = cgsolve(A,b,x0,tol,maxiter,disp_mode)
%Solve A*x = b for real matrices


n = length(b);

if nargin<3,
  x0=sparse(length(j1),1);
elseif nargin<4,
  tol=1e-2;
  maxiter = 50;
  disp_mode=0;
elseif nargin<5,
  maxiter = 50;
  disp_mode=0;
elseif nargin<6,
  disp_mode=0;
end

x = x0;
r = b - A*x;
rtr = r'*r;
p = zeros(size(b));
bet = 0;

num = 0;
while (norm(r) > tol*norm(b)),
  p = r + bet*p;
  Ap = A*p;
  alpha = rtr/(p'*Ap);
  x = x + alpha*p;
  r = r - alpha*Ap;
  rtrold = rtr;
  rtr = r'*r;  
  bet = rtr/rtrold;
  num = num + 1;
  if disp_mode,
    disp(['Iter.no : ' num2str(num) ' Err: ' num2str(norm(r)/norm(b))])
  end
  if num==maxiter,break,end
end

%@(#)   cgsolve.m 1.2   98/04/02     07:58:12

