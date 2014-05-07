function y=firstorder(u,a,b,y0,k,foh)
% firstorder - simulation of first order discrete 
%              linear system y(n+1)=a*y(n)+b*u(n-k)
%  
% Input:
%    u  -  Input signal
%    a  -  a in: y(n+1)=a*y(n)+b*u(n-k)
%    b  -  b in the equation above, default b=1-a
%    y0 -  start value, y(0), default y(0)=0
%    k  -  Pure time delay, default 0
%   foh -  Flag for First-Order-Hold, default false
%
% Output
%   y   - Simulated output
%
% Example:
%   u=randn(1000,1);a=exp(-1/30);y=firstorder(u,a);

if nargin<3, b=1-a;end
if nargin<4, y0=0;end
if nargin<5, k=0; end
if nargin<6, foh=false;end

if ischar(foh),
    if strcmpi(foh,'foh'), 
        foh=true;
    else
        foh=false;
    end
end

y=zeros(size(u));

if nargin>3, y(1)=y0;end
if nargin>4, y(2:(k+1))=y0; end

TTs=-1/log(a);
K=b/(1-a);
if foh
    Ku1mu0=K*(1-TTs+TTs*a);
else
    Ku1mu0=0;
end

for i=2+k:length(u),
    u0=u(i-1-k);u1mu0=u(i-k)-u0;
    y(i)=a*y(i-1)+b*u0+Ku1mu0*u1mu0;
end
