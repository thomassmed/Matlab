function [y,dy]=desh(x,Ts,r0,type)
% [y,dy]=desh(x,Ts,r0,type) , Avtrendar x linjärt
% y är den avtrendade signalen
% dy är estimerade derivatan på den linjära trenden
% x - insignal
% Ts - samplingstid (default Ts=1)
% r0 - gräns för variable forgetting (g=0.99 eller g=0.95)
% default är 0.02 * Ts
% type='cmex' ger en snabbare beräkning  (r0=[])
if nargin==4,
error('Not implemented!')
%  [y,dy]=deshc(x,Ts);
%  return
end
g=0.995;
x=x(:)';
lx=length(x);
a0=x(1);
a1=0;
y(1)=0;
y=zeros(lx,1);
dy=zeros(lx,1);
w=0;
g1=0.85;
g2=0.85;
da1=0;
r=0;
gg(1)=0.99;
if nargin<2,
  Ts=1;
elseif nargin<3,
  r0=0.02*Ts;
end 

for n=2:lx,
  gg(n)=g;
  e=x(n)-a0-a1;
  a0=a0+a1+(1-g^2)*e;
  a1_old=a1;
  a1=a1+(1-g)^2*e;
  y(n)=x(n)-a0;
  dy(n)=a1/Ts;

  da1_old=da1; 
  da1=a1-a1_old;
  w_old=w;
  w=g1*w_old+da1_old;
  r_old=r;
  r=g2*r_old+(1-g2)*sign(da1)*w_old;
  if r_old>r0,
    g=0.95;
  else
    g=0.996;
  end
end 
