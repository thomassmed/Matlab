I=150;
Pr=1.3e6;
wR=1500/60*2*pi;
H=I*wR*wR/2/Pr
%%
delta=20*pi/180;
[t,y]=ode45(@(t,y) Diesel(t,y,H,delta),[0 5],[delta;0]);
plot(t,sin(y(:,1))-sin(y(1,1)))