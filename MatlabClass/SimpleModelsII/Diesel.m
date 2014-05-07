function yp=Diesel(t,y,H,delta,flag)

if nargin<4, delta=15*pi/180; end
if nargin<5, flag=true;end
%%
tm=1;
Pm=1;
V=1;
Pemax=1/sin(delta); 
delta=y(1);
w=y(2);

if t>tm&&t<tm+1.5
    Pm=0.9;
end

D=12;
p=4; % Antalet poler på maskin
Pe=Pemax*V*sin(delta);
ddeltadt=p/2*2*pi*50*w;
dwdt=(Pm-D*w-Pe)/H/2;

if flag,
    yp=[ddeltadt;dwdt];
else
    yp=[V Pm Pe];
end
    

    