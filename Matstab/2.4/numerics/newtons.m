function x=newtons(f,x0,tol,p1,p2,p3,p4,p5)
% x=newtons(f,x0,tol)
% Löser ekvationssystemet f(x)=0 med Newton-Raphson's metod
% Upp till 5 extra parametrar kan anges:
% t.ex;  x=newtons(f,x0,[],p1,p2,...)

if nargin<3 | isempty(tol),
  tol=1e-8;
end

err=1;
x=x0(:);
x_old=x;
maxiter=40;
n=0;
while err>tol,
  n=n+1;
  if nargin<4,
    y=feval(f,x_old);y=y(:);
    x=x_old-jacobian(f,x_old)\y;
  elseif nargin==4,
    y=feval(f,x_old,p1);y=y(:);
    x=x_old-jacobian(f,x_old,p1)\y;
  elseif nargin==5,
    y=feval(f,x_old,p1,p2);y=y(:);
    x=x_old-jacobian(f,x_old,p1,p2)\y;
  elseif nargin==6,
    y=feval(f,x_old,p1,p2,p3);y=y(:);
    x=x_old-jacobian(f,x_old,p1,p2,p3)\y;
  elseif nargin==7, 
    y=feval(f,x_old,p1,p2,p3,p4);y=y(:);
    x=x_old-jacobian(f,x_old,p1,p2,p3,p4)\y;
  elseif nargin==8,
    y=feval(f,x_old,p1,p2,p3,p4,p5);y=y(:);
    x=x_old-jacobian(f,x_old,p1,p2,p3,p4,p5)\y;
  end
  err=max(abs(x-x_old));
  if n==maxiter,
    disp('Konvergerar ej')
    return
  end
  x_old=x;
end


