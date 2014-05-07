% Övning 1 - VBJ <Att förstå dynamik med Matlab> 2014-01-27

clear all;
h = 0.001;
t = 0:h:5;

%Exakt
N = exp(-t);

%Euler framåt
nEF = zeros(size(t));
nEF(1) = 1;

%Euler framåt
nEB = zeros(size(t));
nEB(1) = 1;

for i=1:length(t)-1
    nEF(i+1) = nEF(i)-h*nEF(i);
    nEB(i+1) = nEF(i)/(1+h);
end

plot(t,N,'k',t,nEF,'b',t,nEB,'r')
legend('Exakt','Euler framåt','Euler bakåt')