function J=jacobian(f,x0,p1,p2,p3,p4,p5)
% J=jacobian(f,x0,p1,p2,...)
% Beräknar systemmatrisen eller Jacobianen av
% ett system beskrivet i filen 'f'
% dvs y=f(x,p1,p2)
%
if nargin==2,
  y0 = feval(f,x0);
elseif nargin==3,
  y0 = feval(f,x0,p1);
elseif nargin==4,
  y0 = feval(f,x0,p1,p2);
elseif nargin==5,
  y0 = feval(f,x0,p1,p2,p3);
elseif nargin==6,
  y0 = feval(f,x0,p1,p2,p3,p4);
elseif nargin==7,
  y0 = feval(f,x0,p1,p2,p3,p4,p5);
end
y0=y0(:);

h=1e-4;
for n=1:length(x0),
  x=x0;
  delta=h*x(n);
  if delta<1e-15,delta=h;end
  x(n)=x(n)+delta; 
  if nargin==2,
    y=feval(f,x); 
  elseif nargin==3,
    y = feval(f,x,p1);
  elseif nargin==4,
    y = feval(f,x,p1,p2);
  elseif nargin==5,
    y = feval(f,x,p1,p2,p3);
  elseif nargin==6,
    y = feval(f,x,p1,p2,p3,p4);
  elseif nargin==7,
    y = feval(f,x,p1,p2,p3,p4,p5);
  end
  y=y(:); 
  J(:,n)=(y-y0)/delta;
end
