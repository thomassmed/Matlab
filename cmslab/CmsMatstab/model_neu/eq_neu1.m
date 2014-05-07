function [Anm,Cn,r,kinf_,Alfa_n]=eq_neu1(NEIG,hx,hz,d1,d2,usig1,usig2,...
siga1,sigr,siga2,a11,a21,a22,fi1,fi2,theta,keff,cp,al,b,lam)
% 

ntot=length(d1(:));

if nargin>18
  alfapre=1-sum(b)+sum(al.*b./(al+lam));
  alfapre=alfapre.';
else
  alfapre=1;
end



rinf=sigr./siga2;                                   % Eq. (2)
kinf=alfapre.*(usig1+rinf.*usig2)./(siga1+sigr);    % Eq. (3) alfa=1 for stat case
tau=d1./(siga1+sigr);                               % Eq. (4)
L2=d2./siga2;                                       % Eq. (5)
Xsi=L2./tau;                                        % Eq. (6)
Rf=hx^2/hz^2;                                       % Eq. (7)
l2=hx*hx/(2+Rf);                                    % Eq. (8)
%b12=l2/4*(kinf-1)./(L2+tau); % This was used in the old implementation of neu1
B12=(kinf/keff-1)./(L2+tau);                        % Eq. (9)
b12=l2/4*B12;                                       % Eq. (10)
b22=3/4*l2*(1+Xsi)./L2;                             % Eq. (11)
t1=1-b12/3;                                         % Eq. (12)
s1=1+2/3*b12;                                       % Eq. (13)    
b2=sqrt(b22);
t2=b2-cp*(b2-t1);                                   % Eq. (14)
D1=d1.*t1;                                         % Eq. (15)
D2=d2.*t2;                                         % Eq. (16)
d1_=sqrt(D1);
d2_=sqrt(D2);

theta_as=rinf.*theta.*d2_./d1_;                     % Eq. (18)


C11=4*(1+a11)./(1-a11)/hx;                          % Eq. (19,22)
C11(:,5:6)=hx/hz*C11(:,5:6);                        % Eq. (19)
C22=4*(1+a22)./(1-a22)/hx;                          % Eq. (20,23)
C22(:,5:6)=hx/hz*C22(:,5:6);                        % Eq. (20)
C21=8/hx*a21./(1-a11)./(1-a22);                     % Eq. (21,24)
C21(:,5:6)=hx/hz*C21(:,5:6);                        % Eq. (21)

Alfa_n=zeros(ntot,6);
for i=1:6,
    refl=find(NEIG(:,i)==ntot+1);
    Alfa_n(refl,i)=2*d1_(refl)./(1+D1(refl).*C11(refl,i));
    if i>4,
        Alfa_n(refl,i)=Alfa_n(refl,i)*Rf;
    end
end

r=fi2./fi1;
q=1+Xsi./(1+Xsi).*(r./rinf-1);                      % Eq. (17)

SPECTn=zeros(ntot,1);


for i=1:6,                                          % Eq. (26-27)
    refl=(NEIG(:,i)==(ntot+1));
    irefl=find(refl);
    i_int=find(1-refl);
    Rnm=1;if i>4, Rnm=Rf;end
    SPECTn(i_int)=SPECTn(i_int)+s1(i_int).*q(i_int).*d2_(i_int)./siga2(i_int)/hx/hx.*...
        (d2_(i_int)./theta_as(i_int).*theta_as(NEIG(i_int,i))-d2_(i_int))*Rnm;
    SPECTn(irefl)=SPECTn(irefl)-2*s1(irefl).*q(irefl)./siga2(irefl).*(1./d1_(irefl)+C11(irefl,i)-C21(irefl,i)./rinf(irefl))./...
        (1./d1_(irefl)+C11(irefl,i))./(1./d2_(irefl)+C22(irefl,i))*Rnm/hx/hx;
end
SPECTn=SPECTn+1;
Delta_r=SPECTn-1;                                   % Eq. (28)
r=rinf.*SPECTn;                                     % Eq. (29)
q=1+Xsi./(1+Xsi).*(r./rinf-1);                      % Eq. (17) again with updated r
kinf_=kinf+rinf.*Delta_r.*usig2./(siga1+sigr);      % Eq. (30)
Cn=d1_./t1./s1./tau./q;                             % Eq. (31)

denAnm=zeros(ntot,1);                               % Eq. (32)
for i=1:6,
    Rnm=1;if i>4, Rnm=Rf;end
    i_int=find(NEIG(:,i)<(ntot+1));
    denAnm(i_int)=denAnm(i_int)+d1_(i_int)*Rnm;
end
denAnm=denAnm+sum(Alfa_n,2)-hx*hx*Cn.*(kinf_/keff-1);

Anm=sparse(ntot,ntot);
for i=1:6,                                          % Eq. (32) cont'd
    iAnm=find(NEIG(:,i)~=ntot+1);
    jAnm=NEIG(iAnm,i);
    xAnm=d1_(jAnm)./denAnm(iAnm);
    if i>4,                    
        xAnm=xAnm*Rf;
    end
    Anm=Anm+sparse(iAnm,jAnm,xAnm,ntot,ntot);
end

