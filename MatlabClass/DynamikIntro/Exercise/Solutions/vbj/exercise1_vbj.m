% Övning 1 - VBJ <Att förstå dynamik med Matlab> 2014-01-27
%
% Lös differential ekvationen dN/dt = -N
% exakt)        N(t) = exp(-t)
% euler framåt) N(t+h) = N(t) - h*N(t)
% euler bakåt)  N(t) = N(t-h)/(1+h)

clear all;
h = 0.001;                              %tidssteg
t = 0:h:5;                              %tidsvektor

N = exp(-t);                            %Exakt lösning

[nEF,nEB] = deal(zeros(size(t)));       %pre-allokering
[nEF(1),nEB(1)] = deal(1);              %initialvärden

for i=1:length(t)-1
    nEF(i+1) = nEF(i)-h*nEF(i);         %Euler framåt
    nEB(i+1) = nEF(i)/(1+h);            %Euler bakåt
end

plot(t,N,'k',t,nEF,'b',t,nEB,'r')
legend('Exakt','Euler framåt','Euler bakåt')