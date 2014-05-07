%% Euler forward could be used
al=log(2)/8;
beta=0.00600;
L=1.6825e-05;
y0=[1;beta/al/L];
%%
dt=0.001;
t=0:dt:60;
Y=zeros(2,length(t));
Y(:,1)=y0;
for i=2:length(t)
    Y(:,i)=Y(:,i-1)+dt*pointk(t(i),Y(:,i-1));
end
plot(t,Y(1,:))
shg