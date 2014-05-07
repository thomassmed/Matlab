function err=fit_sinus(p,t,y)
% yhat=fit_sinus(p,t)
% err=fit_sinus(p,t,y);
% p=[A fi f (m)], y=m+A*sin(2*pi*f*t+fi)
flag=true;
if nargin<3, flag=false;end

A=p(1);
fi=p(2);
f=p(3);
w=2*pi*f;
m=0;

if length(p)==4, m=p(4);end

yhat=m+A*sin(w*t+fi);

if flag,
    err=norm(yhat-y);
else
    err=yhat;
end
