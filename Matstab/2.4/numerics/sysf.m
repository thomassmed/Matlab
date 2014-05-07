function [y,J]=sysf(x,qprimw,tw,P,chflow,flowb,Eci,Wbyp,Wfw,fwpos,Dh,A,V,Hz,pbm,Htc,qtrissl,Jscale)
%[y,J]=sysf(x,qprimw,tw,P,chflow,flowb,Eci,Wbyp,Wfw,fwpos,Dh,A,V,Hz,pbm,Htc,qtrissl,[Jscale]);
%
% Gives the time drivatives and the Jacobian matrix for mass and energy equations
% x is:
% k = get_corenodes;
% [kn,k0]=get_thneig(k);
% x = [mg(k0);romum(k0)];
%
% Called from thyd0

%@(#)   sysf.m 1.9   02/02/27     12:16:04

global geom termo
nin=geom.nin;
ncc=geom.ncc;
kmax=geom.kmax;

sx = length(x);
k1 = sx/2;

k = get_corenodes;
[kn,k0]=get_thneig(k);
Tsat0 = cor_tsat(P);

%Dynamic variables
mg = zeros(get_thsize,1);
mg(k0) = x(1:k1);mg = mg.*(mg>0);
romum = zeros(get_thsize,1);
romum(k0) = x((k1+1):sx);
romum(nin(5):nin(5+ncc))=Eci;

%Algebraic variables
[alfa,S,Wl,wl,Wg,wg,jm0,gammav,tl,phi0]=sysalg0(mg,romum,qprimw,tw,chflow,flowb,Wbyp,Wfw,fwpos,P,A,V,Hz);

y0 = eq_E(alfa,romum,Wl,Wg,tl,P,Tsat0,V,A);

Wlci = chflow - flowb;

%Jacobian matrix

if nargout>1,
  mg1 = mg + max(mg)/1e4;
  romum2 = romum + max(romum)/1e4;
  qprimw1= qprimw - (mg>0).*qprimw/1e4; % Stabilizing correction for power-void iteration

  %Finite differences
  [alfa1,Wl1,Wg1,gammav1,tl1,Wg1D,Wl1D]=sysalgfd(mg1,romum,phi0,jm0,qprimw1,tw,Wlci,Wbyp,Wfw,fwpos,P,A,V,Hz);
  [alfa2,Wl2,Wg2,gammav2,tl2,Wg2D,Wl2D]=sysalgfd(mg,romum2,phi0,jm0,qprimw,tw,Wlci,Wbyp,Wfw,fwpos,P,A,V,Hz);

  Y11 = (-(Wg1D) + Wg + (gammav1-gammav).*V)./(mg1-mg+eps);				%df1/d(mg)
  Y11n = (Wg1 - Wg)./(mg1-mg+eps);
  Y12 = (-(Wg2D) + Wg + (gammav2-gammav).*V)./(romum2-romum+1);				%df1/dE

  J11 = spdiags([Y11(k0),Y11n(kn)],[0,-ncc-1],k1,k1+ncc+1);J11 = J11(1:k1,1:k1);
  J12 = spdiags(Y12(k0),0,k1,k1);

  Y21 = (eq_E(alfa1,romum,Wl1,Wg1,tl1,P,Tsat0,V,A)-y0)./(mg1-mg+eps); 			%df2/d(mg)
  Y22 = (eq_E(alfa,romum2,Wl2D,Wg2D,tl2,P,Tsat0,V,A)-y0)./(romum2-romum+1);	%df2/dE
  Y22n = (eq_E(alfa,romum2,Wl2,Wg2,tl2,P,Tsat0,V,A)-y0)./(romum2-romum+1);

  J21 = spdiags(-Y21(k0),0,k1,k1);
  J22 = spdiags([-Y22(k0),Y22n(kn)],[0,-ncc-1],k1,k1+ncc+1);J22 = J22(1:k1,1:k1); 
  if ~exist('Jscale','var'), Jscale=1; end
  J = [J11,J12*Jscale;J21,J22*Jscale];
end

y = zeros(sx,1);
y(1:sx/2) = -Wg(k0) + Wg(kn) + gammav(k0).*V(k0);

%Gamma heat in liquid
q3l = qtrissl;

%Loss to bypass
kb = get_bnodes;kb(1)=[];
kc = get_chnodes;kc(1:ncc)=[];
tfl = tl;j1 = find(tl>Tsat0);tfl(j1) = Tsat0(j1);
tmp = reshape(tfl(kc),ncc,kmax) - ones(ncc,1)*tfl(kb)';
tfld = zeros(get_thsize,1);
tfld(kc) = reshape(tmp,kmax*ncc,1);
ych2bp = pbm.*Htc.*tfld.*Hz;
ych2bp(kb) = -sum(reshape(ych2bp(kc),ncc,kmax))';

y((sx/2+1):sx) = -y0(k0) + y0(kn) + qprimw(k0).*Hz(k0) + q3l(k0).*V(k0).*(1-alfa(k0)) - ych2bp(k0);







