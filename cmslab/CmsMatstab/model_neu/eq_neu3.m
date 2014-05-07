function [Anm,r,raa,Sn,C1nm,C2nm,J1nm,J2nm,SC1,SC2]=eq_neu3(NEIG,hx,hz,d1,d2,usig1,usig2,siga1,...
  sigr,siga2,a11,a21,a22,psi1,r,keff,DF1,DF2,C1nm,C2nm)
%
%
%
%

% All Eq numbers refer to PRESTO-2 Manual Rev. 0 

if ~exist('C1nm','var'),
    C1nm=NaN(size(NEIG));C2nm=C1nm;
end

%%
ntot=length(d1(:));
%r=fa2./fa1;
B11=(usig1/keff-siga1-sigr)./d1;
B12=usig2./d1/keff;
B21=sigr./d2;
B22=-siga2./d2;
a=(B11+B22)/2;
b=sqrt(a.*a-B11.*B22+B12.*B21);
B1_2=a+b;
B2_2=a-b;
rinf=sigr./siga2;
L2=d2./siga2;
e1=rinf./(1+B1_2.*L2);
e2=(1+B2_2.*L2)./rinf;
detU=1-e1.*e2;
%psi1=(fa1-e2.*fa2)./detU;
B1_2=B1_2*hx*hx/4;
B2_2=B2_2*hx*hx/4;
%% Define s2 and t2 for all nodes
B2=sqrt(-B2_2);
t2=B2./tanh(B2);
s2=B2./sinh(2*B2);
K20=(s2-1)./B2_2;
K21=(1./t2-1)./B2_2;
K22=(-3*K20+3./t2-1)./B2_2;
%% Define s1 and t1 for all nodes
t1=ones(size(e1));s1=t1;
iplus=find(B1_2>0);  % First for nodes with B1_2>0
B1=zeros(size(t1));
B1(iplus)=sqrt(B1_2(iplus));
t1(iplus)=B1(iplus)./tan(B1(iplus));
s1(iplus)=2*B1(iplus)./sin(2*B1(iplus));
iminus=find(B1_2<0); % Then for nodes with B1_2<0
B1(iminus)=sqrt(-B1_2(iminus));
t1(iminus)=B1(iminus)./tanh(B1(iminus));
s1(iminus)=2*B1(iminus)./sinh(2*B1(iminus));
K10=(s1-1)./B1_2;
K11=(1./t1-1)./B1_2;
K12=(-3*K10+3./t1-1)./B1_2;
%%
dinv=cell(ntot,1);
for i=1:ntot
    u=[1 e2(i);e1(i) 1];
   uinv=[1 -e2(i);-e1(i)  1]/detU(i);
   tinv=diag([1/t1(i),1/t2(i)]);
   Dinv=diag([1/d1(i) 1/d2(i)]);
   dinv{i}=u*tinv*uinv*Dinv*hx/2;
end
%%
raa=(r-e1)./(1-e2.*r);
% NEIG contains [N E S W U D], thus ineig should transform that to [S W N E D U]
ineig=[3 4 1 2 6 5];
if isnan(C1nm(1,1)), % First call, just initialize
    SC1=nan(size(NEIG));SC2=SC1;
    for i=1:6,
        fac1=s1; % will be s1-sum(K1*q)
        fac2=s2.*raa; % will be s2.*raa-sum(K2*q)
        if i<5, 
            f1=DF1(:,i);f2=DF2(:,i);
        else
            f1=ones(ntot,1);f2=f1;
        end
        SC1(:,i)=f1.*fac1+f1.*e2.*fac2;
        SC2(:,i)=f2.*e1.*fac1+f2.*fac2;
    end
    J1nm=[];J2nm=[];
