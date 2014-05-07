function yhat=DoubleExp(p,x,y)

if nargin<3,
    errflag=false;
else
    errflag=true;
end

yhat = p(1)*exp(p(2)*x)+p(3)*exp(p(4)*x);

if errflag,
    yhat=norm(yhat-y);
end


