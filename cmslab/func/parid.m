function [num,den]=parid(z,ord,T);
%Identifiering av process vid knd insignal och utsignal
%
%          num(s) 
% y(t) =  ------ u(t)
%          den(s)
%
%[num,den]=parid(z,ord,T)
%
%z=[y u] dr y r utsignal och u r insignal
%ord=[na nb nc nk] och r identifieringspolynomets ordning
%T r samplingstiden
%
%Identifiering grs med armax-modell dr identifieringspolynomet
%bestms av ordningen [na nb nc nk] fr systemet
%
%       a(q)y(t)=b(q)u(t-nk)+c(q)e(t)
z=detrend(z,0);
th=armax(z,ord,-1,-1,-1,-1,T);
e=resid(z,th);
pause
zpplot(zp(th))
pause
%
svar=input('Simulering? [j/n] :','s');
x=strcmp('j',svar);
while x==1
s1=input('Startsampel :');
s2=input('Slutsampel :');
y=z(:,1);
u=z(:,2);
yh=idsim(u,th);
plot([y(s1:s2) yh(s1:s2)])
title('Simulated(gr) and real output(r)')
pause
svar=input('Simulering? [j/n] :','s');
x=strcmp('j',svar);
end
%
[num,den]=contin(th);
