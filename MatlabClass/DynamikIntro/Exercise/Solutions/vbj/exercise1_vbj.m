% �vning 1 - VBJ <Att f�rst� dynamik med Matlab> 2014-01-27
%
% L�s differential ekvationen dN/dt = -N
% exakt)        N(t) = exp(-t)
% euler fram�t) N(t+h) = N(t) - h*N(t)
% euler bak�t)  N(t) = N(t-h)/(1+h)

clear all;
h = 0.001;                              %tidssteg
t = 0:h:5;                              %tidsvektor

N = exp(-t);                            %Exakt l�sning

[nEF,nEB] = deal(zeros(size(t)));       %pre-allokering
[nEF(1),nEB(1)] = deal(1);              %initialv�rden

for i=1:length(t)-1
    nEF(i+1) = nEF(i)-h*nEF(i);         %Euler fram�t
    nEB(i+1) = nEF(i)/(1+h);            %Euler bak�t
end

plot(t,N,'k',t,nEF,'b',t,nEB,'r')
legend('Exakt','Euler fram�t','Euler bak�t')