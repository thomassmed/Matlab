function [dr,fd,th]=iddrfd(y,ord,T);
%
% [dr,fd,th]=iddrfd(y,ord,T);
%
% Berknar DR och fd fr varje polpar ur en identifierad ARMA
% eller AR-modell med ordningen ord=[na nc].
% drfd r en n*2-matris med dr i frsta kolumnen och
% fd i den andra. th r parameterestimaten med estimerade
% kovarianser (theta-format). T r samplingstiden.
%
% Modellen beskrivs som A(q)y(t)=C(q)e(t) 
 
% Pr Lansker 15/4-91. 

y=y(:);
y=dtrend(y,1);
th=armax(y,ord,-1,-1,-1,-1,T);
poles=zp(th);
zpplot(th2zp(th),1);
poles=poles(2:2:length(poles),2);
[dr,fd]=p2drfd(poles,T);
