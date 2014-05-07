function [keffn,fa1,fa2,pow]=solv_fi(keff,fa1,fa2,qtherm,NEIG,usig1,...
usig2,siga1,sigr,siga2,ny1,ny2,d1,d2,hx,hz,a11,a21,a22,cp);
%[keffn,fa1,fa2,pow]=solv_fi(keff,fa1,fa2,qtherm,NEIG,usig1,...
%usig2,siga1,sigr,siga2,ny1,ny2,d1,d2,hx,hz,a11,a21,a22,cp);

% tolerances and iteration parameters
global msopt geom

gamma=msopt.PowerVoidNeuGamma;
pmax=msopt.PowerVoidNeuMaxiter;
tol=msopt.PowerVoidNeuTol;
dispmode=msopt.PowerVoidNeuDisp;

ntot=geom.ntot;

if ~strcmp(dispmode,'off')
  disp('Neutronic Solution:')   
  disp('It. nr         keff        Distance from Singularity')
  disp('-------+------------------+---------------')
end

la=tol+tol; x=fa1; n=0;
while abs(la)>tol
  [X1nm,Y1nm,X2nm,Y2nm]=eq_xy(NEIG,hx,hz,d1,d2,usig1,usig2,siga1,...
  sigr,siga2,a11,a21,a22,x,fa2,cp);
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
  la_scale=2.5;
  keff=keff-la*la_scale;
  n=n+1;
  if ~strcmp(dispmode,'off')
     disp(sprintf('%4.0f %14.5f %16.5f',n,keff,la_scale*la))
  end
  fa1=x*mean(fa1)/mean(x);
  fa2=eq_FA2(X2nm,Y2nm,NEIG,fa1,siga2,sigr);
  pow=eq_fisspow(fa1,fa2,usig1./ny1/keff,usig2./ny2/keff,hx,hz);
  Qth=sum(pow);
  fa1=fa1*qtherm/Qth;
  fa2=fa2*qtherm/Qth;
  pow=eq_fisspow(fa1,fa2,usig1./ny1/keff,usig2./ny2/keff,hx,hz);
end
keffn=keff;

%@(#)   solv_fi.m 1.4   02/02/20     16:51:22
