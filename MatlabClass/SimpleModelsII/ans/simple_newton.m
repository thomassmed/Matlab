%%
tic
H=1200;
p=7e6;h=0.01;
T=250+273.13;
for i=1:10,
    TT(i)=T;
    f0=h_v(T,p)-H
    if abs(f0)<1e-6, break;end
    dfdT=(h_v(T+h,p)-H-f0)/h;
    dT=-f0/dfdT;
    T=T+dT;
end
toc