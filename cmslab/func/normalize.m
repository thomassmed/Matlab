function y=normalize(x)
% y=normalize(x);
%
n=length(x);
y=x-ones(n,1)*mean(x);
y=y./(ones(n,1)*std(y));
