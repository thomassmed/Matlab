function [keff,fa1,fa2,pow,r,raa,Sn,C1nm,C2nm,Fiss,Leak,Absorp,la,kef,keffp,J1nm,J2nm,Anm,SC1,SC2]=solv_neu3(keff,fa1,fa2,qtherm,NEIG,usig1,...
usig2,siga1,sigr,siga2,ny1,ny2,d1,d2,hx,hz,a11,a21,a22,DF1,DF2,tol,C1nm,C2nm,Sn)

% tolerances and iteration parameters
global msopt

gamma=msopt.PowerVoidNeuGamma;
pmax=msopt.PowerVoidNeuMaxiter;
fix_iter=0;
if nargin<21,
   tol=msopt.PowerVoidNeuTol;
elseif tol>0.9
    fix_iter=1;
    n_iter=tol;
    tol=1e-10;
end
dispmode=msopt.PowerVoidNeuDisp;
%dispmode='on';


if ~strcmp(dispmode,'off')
  disp('Neutronic Solution:')   
  disp('It. nr         keff        Distance from Singularity')
  disp('-------+------------------+---------------')
end


ntot=length(d1(:));
if ~exist('C1nm','var'),
    C1nm=nan(size(NEIG));C2nm=C1nm;Sn=ones(ntot,1);
end
x=fa1.*Sn;psi=x;
n=0; r=fa2./fa1;
w_spc=1;
w_psi=1;
for ii=1:20
    psi_old=psi;
    r_old=r;
    [Anm,r,raa,Sn,C1nm,C2nm,J1nm,J2nm,SC1,SC2]=eq_neu3(NEIG,hx,hz,d1,d2,usig1,usig2,siga1,...
        sigr,siga2,a11,a21,a22,psi,r,keff,DF1,DF2,C1nm,C2nm);
    r=w_spc*r+(1-w_spc)*r_old;
    for p=1:pmax,
        if p/2==round(p/2),
            wp=gamma*(1-cos((p-1)*pi/2/pmax))-1;
        else
            wp=gamma*(1+cos((p)*pi/2/pmax))-1;
        end
        x=Anm*x-wp*x;
        x=x/(1-wp);
    end
    x_old=psi_old/mean(psi_old)*mean(x);
    x=w_psi*x+(1-w_psi)*x_old;
    if ii>1,
        idamp=find(abs(x-x_old)>0.5*x_old);
        x(idamp)=0.5*x(idamp)+0.5*x_old(idamp);
    end
    la(ii)=(x'*Anm*x)/(x'*x);    
    la_scale=2;
    kef(ii)=keff;
    keff=keff-(1-la(ii))*la_scale;
    fa1=x./Sn;
    fa2=fa1.*r;
    pow=eq_fisspow(fa1,fa2,usig1./ny1/keff,usig2./ny2/keff,hx,hz);
    Qth=sum(pow);
    fa1=fa1*qtherm/Qth;
    fa2=fa2*qtherm/Qth;
    psi=fa1.*Sn;
    pow=eq_fisspow(fa1,fa2,usig1./ny1/keff,usig2./ny2/keff,hx,hz);
    Absorp=(siga1+sigr).*fa1;
    Fiss=usig1.*fa1+usig2.*fa2;
    Leak=zeros(ntot,6);
    for i=1:6,
        ibound=find(NEIG(:,i)==ntot+1);
        Leak(ibound,i)=C1nm(ibound,i).*psi(ibound);
    end
    keffp(ii)=sum(Fiss)/(sum(Absorp)+sum(sum(Leak)));
    %keff=keffp(ii);
    n=n+1;
    if ~strcmp(dispmode,'off')
        disp(sprintf('%4.0f %12.5f %12.5f %16.10f %10.4g %10.4g %10.4g',n,keff,keffp(ii),1-la(ii),sum(Fiss),sum(Absorp),sum(sum(Leak))))
    end
    if fix_iter&&n==n_iter, break;end
end
