function err=doubexp(p,x,y)
yhat=p(1)*exp(p(2)*x)+p(3)*exp(p(4)*x);
if nargin>2
    err=norm(y-yhat);
else
    err=y;
end