function [keff,fa1,fa2,pow,x,r,kinf_,Alfa_n,Cn,Prod,Leak,Absorp,la,kef,keffp,Anm]=solv_neu1(keff,fa1,fa2,qtherm,NEIG,usig1,...
usig2,siga1,sigr,siga2,ny,d1,d2,hx,hz,a11,a21,a22,cp,tol)

% tolerances and iteration parameters
global msopt

gamma=msopt.PowerVoidNeuGamma;
pmax=msopt.PowerVoidNeuMaxiter;
fix_iter=0;
if nargin<20,
   tol=msopt.PowerVoidNeuTol;
elseif tol>0.9
    fix_iter=1;
    n_iter=tol;
    tol=1e-10;
end
dispmode=msopt.PowerVoidNeuDisp;
dispmode='on';


if ~strcmp(dispmode,'off')
  disp('Neutronic Solution:')   
  disp('It. nr         keff        Distance from Singularity')
  disp('-------+------------------+---------------')
end

K1=3.2041e-11;
x=fa1; n=0;
ntot=length(d1(:));
r=fa2./fa1;
for ii=1:20
    rn_1=r;
    [Anm,Cn,r,kinf_,Alfa_n]=eq_neu1(NEIG,hx,hz,d1,d2,usig1,usig2,...
        siga1,sigr,siga2,a11,a21,a22,fa1,fa2,x,keff,cp);
    xn_1=x;
    for p=1:pmax,
        if p/2==round(p/2),
            wp=gamma*(1-cos((p-1)*pi/2/pmax))-1;
        else
            wp=gamma*(1+cos((p)*pi/2/pmax))-1;
        end
        x=Anm*x-wp*x;
        x=x/(1-wp);
     end
    la(ii)=(x'*Anm*x)/(x'*x);
    la_scale=2.24;
    kef(ii)=keff;
    keff=keff-(1-la(ii))*la_scale;
    x=0.95*x+0.05*xn_1;
    r=0.95*r+0.05*rn_1;
    pow=K1*kinf_.*Cn.*x./ny*hx*hx*hz;
    Qth=sum(pow);
    x=x*qtherm/Qth;
    pow=pow*qtherm/Qth;
    fa1=x.*Cn./(siga1+sigr);
    fa2=fa1.*r;
    Absorp=Cn.*x;
    Prod=kinf_.*Cn.*x;
    Prod=usig1.*fa1+usig2.*fa2;
    Absorp=fa1.*(siga1+sigr);
    Leak=sum(Alfa_n,2).*x/hx/hx;
    keffp(ii)=sum(Prod)/(sum(Absorp)+sum(Leak));
    n=n+1;
    if ~strcmp(dispmode,'off')
        disp(sprintf('%4.0f %12.5f %12.5f %17.10f %10.4g %10.4g %10.4g',n,keff,keffp(ii),1-la(ii),sum(Prod),sum(Absorp),sum(sum(Leak))))
    end
%    keff=keffp(ii);
    if fix_iter&&n==n_iter, break;end
end
