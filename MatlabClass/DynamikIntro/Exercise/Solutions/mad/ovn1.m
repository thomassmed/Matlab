%%
%Exakt lösning
dt=0.01;
t=0:dt:5;
N=exp(-t);

plot(t,N)
shg
%%
%Euler framåt
clear N1
N1(1)=1;

for i=2:length(t)
    N1(i)=N1(i-1)-dt*N1(i-1);
end
hold on
plot(t,N1,'r');
shg

%%
% Euler bakåt
clear N2
N2(1)=1;
for i=2:length(t)
    N2(i)=N2(i-1)/(1+dt);
end
plot(t,N2,'g');
hold off
shg
legend('Exakt','Framåt','Bakåt')