else
    % First calculate the currents Eq. (75.)
    SC1=nan(size(NEIG));SC2=SC1;
    J1nm=zeros(size(NEIG));J2nm=J1nm;
    for i=1:6,
        J1nm(:,i)=C1nm(:,i).*psi1;
        J2nm(:,i)=C2nm(:,i).*psi1;
        i_int=find(NEIG(:,i)~=(ntot+1));
        J1nm(i_int,i)=J1nm(i_int,i)-C1nm(NEIG(i_int,i),ineig(i)).*psi1(NEIG(i_int,i));
        J2nm(i_int,i)=J2nm(i_int,i)-C2nm(NEIG(i_int,i),ineig(i)).*psi1(NEIG(i_int,i));
    end
    ileakz=1:4;
    ileaky=[2 4 5 6];
    ileakx=[1 3 5 6];
    l10x=sum(J1nm(:,ileakx),2);    
    l10y=sum(J1nm(:,ileaky),2);
    l10z=sum(J1nm(:,ileakz),2);
    L10=[l10y l10x l10y l10x l10z l10z];
    l20x=sum(J2nm(:,ileakx),2);
    l20y=sum(J2nm(:,ileaky),2);
    l20z=sum(J2nm(:,ileakz),2);
    L20=[l20y l20x l20y l20x l20z l20z]; 
    for i=1:6,                                        % Eq. (70.)
        l11=nan(ntot,1);
        l21=l11;l12=zeros(ntot,1);l22=l12;
        bound=NEIG(:,i)==(ntot+1);
        boundc=NEIG(:,ineig(i))==(ntot+1);
        ibound=find(bound);
        iboundc=find(boundc);
        i_int=find(1-bound-boundc);
        l11(ibound)=-(L10(ibound,i)-L10(NEIG(ibound,ineig(i)),ineig(i)))/2;
        l11(iboundc)=(L10(iboundc,i)-L10(NEIG(iboundc,i),i))/2;
        l11(i_int)=(L10(NEIG(i_int,i),i)-L10(NEIG(i_int,ineig(i)),ineig(i)))/4;
        l12(i_int)=(L10(NEIG(i_int,i),i)+L10(NEIG(i_int,ineig(i)),ineig(i))-2*L10(i_int,i))/12;
        l21(ibound)=-(L20(ibound,i)-L20(NEIG(ibound,ineig(i)),ineig(i)))/2;
        l21(iboundc)=(L20(iboundc,i)-L20(NEIG(iboundc,i),i))/2;
        l21(i_int)=(L20(NEIG(i_int,i),i)-L20(NEIG(i_int,ineig(i)),ineig(i)))/4;        
        l22(i_int)=(L20(NEIG(i_int,i),i)+L20(NEIG(i_int,ineig(i)),ineig(i))-2*L20(i_int,i))/12;        
        if i<5,
            h2=hx*hx/4;
            f1=DF1(:,i);f2=DF2(:,i);
        else
            h2=hz*hz/4;
            f1=ones(ntot,1);f2=f1;
        end
        Kq1=h2*(K10.*L10(:,i)+K11.*l11+K12.*l12)./psi1./d1;   % Eq. (35.)
        Kq2=h2*(K20.*L20(:,i)+K21.*l21+K22.*l22)./psi1./d2;
        uKq1=(Kq1-e2.*Kq1)./detU;
        uKq2=(-e1.*Kq1+Kq2)./detU;
        SC1(:,i)=f1.*(s1-uKq1)+f1.*e2.*(s2.*raa-uKq2);
        SC2(:,i)=f2.*e1.*(s1-uKq1)+f2.*(s2.*raa-uKq2);
    end
end
%%
I=eye(2);
for i=1:ntot
    for j=1:4,
        if NEIG(i,j)>ntot,
            alb=[a11(i,j) 0;a21(i,j) a22(i,j)];
            dinv2=(I-alb)\(I+alb)*2;
        else
            i_nei=NEIG(i,j); %Node-index for neigbour
            j_nei=ineig(j);  % For the neigbour, the j-index is the "complement" of j (N-S, E-W)
            F=diag([DF1(i_nei,j_nei) DF2(i_nei,j_nei)]);
            dinv2=F*dinv{i_nei};
        end
        F=diag([DF1(i,j) DF2(i,j)]);
        Wnm=inv(F*dinv{i}+dinv2);
        C1nm(i,j)=(SC1(i,j)*Wnm(1,1)+SC2(i,j)*Wnm(1,2))/hx;
        C2nm(i,j)=(SC1(i,j)*Wnm(2,1)+SC2(i,j)*Wnm(2,2))/hx;
    end
    for j=5:6,
        if NEIG(i,j)>ntot,
            alb=[a11(i,j) 0;a21(i,j) a22(i,j)];
            dinv2=(I-alb)\(I+alb)*2;
        else
            dinv2=dinv{NEIG(i,j)}*hz/hx;
        end
        Wnm=inv(dinv{i}*hz/hx+dinv2);
        C1nm(i,j)=(SC1(i,j)*Wnm(1,1)+SC2(i,j)*Wnm(1,2))/hz;
        C2nm(i,j)=(SC1(i,j)*Wnm(2,1)+SC2(i,j)*Wnm(2,2))/hz;
    end
end
%% Calculate Delta_n Eq. (81.)
denDelta=siga2.*(1-e1.*e2).*psi1;
psi1(ntot+1)=0;
Delta_n=zeros(ntot,1);
for i=1:6,
    Delta_n=Delta_n+C2nm(:,i).*psi1(1:ntot)./denDelta;
    i_int=find(NEIG(:,i)~=(ntot+1));
    Delta_n(i_int)=Delta_n(i_int)-C2nm(NEIG(i_int,i),ineig(i)).*psi1(NEIG(i_int,i))./denDelta(i_int);
end
r=(rinf-Delta_n)./(1-Delta_n.*e2);          % Eq. (82.)
raa=(r-e1)./(1-e2.*r);                      % Eq. (67.)
Sn=(1-e2.*r)./detU;                         % Eq. (68.)
%% Eq. (79.)
korr=((usig1+r.*usig2)/keff-siga1-sigr)./Sn;
denAnm=sum(C1nm,2)-korr;
Anm=sparse(ntot,ntot,0);
for i=1:6,
    iAnm=find(NEIG(:,i)~=ntot+1);
    jAnm=NEIG(iAnm,i);
    xAnm=C1nm(jAnm,ineig(i))./denAnm(iAnm);
    Anm=Anm+sparse(iAnm,jAnm,xAnm,ntot,ntot);
end