function y=clsim(u,Tp,Tz,K,Ts,Td,y0,zoh)
% clsim - simulation of first order continuous linear system
% 
%             1+Tz*s                                                            
% G(s) = K  * ---------- * exp(-Td*s)                                            
%             1+Tp*s                        
% 
%  
% Input
%    u  - input signal given at equidistant points in time
%    Tp - Time constant in the denominator
%    Tz - Time constant in the numerator (default 0)
%     K - Amplification (default 1)
%    Ts - Sampling time (default 1)
%    Td - Pure delay (default 0)
%    y0 - y(0), initial value on y (default 0)
%   zoh - Flag to decide if Zero-order-hold should be applied.(default
%         false). If flag is not set or set to false or 0, First-Order-Hold
%         is used.
%
% Example
% 
%  t=0:0.01:1;u=sin(2*pi*t);y=clsim(u,1,0,1,0.01);
%

[n,m]=size(u);
tflag=0;
if n==1, u=u(:);tflag=1;end
y=zeros(size(u,1),1);

if nargin<3, Tz=0; end
if nargin<4, K=1;end
if nargin<5, Ts=1; end
if nargin<6, Td=0;end
if nargin<7, y0=0;end
if nargin<8, zoh=false;end

if isempty(Tz), Tz=0;end
if isempty(K), K=1;end
if isempty(Ts), Ts=1;end
if isempty(Td), Td=0;end
if isempty(y0), y0=0;end
if isempty(zoh), zoh=false;end

if ischar(zoh)
    if strcmpi(zoh,'zoh')
        zoh=true;
    else
        zoh=false;
    end
end


K1=K.*(1-Tz./Tp);
Kd=K.*Tz./Tp;

a=exp(-Ts./Tp);
b=K1.*(1-exp(-Ts./Tp));


k=ceil(Td/Ts+0.49);


for i=1:length(a),
    y=y+firstorder(u(:,i),a(i),b(i),y0,k(i),~zoh);
end

for i=1:length(k),
    y(1+k(i):end)=y(1+k(i):end)+Kd(i)*u(1:end-k(i),i);
end

if tflag, y=y.';end