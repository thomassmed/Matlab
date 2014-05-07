%%
T=3;
dt=t(2)-t(1);
a=exp(-dt/T);
b=1-a;
y=firstorder(Qt,a,b);
y=y+0.036*Qt;
hold off
plot(t,Qc);
hold on
plot(t,y,'r')
figure(gcf)