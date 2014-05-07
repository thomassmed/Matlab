function x=simple_newt(f,x0)
x=x0;
h=0.0001*max(abs(x));
for i=1:10,
    f0=f(x);
    if abs(f0)<1e-6, break;end
    dfdx=(f(x+h)-f0)/h;
    dx=-f0/dfdx;
    x=x+dx;
end