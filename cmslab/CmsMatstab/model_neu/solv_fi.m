function [keffn,fa1,fa2,pow,Anm,J1nm,J2nm]=solv_fi(keff,fa1,fa2,qtherm,NEIG,usig1,...
usig2,siga1,sigr,siga2,ny1,ny2,d1,d2,hx,hz,a11,a21,a22,cp,tol)
%[keffn,fa1,fa2,pow]=solv_fi(keff,fa1,fa2,qtherm,NEIG,usig1,...
%usig2,siga1,sigr,siga2,ny1,ny2,d1,d2,hx,hz,a11,a21,a22,cp);

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

ntot=length(d1(:));

if ~strcmp(dispmode,'off')
  disp('Neutronic Solution:')   
  disp('It. nr         keff        Distance from Singularity')
  disp('-------+------------------+---------------')
end

la=tol+tol; x=fa1; n=0;
while abs(la)>tol
  [X1nm,Y1nm,X2nm,Y2nm,Cn,kinf_]=eq_xy(NEIG,hx,hz,d1,d2,usig1,usig2,siga1,...
  sigr,siga2,a11,a21,a22,fa1,fa2,keff,cp);
  A1nm=eq_A1nm(NEIG,X1nm,Y1nm,X2nm,Y2nm,usig2,usig1,siga1,sigr,siga2,keff);
  dA1nm=spdiags(A1nm,0);En=spdiags(dA1nm,0,ntot,ntot);Anm=A1nm-En;
  for p=1:pmax,
    if p/2==round(p/2),
      wp=gamma*(1-cos((p-1)*pi/2/pmax))-1;
    else
      wp=gamma*(1+cos((p)*pi/2/pmax))-1;
    end
    x=-Anm*x-wp*x;
    x=x/(1-wp);
  end
  la=(x'*A1nm*x)/(x'*x);
  la_scale=2.2;
  keff=keff-la*la_scale;
  n=n+1;
  %fa1=x.*Cn./(siga1+sigr);
  fa1=x;
  fa2=eq_FA2(X2nm,Y2nm,NEIG,fa1,siga2,sigr);
  pow=eq_fisspow(fa1,fa2,usig1./ny1,usig2./ny2,hx,hz);
  Qth=sum(pow);
  pow=pow*qtherm/Qth;
  fa1=fa1*qtherm/Qth;
  fa2=fa2*qtherm/Qth;
  x=x*qtherm/Qth;
  Absorp=Cn.*x;
  Absorp=fa1.*(siga1+sigr);
  Prod=kinf_.*Cn.*x;
  Prod=usig1.*fa1+usig2.*fa2;
  Leak=zeros(ntot,1);
  for i=1:6
      irefl=find(NEIG(:,i)==ntot+1);
      Leak(irefl)=Leak(irefl)+X1nm(irefl,i).*x(irefl);
  end
  keffp=sum(Prod)/(sum(Absorp)+sum(Leak));
  if ~strcmp(dispmode,'off')
     disp(sprintf('%4i %14.5f %14.5f %14.7g %12.3g %12.3g %12.3g',n,keff,keffp,la_scale*la,sum(Prod),sum(Absorp),sum(Leak)))
  end
  
  if fix_iter&&n==n_iter, break;end
end
keffn=keff;
J1nm=zeros(size(NEIG));J2nm=J1nm;
for i=1:6,
    J1nm(:,i)=X1nm(:,i).*fa1;
    J2nm(:,i)=X2nm(:,i).*fa1;
    i_int=find(NEIG(:,i)~=(ntot+1));
    J1nm(i_int,i)=J1nm(i_int,i)-Y1nm(i_int,i).*fa1(NEIG(i_int,i));
    J2nm(i_int,i)=J2nm(i_int,i)-Y2nm(i_int,i).*fa1(NEIG(i_int,i));
end