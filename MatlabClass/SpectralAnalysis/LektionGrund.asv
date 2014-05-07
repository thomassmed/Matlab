%% Generera en testsignal (fyrkantvåg)
t=0:0.01:100;
t=t';
x=square(0.1*pi*t);
y=sign(cos(0.1*pi*t));
figure
plot(t,x);
ylim([-1.4 1.4])
hold all
%%
i=0;
w=0;
nn=1:2:1000;nn=nn';
%%
i=i+1;w=w+4/pi*sin(nn(i)*0.1*pi*t)/nn(i);
delete(gcl)
plot(t,w)
shg
%%
X=fft(x);
hold off
plot(abs(X));shg
%%
[abs(X(6)./X(6:10:96))]
%%
spectrum(x);shg
%%
L=length(X);
l=round((L+1)/2);
f=linspace(0,1,l)*100;
semilogy(f,abs(X(1:l)).^2,'r')
%ax=axis;ax(3)=1e-4;axis(ax);shg
%% Jämför med 'cos'
hold off
h=plot(t,x);
set(h,'linew',2);
hold on
plot(t,y,'r');
ylim([-1.1 1.1])
%% Titta på fft-komponenterna
Y=fft(y);
figure
compass(X(6))
hold on
compass(Y(6),'r')
%% Vad händer om vi kör fyrkantvågen genom lågpassfiltret 1/(1+s)?
G=tf(1,[1 1])
ys=lsim(G,x,t);
hold off
plot(t,x);
hold on
plot(t,ys,'r')
ylim([-1.1 1.1])
%% 
Ys=fft(ys);
hold off
compass(X(6));
hold on
compass(Ys(6),'r');
compass(X(16),'g');
compass(Ys(16),'k')


