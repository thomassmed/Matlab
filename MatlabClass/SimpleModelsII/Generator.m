function yp=Generator(t,y,tc,H,flag)

%%
if nargin<3, tc=0.15;end
if nargin<4, H=6;end
if nargin<5, flag=true;end

Pm=1;
Pemax=1.5557; % 1/sin(pi*40/180), 40 degrees
Vret=0.75;
Vend=1;

delta=y(1);
w=y(2);

if t>tc+0.5, 
    V=Vend;
elseif t>tc,
    V=Vend;
    %V=Vret+(t-tc)*(Vend-Vret)/.5;
elseif t<0,
    V=1;
else
    V=0;
end

D=3;
Pe=Pemax*V*sin(delta);
ddeltadt=2*pi*50*w;
dwdt=(Pm-D*w-Pe)/H/2;

if flag,
    yp=[ddeltadt;dwdt];
else
    yp=[V Pm Pe];
end
    

    