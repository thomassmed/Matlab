function [At,Atj,Atq,Atf,Ajt,Aj,Ajq,Ajf,Ant,AntIm,An,AnIm,Anf, ...
  Aqt,Aqn,Aqf,Aft,Afj,Afq,Af,Bt,Bf,Bj,Btj,matr]=build_A(fue_new,Xsec,lam)


if nargin<2, lam=-0.2+3j; end


global geom msopt
%%
CoreOnly=get_bool(msopt.CoreOnly);

matr.fi_sc=1e14;
matr.P_sc=1e5;
matr.qp_sc=1e4;
matr.q3_sc=1e6;
matr.E_sc=1e4;
matr.I_sc=1e3;
matr.Phc_sc=1;%1e4;
matr.nAI=2*sum(geom.nsec(1:4))+4*geom.nsec(6)+3;
matr.nt=7;
matr.ibas_t=1:matr.nt:matr.nt*geom.ntot;
matr.nAt=geom.ncc*geom.kmax*matr.nt+2*geom.ncc;
matr.nf=6;
matr.ibas_f=1:matr.nf:matr.nf*geom.ntot;

%% THEMO HYDRAULICS

[At,Bt,Aj,Bj,Ajq,Ajt,Atj,Atq,Atf,Btj]=A_th(fue_new,matr,lam);
%% FUEL
%Aj(42,18)=Aj(42,18)*6; % Test of sensitivity of pump model
[Af,Bf,Afq,Afj,Aft] =A_tfuel(fue_new,matr);



%% NEUTRONICS

[An,Ant,Anf,Aqn,Aqt,Aqf]=A_neu(fue_new,Xsec,matr,lam,0);
AnIm=imag(An);
An=real(An);
AntIm=imag(Ant);
Ant=real(Ant);
%save ANN1 An AnIm AntIm Anf Aqn Aqt Aqf Ant



% Aj(end,:)=[];
% Aj(:,end)=[];
% Afj(:,end)=[];
% Atj(:,end)=[];
% Ajt(end,:)=[];
% Bj(end,:)=[];
% Bj(:,end)=[];
% Btj(:,end)=[];
%% change 
%Aft=sparse(1,1,0,size(Af,1),size(At,1));
if CoreOnly
    Atj=sparse(size(At,1),matr.nAI);
    Ajt=sparse(matr.nAI,size(At,1));
    Btj=Atj;
    Aj=sparse(matr.nAI,matr.nAI);
    Bj=Aj;
    Afj=sparse(1,1,0,size(Af,1),size(Aj,1));
end
Ajf=sparse(1,1,0,size(Aj,1),size(Af,1));