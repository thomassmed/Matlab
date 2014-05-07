%% Generera en ren sinus
Ts=0.01;Fs=1/Ts;
t=0:Ts:10;
t=t';
w0=pi;
u=sin(w0*t);
plot(t,u)
hold all
%% Filtrera sinusen med filtret 1/(sT+1)
T=0.2;
y=clsim(u,T,0,1,Ts);
plot(t,y)
%% Beräkna FFT
U=fft(u);
Y=fft(y);
%% Överföringsfunktionen vid aktuell frekvems
Gw=1/(1+1j*T*w0)
%% 
plot(t,abs(Gw)*sin(w0*t+angle(Gw)))
%%
figure
[dum,imax]=max(abs(U));
compass(U(imax))
hold on
compass(Y(imax),'g')
compass(U(imax)*Gw,'r')
legend('U(jw0)','Y(jw0)','U(jw0)*G(jw0)')

