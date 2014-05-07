%% Generate white noise
Ts=0.001;Fs=1/Ts;
t=0:Ts:100;
t=t';
u2=23*randn(size(t));
%% Plot
figure
plot(t,u2)
hold all
shg
%% Create a first order filter with time constant T=1:
T=.2;  %Variera T 
G=tf(1,[T 1]);
%% Filter the white noise with the filter
y2=lsim(G,u2,t);
plot(t,y2,'r')
shg
%% Calculate a spectrum for U, Y and G
Hs=spectrum.cov(30);
U2=psd(Hs,u2,'Fs',Fs);
Y2=psd(Hs,y2,'Fs',Fs);
f=U2.Frequencies;
w=2*pi*f;
g=1./(1+1j*T*w);
%% Plot in loglog
figure
loglog(f,abs(Y2.Data));
title(['T=',num2str(T)])
grid
shg
%%
hold all
loglog(f,abs(U2.Data.*g.*g));
shg
%%
loglog(f,abs(g.*g))
shg




