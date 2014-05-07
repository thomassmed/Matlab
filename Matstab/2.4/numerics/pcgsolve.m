function x = pcgsolve(A,b,x0,tol,maxiter,disp_mode,l,u)
%x = cgsolve(A,b,x0,tol,maxiter,disp_mode)
%Solve A*x = b for real matrices

%@(#)   cgsolve.m 1.3   96/12/12     13:26:46

n = length(b);

if nargin<3,
  x0=sparse(length(j1),1);
elseif nargin<4,
  tol=1e-2;
  maxiter = 30;
  disp_mode=0;
elseif nargin<5,
  maxiter = 30;
  disp_mode=0;
elseif nargin<6,
  disp_mode=0;
end

x = x0;
r = u\(l\(b-A*x));
rtr = r'*r;
p = zeros(size(b));
bet = 0;

num = 0;
while (norm(b-A*x) > tol*norm(b)),
  p = r + bet*p;
  Ap = u\(l\(A*p));
  alpha = rtr/(p'*Ap);
  x = x + alpha*p;
  r = r - alpha*Ap;
  rtrold = rtr;
  rtr = r'*r;  
  bet = rtr/rtrold;
  if disp_mode,
    num = num + 1;
    disp(['Iter.no : ' num2str(num) ' Err: ' num2str(norm(b-A*x)/norm(b))])
  end
  if num==maxiter,break,end
end





