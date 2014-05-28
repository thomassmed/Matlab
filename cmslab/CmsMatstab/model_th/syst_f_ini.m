function [alfa,tl,Wg,Wl,chflow,flowb,Wbyp]=syst_f_ini(fue_new,power,chflow,flowb)
% [alfa,tl,Wg,Wl,chflow,flowb]=syst_f_ini(fue_new,power,chflow,flowb,alfa,tl)
%
% Gives the initial guess on thermal-hydraulic solution
% x is:
% k = get_corenodes;
% [kn,k0]=get_thneig(k);
% x = [mg(k0);romum(k0)];
%
% Called from thyd0

%@(#)   sysf.m 1.9   02/02/27     12:16:04


%%
global geom termo neu
ncc=geom.ncc;kan=ncc;
kmax=geom.kmax;
hx=geom.hx;
knum=geom.knum;
tlp=termo.tlp;
%%
Wbyp=termo.Wbyp_frac*sum(chflow);
Wtot_flag=0;

if length(chflow)==1, 
    chflow=ones(1,ncc)*(chflow-Wbyp)/ncc/get_sym; Wtot_flag=1;
end
if nargin<4, 
    flowb=0.025*chflow; 
    if Wtot_flag,
        chflow=chflow-flowb;
    end
end
if nargin<5, ini_void=0; else ini_void=1; end
if nargin<6,
    ini_tl=0; jiter=5;
else
    ini_tl=1; jiter=2;
end
Wbyp=Wbyp/get_sym;

%%
twophasekorr=termo.twophasekorr;
delta=neu.delta;
deltam=neu.deltam;
qtherm=termo.Qtot/get_sym;

aby=1.5330;
Dhby=0.0161;
p=termo.p;
htc=termo.htc;
hz=geom.hz;

tsat=cor_tsat(termo.p);
cpl=cor_cpl(tsat);


%Algebraic variables
P=p*ones(size(power));

%%
Phm=fue_new.phfuel;
Phm=Phm(:,knum(:,1));
DH=fue_new.dhfuel;
DH=DH(:,knum(:,1));
AA=fue_new.afuel;
AA=AA(:,knum(:,1));
VV=AA*hz/100;
Pbm=4*AA./DH-Phm;

ntot=kmax*ncc;
qprimw = (1-delta)*power*qtherm/ntot/(hz/100);
qtrissf=power*qtherm/ntot/(hx/100)^2/(hz/100);
q3l = (delta-deltam)*qtrissf*(hx/100)^2./AA;

Wg=zeros(kmax,ncc);E=Wg;


HM=zeros(kmax,ncc);E=HM;WL=HM;
Hl=HM;
Wl(1,:)=chflow;
tlb=termo.tlp;

alfa=zeros(kmax,ncc);tl=alfa;tw=tl;x=tl;
tl(1,:)=tlp;

dE=qprimw(1,:)*hz/100+q3l(1,:).*VV(1,:).*(1-alfa(1,:));
Eci=eq_romum(0,p,tlp,tsat);
E(1,:)=Eci+dE;
hlp=cor_hl(0,Eci,tlp,p,tsat,1);
HM(1,:)=hlp+dE./chflow;
Hl(1,:)=HM(1,:);
hfg=cor_hfg(p);
gammav=zeros(kmax,ncc);jm=gammav;
%%
rog=cor_rog(tsat);

for i=2:kmax,
    dE=qprimw(i,:)*hz/100+q3l(i,:).*VV(i,:).*(1-alfa(i,:));
    E(i,:)=E(i-1,:)+dE;
    HM(i,:)=HM(i-1,:)+dE./chflow;
    % As long as there is single-phase, the following is true:
    dH=(qprimw(i,:)+q3l(i,:).*AA(i,:))./chflow*hz/100;
    Hl(i,:)=Hl(i-1,:)+dH;i_novoid=1:ncc;
    ivoid=find(Hl(i,:)>0);i_novoid(ivoid)=[];
    tl(i,i_novoid)=tl(i-1,i_novoid)+dE(i_novoid)./chflow(i_novoid)/cpl;
    Wl(i,i_novoid)=Wl(1,i_novoid);
    alfa(i,i_novoid)=0;Wg(i,i_novoid)=0;
    if ~isempty(ivoid),
        tl(i,ivoid)=tsat;
        x(i,ivoid)=HM(i,ivoid)/hfg;
        Wg(i,ivoid)=x(i,ivoid).*Wl(1,ivoid);
        Wl(i,ivoid)=chflow(ivoid)-Wg(i,ivoid);
        jm(i,ivoid)=eq_jm(Wl(i,ivoid),Wg(i,ivoid),p,tl(i,ivoid),AA(i,ivoid));
        alfa0=Wg(i,ivoid)./AA(i,ivoid)./jm(i,ivoid)/rog/1.5;
        y=eq_alfa(alfa0,jm(i,ivoid),Wg(i,ivoid),Wl(i,ivoid),p,AA(i,ivoid),rog);
        ya=eq_alfa(alfa0+0.01,jm(i,ivoid),Wg(i,ivoid),Wl(i,ivoid),p,AA(i,ivoid),rog);    
        J=(ya-y)/.01;dalfa=-y./J;alfa0=alfa0+dalfa;
        y=eq_alfa(alfa0,jm(i,ivoid),Wg(i,ivoid),Wl(i,ivoid),p,AA(i,ivoid),rog);
        J=(ya-y)/.01;dalfa=-y./J;alfa(i,ivoid)=alfa0+dalfa;
    end
end
%%



