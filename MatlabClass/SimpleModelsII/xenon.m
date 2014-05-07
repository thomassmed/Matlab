function yp=xenon(t,y,sigXe,flag)
if nargin<4,
    flag=false;
end
Qrel=109;
if t>3000,
    Qrel=70;
end
%%
Qtot=3300*Qrel/109;
Rf=Qtot*1e6/3.2041e-11/62280000; %fission/cm3/s
fi2=4.5e13*Qrel/109;

lamI=1/6.57/3600*log(2);
lamXe=1/9.2/3600*log(2);

gamI=0.065;
gamXe=0.0026;
if nargin<3
    sigXe=1.21e-18;
    %sigXe=1.19e-18;
end
I=y(1);
X=y(2);
dIdt=gamI*Rf-lamI*I;
dXdt=gamXe*Rf+lamI*I-lamXe*X-sigXe*X*fi2;
yp(1,1)=dIdt;
yp(2,1)=dXdt;

if flag, yp=gamXe*Rf+lamI*I-sigXe*X*fi2;end