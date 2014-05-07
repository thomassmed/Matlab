function y=modulo(x,n)
%y=mod(x,n)
%Beräknar resten av x/n
y=round(n*(x/n-floor(x/n)));
