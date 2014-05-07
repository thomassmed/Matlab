t=0:0.01:10000;
t=t';
N=length(t);
%%
u=randn(N,1);
%plot(t,u);shg
%%
T1=tf(1,[1 1])
y=lsim(T1,u,t);
U=fft(u);
Y=fft(y);
U((N+1)/2:(N+1)/2+1)
Fs=1/t(2);
Ts=1/Fs;
%%
Fn=Fs/2;
f=linspace(0,Fn,(N+1)/2);
w=2*pi*f;
G=1./(1+1j*w);
%figure
hold off
loglog(f,abs(Y(1:(N+1)/2)./U(1:(N+1)/2)))
hold on
loglog(f,abs(G),'r')
%%
[mag,pha]=bode(T1,w);
mag=squeeze(mag);
pha=squeeze(pha);
loglog(f,mag,'g')
