function [X1nm,Y1nm,X2nm,Y2nm,Cn,kinf_]=eq_xy(NEIG,hx,hz,d1,d2,usig1,usig2,...
siga1,sigr,siga2,a11,a21,a22,fi1,fi2,keff,cp,al,b,lam)
% 

global geom
ntot=geom.ntot;

if nargin>17
  alfapre=1-sum(b)+sum(al.*b./(al+lam));
  alfapre=alfapre.';
else
  alfapre=1;
end

rver=hx^2/hz^2;

rinf=sigr./siga2;                                % Eq. (20)
kinf=alfapre.*(usig1+rinf.*usig2)./(siga1+sigr);  % alfa=1 for stat case
tau=d1./(siga1+sigr);
L2=d2./siga2;
Xsi=L2./tau;


l2=hx*hx/(2+rver);                            % Eq. (21)
%b12=l2/4*(kinf-1)./(L2+tau);
b12=l2/4*(kinf/keff-1)./(L2+tau); %TODO: testa detta
b22=3/4*l2*(1+Xsi)./L2;

t1=1-b12/3;                                   % Eq. (22)
sn=1+2/3*b12;
b2=sqrt(b22);
t2=b2-cp*(b2-t1);
d1_=d1.*t1;
d2_=d2.*t2;
d1_=sqrt(d1_);
d2_=sqrt(d2_);


d1r=hx/4*(1-a11)./(1+a11);                    % Eq. (23)
d1r(:,5:6)=hz/hx*d1r(:,5:6);
d2r=hx/4*(1-a22)./(1+a22);
d2r(:,5:6)=hz/hx*d2r(:,5:6);
C21=8/hx*a21./(1-a11)./(1-a22);
C21(:,5:6)=hx/hz*C21(:,5:6);

rn=fi2./fi1;                                  % Eq. (24)

qn=1+Xsi./(1+Xsi).*(rn./rinf-1);               % Eq. (25)

zN1=zeros(ntot+1,1);
d1_m=zN1;d1_m(1:ntot)=d1_;
d2_m=zN1;d2_m(1:ntot)=d2_;
qm=zN1;qm(1:ntot)=qn;
rinfm=zN1;rinfm(1:ntot)=rinf;
sm=zN1;sm(1:ntot)=sn;


X1nm=zeros(ntot,6);
Y1nm=X1nm;X2nm=X1nm;Y2nm=X1nm;

for i=1:6,                                 % Eq 17
  Rnm=1;
  if i>4, Rnm=rver;end
  Ni=NEIG(:,i);
  X1nm(:,i)=Rnm/hx/hx*d1_.*d1_m(Ni).*qn.*sn;
  Y1nm(:,i)=Rnm/hx/hx*d1_.*d1_m(Ni).*qm(Ni).*sm(Ni);
  X2nm(:,i)=Rnm/hx/hx*d2_.*d2_m(Ni).*qn.*sn.*rinf;
  Y2nm(:,i)=Rnm/hx/hx*d2_.*d2_m(Ni).*qm(Ni).*sm(Ni).*rinfm(Ni);
  %
  % Boundary nodes (Note that d1_ is sqrt(Ddot))!
  irand=find(Ni==(ntot+1));
  D1n=d1_(irand).^2;D1r=d1r(irand,i);qr=qn(irand);
  sr=sn(irand);rinfr=rinf(irand);
  D2n=d2_(irand).^2;D2r=d2r(irand,i);C21r=C21(irand,i);
  if ~isempty(irand), 
    X1nm(irand,i)=Rnm*2/hx/hx.*D1n.*D1r./(D1n+D1r).*qr.*sr;
%  X2nm(irand,i)=Rnm*2/hx/hx*qr.*sr.*rinfr.*...
%  (D2n.*D2r./(D2n+D2r)-C21r./rinfr./(1./D1n+1./D1r)./(1./D2n+1./D2r));
    X2nm(irand,i)=Rnm*2*qr.*sr.*D2n.*D2r./(hx*hx*(D2n+D2r)).*...
    (rinfr-C21r.*D1n.*D1r./(D1n+D1r));
  end
end

Cn=d1_./t1./sn./tau./qn;
kinf_=alfapre.*(usig1+rn.*usig2)./(siga1+sigr);