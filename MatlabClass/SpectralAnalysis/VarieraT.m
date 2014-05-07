%% Skapa ett första ordningens filter med tidskonstant T=1:
  %Variera T 
G=tf(1,[T 1]);
%% Filtrera det vita bruset med filtret
y=lsim(G,u,t);
%% Räkna ut spektrum för u och y samt för G
Hs=spectrum.cov(30);
U=psd(Hs,u,'Fs',Fs);
Y=psd(Hs,y,'Fs',Fs);
%% Plotta loglog istället
f=U.Frequencies;
w=2*pi*f;
g=1./(1+1j*T*w);
figure
loglog(U.Frequencies,real(abs(U.Data.*g.*g)));
hold all
loglog(Y.Frequencies,abs(Y.Data));
loglog(f,abs(g.*g*mean(abs(U.Data(2:5)))))
shg
title(['T=',num2str(T)])
grid