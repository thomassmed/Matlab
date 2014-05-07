%% Exercise 1
% Parameters
al=log(2)/8;
beta=0.00600;
L=1.6825e-5;
y0=[1;beta./al/L];
[t,y]=ode15s(@pointk,[0 60],y0);
figure
plot(t,y(:,1));
xlabel('time (s)');
ylabel('Relative power (-)')
title('Power with 80 pcm excess reactivity')
grid
shg
%% Exercise 2
raa=0.00080;
A=[(raa-beta)/L  al
    beta/L     -al];
e=eig(A)
p2=e(2);
T=log(2)/p2
%% Exercise 3a
y1=exp(t*p2);
hold on
plot(t,y1,'r');
shg
%% Exercise 3b
plot(t,y1*1.15,'x')
shg
%% Exercise 4
figure
plot(10:100,dub2raa(10:100))
grid
xlabel('Doubling time (s)');
ylabel('Reactivity (pcm)');
shg
%% Exercise 5a
[t,y]=ode15s(@pointk,[0 60],[1;beta/L/al]);
[t1,rho,conc]=inv_kinetics(t,y(:,1));
figure
plot(t1,rho)
grid
xlabel('Time (s)');
ylabel('Reactivity (pcm)');
shg
%% Exercise 5b
[t1,rho1,conc1]=inv_kinetics(t,y(:,1),beta,al);
plot(t1,rho1)
grid
xlabel('Time (s)');
ylabel('Reactivity (pcm)');
shg
%% Exercise 5c
figure
plot(t1,conc1,'linewidth',2)
hold on
plot(t,y(:,2),'r');
grid
xlabel('Time (s)');
ylabel('Relative Precursor conc (-)');
shg