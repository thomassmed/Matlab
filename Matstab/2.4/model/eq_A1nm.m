function A1nm=eq_A1nm(NEIG,X1nm,Y1nm,X2nm,Y2nm,usig2,usig1,siga1,...
sigr,siga2,keff,al,b,lam,regio);
% A1nm=eq_A1nm(NEIG,X1nm,Y1nm,X2nm,Y2nm,usig2,usig1,siga1,sigr,siga2,keff,al,b,lam);

global geom 

kmax=geom.kmax;
ntot=geom.ntot;

if nargin>11
  alfapre=1-sum(b)+sum(al.*b./(al+lam));
  alfapre=alfapre.';
else
  alfapre=1;
end

if nargin<15, regio=0;end

rinf=sigr./siga2;                                % Eq. (20)
kinf=alfapre.*(usig1+rinf.*usig2)./(siga1+sigr);  % alfa=1 for stat case

gn=alfapre.*usig2./(keff*siga2);

denAnm=zeros(ntot,1);
for i=1:6,
  denAnm=denAnm+X1nm(:,i)+gn.*X2nm(:,i);
end
denAnm=denAnm-(siga1+sigr).*(kinf/keff-1);

Anm=sparse(ntot,ntot);
for i=1:6,
  iAnm=find(NEIG(:,i)~=ntot+1);
  jAnm=NEIG(iAnm,i);
  xAnm=(Y1nm(iAnm,i)+gn(iAnm).*Y2nm(iAnm,i))./denAnm(iAnm);
  if i==4&regio>0,                    % Regional mode in half-core symmetry
    xAnm(1:kmax*30)=-xAnm(1:kmax*30);
 end
  Anm=Anm+sparse(iAnm,jAnm,xAnm,ntot,ntot);
end

Anmdi=spdiags(ones(ntot,1),0,ntot,ntot);
%Anmdi=spdiags(denAnm,0,ntot,ntot);

A1nm=Anmdi-Anm;

%@(#)   eq_A1nm.m 1.2   98/03/13     10:54:39


