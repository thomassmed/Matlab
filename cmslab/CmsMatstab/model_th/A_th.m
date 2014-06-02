function [At,Bt,AI,BI,AIq,AIt,AtI,Atq,Atf,BtI]=A_th(fue_new,matr,lam)

global termo geom neu steady msopt
%%
twophasekorr=termo.twophasekorr;
CoreOnly=get_bool(msopt.CoreOnly);
alfa=steady.alfa;
tl=steady.tl;
tw=steady.tw;
kmax=size(alfa,1);
Wg=steady.Wg;
Wl=steady.Wl;
p=termo.p;
P=steady.P;
power=steady.power;
tlb=termo.tlp;
tlp=tlb;
Iboil=steady.Iboil;
flowb=steady.flowb;


ncc=geom.ncc;kan=ncc;
knum=geom.knum;
hz=geom.hz;
hx=geom.hx;
nsec=geom.nsec;
ndclp=sum(nsec(1:4));
nriser=nsec(6);
htc=termo.htc;
ntot=kmax*ncc;

tcm=steady.tcm;
tc2=tcm(:,2);
tc2=reshape(tc2,kmax,ncc);

delta=neu.delta;
deltam=neu.deltam;
cmpfrc=neu.cmpfrc;
qtherm=termo.Qtot/get_sym;

i_wr=length(fue_new.A_wr);
for i=1:i_wr,
    A_wr(i,:)=fue_new.A_wr{i}(knum(:,1));
    Ph_wr(i,:)=fue_new.Ph_wr{i}(knum(:,1));
    Dhy_wr(i,:)=fue_new.Dhy_wr{i}(knum(:,1));
    Kin_wr(i,:)=fue_new.Kin_wr{i}(knum(:,1));
    Kex_wr(i,:)=fue_new.Kex_wr{i}(knum(:,1));
end
Xcin=fue_new.Xcin(knum(:,1));
if isempty(fue_new.amdt)
    amdt=[];
    bmdt=[];
else
    amdt=fue_new.amdt(knum(:,1));
    bmdt=fue_new.bmdt(knum(:,1));
end

tsat=cor_tsat(termo.p);
cpl=cor_cpl(tsat);
rog=cor_rog(tsat);
tlm=mean(mean(tl));
hfg=cor_hg(p,tlm,tsat);
rol=cor_rol(p,tl);

phm=fue_new.phfuel;
phm=phm(:,knum(:,1));
Dh=fue_new.dhfuel;
Dh=Dh(:,knum(:,1));
A=fue_new.afuel;
A=A(:,knum(:,1));
pbm=4*A./Dh-phm;
tsat=cor_tsat(p);
rol_lp=cor_rol(p,tlp);
%%
qprimw = (1-delta)*power*qtherm/ntot./(hz/100);
qtrissf=power*qtherm/ntot/(hx/100)^2/(hz/100);
q3l = (delta-deltam)*qtrissf*(hx/100)^2./A;
%%
P_sc=matr.P_sc;
qp_sc=matr.qp_sc;
q3_sc=matr.q3_sc;
E_sc=matr.E_sc;
I_sc=matr.I_sc;
Phc_sc=matr.Phc_sc;
nAI=matr.nAI;
nt=matr.nt;
nf=matr.nf;
k=1:kmax;
kd=kmax*ncc;
ibas=1:nt:nt*kd;i_off_diag=ibas;
i_off_diag(1:kmax:kd)=[];
ett=ones(size(ibas));
ett_o=ones(size(i_off_diag));
V=A*hz/100;
Vk=V(k,:);
Vk=Vk(:)';
ibas_f=1:nf:nf*kd;
%  Wl,tl(dc&lp)   alfa,tl,Wg,Wl(riser)   N,P(pump)   Pressure;
%nAI= 2*ndclp     +     4*nriser          +   2         +  1;
% Numbering AI:
%              1    2     3    4    5     6
%       nsec=[ndc1 ndc2 nlp1 nlp2 kmax nriser]
%       tl before core      1:2:(2*(ndc1+ndc2+nlp1+nlp2))
%       Wl before core      1:2:(2*(ndc1+ndc2+nlp1+nlp2))
%       Set j_upl_bas=2*(ndc1+ndc2+nlp1+nlp2)+(0:4:(nriser*4-1))
%       alfa                j_upl_bas+1
%       tl                  j_upl_bas+2
%       Wg                  j_upl_bas+3
%       Wl                  j_upl_bas+4
%       NP(pump)(Wdr for Jet)   2*(ndc1+ndc2+nlp1+nlp2)+4*nriser+1 = nAI-2
%       dP(pump)                2*(ndc1+ndc2+nlp1+nlp2)+4*nriser+2 = nAI-1
%       P (system pressure)     2*(ndc1+ndc2+nlp1+nlp2)+4*nriser+3 = nAI
%       Idel (Pressure Controller, Integration Feedback part)       nAI+1
%       Put (Pressure Controller, Feedback part)                    nAI+2
%       Neutfilt (Pressure Controller Feed Forward part)            nAI+3
%       BAFR (Ordered steam from Reactor)                           nAI+4
%       mst  (Steam flow from reactor)                              nAI+5
%% Prepare for partial derivatives of qprimw wrt P Wl tw tl
P=p*ones(size(Wl));
%% Total of (7*kmax+2)*ncc equations    Eq no   Index
% alfa:  kmax*ncc unknowns              1       ibas
% tl:    kmax*ncc unknowns              2       ibas+1
% Wg     kmax*ncc unknowns              3       ibas+2
% Wl     kmax*ncc unknowns              4       ibas+3
% Gamv   kmax*ncc unknowns              5       ibas+4
% qprimw kmax*ncc unknowns              6       ibas+5
% jm     kmax*ncc unknowns              7       ibas+6
% tw     kmax*ncc unknowns              8       ibas+7
% Channel wise equations
%       Wl(1,:)                                 8*ntot+1:ncc                                   
%       I (Impulse momentum)                    8*ntot+ncc+1:2*ncc       
%
% Equations to be solved 
%% raa V dalfa/dt = -Wg(k) + Wg(k-1) + V Gamv   Eq. At.1
clear xAI jAI iAI iAtI jAtI xAtI iAIt jAIt xAIt iBhyd jBhyd xBhyd iAhyd jAhyd xAhyd iBI jBI xBI
gammav=eq_gamv(eq_gamw(qprimw,p,tl,tw,A),eq_gamph(alfa,p,tl));
x=(gammav(:)>0)';
%x=ones(size(x));
j_off_diag=1:kd;j_off_diag(1:kmax:kd)=[];
x1=gammav(j_off_diag)>0;
%x1=ones(size(x1));
icount=1;
iAIcount=1;
iAItcount=1;
iAtIcount=1;
iBIcount=1;
iBcount=1;
iAtfcount=1;
iAhyd{icount}=[ibas      i_off_diag       ibas];
%              Wg(k)       Wg(k-1)        Gamv      
jAhyd{icount}=[ibas+2    i_off_diag+2-nt  ibas+4];
xAhyd{icount}=[-ett.*x   ett_o.*x1        Vk.*x];
icount=icount+1;
iBhyd{iBcount}=ibas;jBhyd{iBcount}=ibas;xBhyd{iBcount}=rog*Vk;
iBcount=iBcount+1;
%% Energy equation: V*d(raa_um)/dt=[hg Wg(k-1) + hl Wl(k-1)] - [hg Wg(k) + hl Wl(k)] + [qpw + A (1-alfa) q3l] hz/100
% Eq At.2
[drda,drdp,drdt]=fin_diff(@eq_romum,alfa,p,tl,tsat);
drda=drda(:)';
drdt=drdt(:)';
iBhyd{iBcount}=[ibas+1 ibas+1];
jBhyd{iBcount}=[ibas ibas+1];
xBhyd{iBcount}=[drda.*Vk/E_sc  drdt.*Vk/E_sc];
iBcount=iBcount+1;
iBtI=ibas'+1;
jBtI=nAI*ones(ntot,1);
xBtI=drdp(:).*Vk(:)*P_sc/E_sc; 
%%
% dy1/dx
Y1tl=-cpl*Wl(k,:);                                       % dy1/dtl   
Y1tln=cpl*Wl(1:kmax-1,:);
Y12=-q3l(k,:).*A(k,:)*hz/100;                            % dy1/dalfa
Y12=Y12(:)';
Y1Wg=-(hfg+p/rog);                                       % dy1/dWg
%Y1Wgn=-Y1Wg;                                           % dy1/dWgn
Y1Wl=-(cpl*(tl(k,:)-tsat)+p./rol(k,:));
Tl=[tl(1,:);tl];Rol=[rol(1,:);rol];
Y1Wln=cpl*(Tl(k,:)-tsat)+p./Rol(k,:);
Y1Wln=Y1Wln(:)';
Y1Wln=Y1Wln(j_off_diag);
iAhyd{icount}=[ibas+1 ibas+1 i_off_diag+1        ibas+1     i_off_diag+1    ibas+1   i_off_diag+1    ibas+1];
%              alfa   tl(k)    tl(k-1)           Wg(k)           Wg(k-1)    Wl(k)    Wl(k-1)         qpw 
jAhyd{icount}=[ibas   ibas+1   i_off_diag+1-nt  ibas+2      i_off_diag+2-nt ibas+3   i_off_diag+3-nt ibas+5];
xAhyd{icount}=[Y12    Y1tl(:)'  Y1tln(:)'       Y1Wg*ett    -Y1Wg*ett_o     Y1Wl(:)' Y1Wln           qp_sc*ett*hz/100]/E_sc;
icount=icount+1;
iAhyd{icount}=ibas(1:kmax:kd)+1;
jAhyd{icount}=(1:ncc)+ntot*nt;
xAhyd{icount}=(cpl*(termo.tlp-tsat)+p./rol(1,:))/E_sc;
icount=icount+1;
iAtq=ibas+1;
jAtq=1:kd;
xAtq=q3_sc/E_sc*(delta-deltam)/delta*cmpfrc*(hx/100)^2*hz/100*(1-alfa(:)');
%% Wl  = A.*(1-alfa).*rol.*(jm-c15.*alfa)./(1 + alfa.*(S-1)) Eq. At.3
jm=eq_jm(Wl,Wg,P,tl,A);
[P_c,jm_c,a_c,tl_c]=fin_diff(@eq_Wl,P,jm,alfa,tl,A);
iAhyd{icount}=[ibas+2 ibas+2 ibas+2 ibas+2];
jAhyd{icount}=[ibas+3 ibas ibas+1 ibas+6];
xAhyd{icount}=[-ett   a_c(:)' tl_c(:)' jm_c(:)'];
icount=icount+1;
iAtI{iAtIcount}=ibas+2;
jAtI{iAtIcount}=ett*nAI;
xAtI{iAtIcount}=P_c(:)'*P_sc;
iAtIcount=iAtIcount+1;
%% Get the derivatives of tw wrt tc tl P
%%{
[dtwdtw,dtwdtc,dtwdtl,dtwdP,dtwdWl]=fin_diff(@eq_tw,tw,tc2,tl,P,Wl,A,Iboil,Dh);
% iAhyd{icount}=[ibas+7 ibas+7 ibas+7];
% %                tw         tl        Wl 
% jAhyd{icount}=[ibas+7       ibas+1      ibas+3];
% xAhyd{icount}=[dtwdtw(:)'  dtwdtl(:)'   0*dtwdWl(:)'];
% % In original matstab, dtwdWl is left out, thus 0* for the time beeing!!
% icount=icount+1;
% iAtI{iAtIcount}=ibas+7;
% jAtI{iAtIcount}=nAI*ett;
% xAtI{iAtIcount}=dtwdP(:)'*P_sc;  
% iAtIcount=iAtIcount+1;
%%}
%%  0 = -Gamv + eq_gamv(alfa,tl,qprimw,tw) Evaporation rate Eq. At.5
[qp_c,P_c1,tl_c1,tw_gamw]=fin_diff(@eq_gamw,qprimw,p,tl,tw,A);
[a_c,P_c2,tl_c2]=fin_diff(@eq_gamph,alfa,p,tl);
%a_c=0*a_c;
x=(alfa(:)>0)';
a_c=a_c(:)'.*x;
tl_c=(tl_c1(:)'+tl_c2(:)').*x;
qp_c=qp_c(:)'.*x;
tw_gamw=tw_gamw(:)'.*x;
P_c=(P_c1(:)'+P_c2(:)').*x;

iAhyd{icount}=[ibas+4  ibas+4 ibas+4  ibas+4];%   ibas+4];  %Take this before just because some results from above are needed in ibas+3
jAhyd{icount}=[ibas    ibas+1 ibas+4  ibas+5];%   ibas+7];
xAhyd{icount}=[a_c     tl_c   -ett  qp_c*qp_sc]; %   tw_c];
icount=icount+1;
iAtI{iAtIcount}=ibas+4;
jAtI{iAtIcount}=ett*nAI;
xAtI{iAtIcount}=(P_c-tw_gamw.*dtwdP(:)'./dtwdtw(:)')*P_sc;
iAtIcount=iAtIcount+1;
iAtf{iAtfcount}=ibas+4;
jAtf{iAtfcount}=ibas_f+5;
xAtf{iAtfcount}=-tw_gamw.*dtwdtc(:)'./dtwdtw(:)';
iAtfcount=iAtfcount+1;
%% 0 = A*jm(k-1) - A*jm(k) + (1/rog-1/rol) Gamv *V (Volume expansion) 
% Eq.  At.4
x=1/rog-1./rol(k,:);x=x(:)';
rol_t=cor_rol(p,tl+1);
xtl=1/rog-1./rol_t(k,:);xtl=xtl(:)';
dxdt=xtl-x;
gamk=gammav(k,:);gamk=gamk(:)';
Ak=A(k,:);Ak=Ak(:)';
djdtl=dxdt.*gamk.*Ak*hz/100;
djdg=x.*Ak*hz/100;
A_offdiag=Ak(j_off_diag);
iAhyd{icount}=[i_off_diag+3    ibas+3   ibas+3     ibas+3];
jAhyd{icount}=[i_off_diag+6-nt ibas+6   ibas+4     ibas+1];
xAhyd{icount}=[A_offdiag       -Ak      djdg          djdtl];
icount=icount+1;
% dpin/dWl
dpin=eq_prestr(Wl(1,:)+flowb,0*Wg(1,:),p,tlp,A(1,:),Xcin);
dpin_dWl1=(eq_prestr(Wl(1,:)+flowb+0.01,0*Wg(1,:),p,tlp,A(1,:),Xcin)-dpin)/0.01;
% dp_dw_Ddpin=-1
dp_wr=steady.dp_wr+1;
Dflowb_Ddp_wr=0;
for j=1:i_wr
    Dflowb_Ddp_wr=Dflowb_Ddp_wr+0.5*sqrt(2*rol_lp./dp_wr./(Kin_wr(j,:)+eps)).*A_wr(j,:);
end
Dflowb_DWl1=-Dflowb_Ddp_wr.*dpin_dWl1.*(dp_wr>2);
i_in=ibas(1:kmax:kd);
iAhyd{icount}=i_in+3;
jAhyd{icount}=(1:ncc)+ntot*nt;
xAhyd{icount}=(1-Dflowb_DWl1)./rol_lp;  % With jm, it should have been A(1,:), but we use Wl_in instead!!
icount=icount+1;
%% Connection to Lower Plenum Wl_lp = sum(Wl_in) + bypass 
% TODO: fix bypass
iAI{iAIcount}=2*ndclp;
jAI{iAIcount}=2*ndclp;
xAI{iAIcount}=-1;  
iAIcount=iAIcount+1;
iAIt{iAItcount}=2*ndclp*ones(1,ncc);
jAIt{iAItcount}=ntot*nt+(1:ncc);
xAIt{iAItcount}=get_sym*ones(1,ncc);  
iAItcount=iAItcount+1;
%% 0 = -qprimw + eq_qprimw(tl,Wl,tw,P) Eq. At.6
[tl_c,Wl_c,tw_c,P_c]=fin_diff(@eq_qprimw,tl,Wl,tw,P,A,phm,pbm,Dh,Iboil,htc,tlp);
iAhyd{icount}=[ibas+5  ibas+5           ibas+5];     %      ibas+5];
%               qpw    tl               Wl            
jAhyd{icount}=[ibas+5  ibas+1           ibas+3];     %      ibas+7];
xAhyd{icount}=[-ett    tl_c(:)'/qp_sc   Wl_c(:)'/qp_sc];%   tw_c(:)'/qp_sc];
icount=icount+1;
iAtI{iAtIcount}=ibas+5;
jAtI{iAtIcount}=nAI*ett;
xAtI{iAtIcount}=(P_c(:)- tw_c(:).*dtwdP(:)./dtwdtw(:))'*P_sc/qp_sc;  
iAtIcount=iAtIcount+1;
iAtf{iAtfcount}=ibas+5;
jAtf{iAtfcount}=ibas_f+5;
xAtf{iAtfcount}=-tw_c(:)'.*dtwdtc(:)'./dtwdtw(:)'/qp_sc;
iAtfcount=iAtfcount+1;
% iAtf{iAtfcount}=ibas+5;
% jAtf{iAtfcount}=ibas_f+6;
% xAtf{iAtfcount}=tw_c(:)'/qp_sc;
% iAtfcount=iAtfcount+1;
%% jm definition jm = (Wl./rol + Wg./rog)./A;   Eq. At.7
[djmdWl,djmdWg,djmdP,djmdt]=fin_diff(@eq_jm,Wl,Wg,p,tl,A);
iAhyd{icount}=[ibas+6  ibas+6 ibas+6  ibas+6];
%                jm      tl     Wg      Wl 
jAhyd{icount}=[ibas+6  ibas+1 ibas+2  ibas+3];
xAhyd{icount}=[-ett    djmdt(:)'  djmdWg(:)'  djmdWl(:)'];
icount=icount+1;
iAtI{iAtIcount}=ibas+6;
jAtI{iAtIcount}=nAI*ett;
xAtI{iAtIcount}=djmdP(:)'*P_sc;  
iAtIcount=iAtIcount+1;
%% Impulse momentum balance dI/dt = ploss
vhifuel=fue_new.vhifuel(:,knum(:,1))';
vhofuel=fue_new.vhofuel(:,knum(:,1))';

vhk = set_pkoeff(vhifuel,vhofuel,termo.avhspx,termo.arhspx,termo.zsp,termo.ispac,Wl,Wg,Dh,P,A,hz/100);
vhk(1,:)=vhk(1,:)+Xcin;

Wl1=Wl;Wl1(1,:)=Wl(1,:)+flowb;
[a_c,tl_c,Wg_c,Wl_c,P_c]=fin_diff(@eq_ploss_1,alfa,tl,Wg.*(Wg>0),Wl1,P,vhk,Dh,hz/100,A,twophasekorr,amdt,bmdt);
%[a_c,tl_c,Wg_c,Wl_c,P_c]=fin_diff(@eq_ploss_1,alfa,tl,Wg.*(Wg>0),Wl1,P,vhk,Dh,hz/100,A,twophasekorr);
% Inlet acceleration loss:
Wl_acc=2*Wl(1,:)/cor_rol(p,tlb)./A(1,:).^2;
% Outlet acceleration loss
[pacc_a,pacc_t,pacc_Wg,pacc_Wl,pacc_P]=fin_diff(@eq_paccD,alfa(kmax,:),tl(kmax,:),Wg(kmax,:),Wl(kmax,:),P(kmax,:),A(kmax,:));
i_I=zeros(1,kd);
for i=1:ncc,
    istart=(i-1)*kmax+1;
    istop=i*kmax;
    i_I(istart:istop)=(ncc+i)*ones(1,kmax);
end
i_I=i_I+ntot*nt;
Wl_c(1,:)=Wl_c(1,:)-Wl_acc;
i_i=(1:ncc)+ncc+ntot*nt;
i_basout=ibas(kmax:kmax:kd);
iAhyd{icount}=[i_I      i_I        i_I        i_I         i_i       i_i         i_i        i_i];
jAhyd{icount}=[ibas     ibas+1     ibas+2     ibas+3      i_basout  i_basout+1 i_basout+2 i_basout+3   ];
xAhyd{icount}=[a_c(:)'  tl_c(:)'   Wg_c(:)'   Wl_c(:)'   -pacc_a   -pacc_t    -pacc_Wg    -pacc_Wl]/I_sc;
icount=icount+1;
iBhyd{iBcount}=i_i;
jBhyd{iBcount}=i_i;
xBhyd{iBcount}=ones(1,ncc);
iBcount=iBcount+1;
iAtI{iAtIcount}=ntot*nt+ncc+(1:ncc);
jAtI{iAtIcount}=nAI*ones(1,ncc);
xAtI{iAtIcount}=sum(P_c)*P_sc/I_sc;
iAtIcount=iAtIcount+1;
if ~CoreOnly
%% dc1
P_dc1=p*ones(size(steady.Wl_dc1));noll=0*P_dc1;
[dum,t_c,dum,Wl_c]=ploss_section(noll,steady.tl_dc1,noll,steady.Wl_dc1,P_dc1,geom.vh_dc1,...
    geom.dh_dc1,geom.h_dc1,geom.a_dc1);
[i_a,j_a,x_a]=get_index4AI(ncc,t_c,Wl_c);
i_a=i_a+ncc+ntot*nt;
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a/I_sc;
iAtIcount=iAtIcount+1;
%% dc2
P_dc2=p*ones(size(steady.Wl_dc2));noll=0*P_dc2;
[dum,t_c,dum,Wl_c]=ploss_section(noll,steady.tl_dc2,noll,steady.Wl_dc2,P_dc2,geom.vh_dc2,...
    geom.dh_dc2,geom.h_dc2,geom.a_dc2);
[i_a,j_a,x_a]=get_index4AI(ncc,t_c,Wl_c);
i_a=i_a+ncc+ntot*nt;
j_a=j_a+2*nsec(1);
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a/I_sc;
iAtIcount=iAtIcount+1;
%% lp1
P_lp1=p*ones(size(steady.Wl_lp1));noll=0*P_lp1;
[dum,t_c,dum,Wl_c]=ploss_section(noll,steady.tl_lp1,noll,steady.Wl_lp1,P_lp1,geom.vh_lp1,...
    geom.dh_lp1,geom.h_lp1,geom.a_lp1);
[i_a,j_a,x_a]=get_index4AI(ncc,t_c,Wl_c);
i_a=i_a+ncc+ntot*nt;
j_a=j_a+2*sum(nsec(1:2));
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a/I_sc;
iAtIcount=iAtIcount+1;
%% lp2
P_lp2=p*ones(size(steady.Wl_lp2));noll=0*P_lp2;
[dum,t_c,dum,Wl_c]=ploss_section(noll,steady.tl_lp2,noll,steady.Wl_lp2,P_lp2,geom.vh_lp2,...
    geom.dh_lp2,geom.h_lp2,geom.a_lp2);
[i_a,j_a,x_a]=get_index4AI(ncc,t_c,Wl_c);
i_a=i_a+ncc+ntot*nt;
j_a=j_a+2*sum(nsec(1:3));
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a/I_sc;
iAtIcount=iAtIcount+1;
%% Riser pressure drop
alfa_u=steady.alfa_upl;
tl_u=steady.tl_upl;
Wg_u=steady.Wg_upl;
Wl_u=steady.Wl_upl;
A_u=geom.a_upl;
V_u=A_u.*geom.h_upl;
P_u=p*ones(size(alfa_u));
l_upl=length(alfa_u);
[a_c,t_c,Wg_c,Wl_c]=ploss_section(alfa_u,tl_u,Wg_u,Wl_u,P_u,geom.vh_upl,geom.dh_upl,geom.h_upl,geom.a_upl);
[i_a,j_a,x_a]=get_index4AI(ncc,a_c,t_c,Wg_c,Wl_c);
i_a=i_a+ncc+ntot*nt;
j_a=j_a+2*ndclp;
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a/I_sc;
iAtIcount=iAtIcount+1;
%% Driving pump head
iAtI{iAtIcount}=ntot*nt+ncc+(1:ncc);
jAtI{iAtIcount}=(nAI-1)*ones(1,ncc);
xAtI{iAtIcount}=ones(1,ncc)*Phc_sc/I_sc;
iAtIcount=iAtIcount+1;
%% Pump equations
iBI{iBIcount}=nAI-2;
jBI{iBIcount}=nAI-2;
if termo.per_jet(1), % jet pump
    Drcl=termo.per_rcp(3);
    Lrcl=termo.per_rcp(4);
    Arcl=pi*Drcl^2/4;
    xBI{iBIcount}=Lrcl/Arcl;
else
    xBI{iBIcount}=1;
end
iBIcount=iBIcount+1;
NoPump=get_bool(msopt.NoPump);

if NoPump,
    % Pump speed (Torque eqation) Fake in this case
    iAI{iAIcount}=nAI-2;
    jAI{iAIcount}=nAI-2;
    xAI{iAIcount}=1;
    iAIcount=iAIcount+1;
    % Pump pressure increase equation Fake in this case
    iAI{iAIcount}=nAI-1;
    jAI{iAIcount}=nAI-1;
    xAI{iAIcount}=1;
    iAIcount=iAIcount+1;
else
    if termo.per_jet(1)
        [Wdr_c,Wtot_c]=fin_diff(@dWdrdt,termo.Wdr,termo.Wtot,termo.Krcl);
        % Pump drive flow
        iAI{iAIcount}=(nAI-2)*ones(1,2);%               1st node of lp1
        jAI{iAIcount}=[nAI-2 2*(sum(nsec(1:2))+1)];
        xAI{iAIcount}=[Wdr_c Wtot_c];
        iAIcount=iAIcount+1;
        % Pump pressure increase equation
        [Wdr_c,Wtot_c]=fin_diff(@eq_jet,termo.Wdr,termo.Wtot);
        iAI{iAIcount}=(nAI-1)*ones(1,3);
        jAI{iAIcount}=[nAI-1  nAI-2  2*(sum(nsec(1:2))+1)];
        xAI{iAIcount}=[ -Phc_sc    Wdr_c   Wtot_c];
        iAIcount=iAIcount+1;
    else
        % Pump speed (Torque eqation)
        [Wl_c,P_c,tl_c,n_c]=lin_DnDt(steady.Wl_lp1(1),p,steady.tl_lp1(1),termo.nhcpump);
        iAI{iAIcount}=(nAI-2)*ones(1,3);
        %                              1st node of lp1
        jAI{iAIcount}=[nAI-2 nAI       2*(sum(nsec(1:2))+1)];
        xAI{iAIcount}=[n_c   P_c*P_sc  Wl_c];
        iAIcount=iAIcount+1;
        % Pump pressure increase equation
        [Wl_c,n_c]=fin_diff(@eq_dP_pump,steady.Wl_lp1(1),termo.nhcpump);
        iAI{iAIcount}=(nAI-1)*ones(1,3);
        jAI{iAIcount}=[nAI-2  nAI-1  2*(sum(nsec(1:2))+1)];
        xAI{iAIcount}=[ n_c   -1  Wl_c];
        iAIcount=iAIcount+1;
        if termo.pump_larec,
            iBI{iBIcount}=nAI-1;
            jBI{iBIcount}=2*(sum(nsec(1:2))+1);
            xBI{iBIcount}=termo.pump_larec;
            iBIcount=iBIcount+1;
        end
    end
end
%% System Pressure
Pa2Bar=1e-5;
[P_c,gammav_c,tl_c]=lin_P(P,gammav,tl,alfa,A*hz/100);
iAI{iAIcount}=[nAI nAI];
jAI{iAIcount}=[nAI nAI+5];
xAI{iAIcount}=[P_c -15040/P_sc];
iAIcount=iAIcount+1;
iBI{iBIcount}=nAI;
jBI{iBIcount}=nAI;
xBI{iBIcount}=1;
%xBI{iBIcount}=-1j;
iBIcount=iBIcount+1;
iAIt{iAItcount}=nAI*ones(1,2*kd);
jAIt{iAItcount}=[ibas+1    ibas+4];
xAIt{iAItcount}=[tl_c(:)'  gammav_c(:)']/P_sc;
iAItcount=iAItcount+1;
%% Tryckreglering (Pressure Controller)
% Idel
Ti=5;
iAI{iAIcount}=nAI+1;
jAI{iAIcount}=nAI;
xAI{iAIcount}=P_sc*Pa2Bar/Ti;
iAIcount=iAIcount+1;
iBI{iBIcount}=nAI+1;
jBI{iBIcount}=nAI+1;
xBI{iBIcount}=1;
iBIcount=iBIcount+1;
%% Tryckreglering (Pressure Controller)
% Put
Kp=5*Pa2Bar;
iAI{iAIcount}=[nAI+2 nAI+2 nAI+2];
jAI{iAIcount}=[nAI nAI+1 nAI+2];
xAI{iAIcount}=[P_sc*Kp P_sc*Kp -1];
iAIcount=iAIcount+1;
%% Tryckreglering Neutronflödesfilter, Feed Forward from APRM
Tn=3;
iAI{iAIcount}=nAI+3;
jAI{iAIcount}=nAI+3;
xAI{iAIcount}=-1;
iAIcount=iAIcount+1;
iBI{iBIcount}=nAI+3;
jBI{iBIcount}=nAI+3;
xBI{iBIcount}=Tn;
iBIcount=iBIcount+1;
% APRM, note that q''' is in W/m^3, to get nodal the scaling hx^2*hz*1e-6
% is used. The 100 upfront and Qnom in the end is to scale it to percent
iAIq=(nAI+3)*ones(1,ntot);
jAIq=1:ntot;
xAIq=100*geom.hx*geom.hx*geom.hz*1e-6*get_sym(msopt)*matr.q3_sc*ones(1,ntot)/termo.Qnom;
AIq=sparse(iAIq,jAIq,xAIq,nAI+5,ntot);
%% Tryckreglering (Pressure Controller) Ordered steam from Reactor (BÅFR)
% BÅFR
iAI{iAIcount}=[nAI+4 nAI+4 nAI+4];
jAI{iAIcount}=[nAI+2 nAI+3 nAI+4];
xAI{iAIcount}=[1 1 -1];
iAIcount=iAIcount+1;
%% Tryckreglering BAFR to steamflow (steam flow in percent)
Tst=0.3;
iAI{iAIcount}=[nAI+5 nAI+5 nAI+5];
jAI{iAIcount}=[nAI nAI+4 nAI+5];
xAI{iAIcount}=[0.175*Pa2Bar*P_sc 1 -1];
iAIcount=iAIcount+1;
iBI{iBIcount}=nAI+5;
jBI{iBIcount}=nAI+5;
xBI{iBIcount}=Tst;
iBIcount=iBIcount+1;

else
    AIq=sparse(nAI,ntot);
end
%% Flow distribution
[a_c,tl_c,Wg_c,Wl_c,P_c]=fin_diff(@eq_Gm,alfa,tl,Wg,Wl,P,A,hz/100);
i_I=zeros(1,kd);
for i=1:ncc,
    istart=(i-1)*kmax+1;
    istop=i*kmax;
    i_I(istart:istop)=i*ones(1,kmax);
end
i_I=i_I+ntot*nt;
%{
% Delete this if it works
i_i=(1:ncc);
i_Wlin=(1:ncc);
i_basout=ibas(kmax:kmax:kd);
% Let Wlin be accounted for in AI:
i_IWl1=i_I;
i_IWl1(1:kmax:kd)=[];
ibas_Wl1=ibas;ibas_Wl1(1:kmax:kd)=[];
Wl_c=Wl_c(:)';
Wlin_c=Wl_c(1:kmax:kd);Wl_c(1:kmax:kd)=[];
%}
iAhyd{icount}=[i_I        i_I         i_I         i_I];
jAhyd{icount}=[ibas       ibas+1      ibas+2      ibas+3];
xAhyd{icount}=[a_c(:)'    tl_c(:)'    Wg_c(:)'    Wl_c(:)'];
icount=icount+1;
% I
iAhyd{icount}=nt*ntot+(1:ncc);
jAhyd{icount}=nt*ntot+ncc+(1:ncc);
xAhyd{icount}=-ones(1,ncc)*I_sc;
icount=icount+1;
%{
iAI{iAIcount}=1:ncc;
jAI{iAIcount}=1:ncc;
xAI{iAIcount}=Wlin_c;
iAIcount=iAIcount+1;
%}
iAtI{iAtIcount}=(1:ncc)+ntot*nt;
jAtI{iAtIcount}=nAI*ones(1,ncc);
xAtI{iAtIcount}=sum(P_c)*P_sc;
iAtIcount=iAtIcount+1;
if ~CoreOnly
%% Flow distribution impact from ex-core
% dc1
noll=0*P_dc1;
[dum,tl_c,dum,Wl_c]=fin_diff(@eq_Gm,noll,steady.tl_dc1,noll,steady.Wl_dc1,P_dc1,geom.a_dc1,geom.h_dc1);
[i_a,j_a,x_a]=get_index4AI(ncc,tl_c,Wl_c);
i_a=i_a+ntot*nt;
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a;
iAtIcount=iAtIcount+1;
% dc2
noll=0*P_dc2;
[dum,tl_c,dum,Wl_c]=fin_diff(@eq_Gm,noll,steady.tl_dc2,noll,steady.Wl_dc2,P_dc2,geom.a_dc2,geom.h_dc2);
[i_a,j_a,x_a]=get_index4AI(ncc,tl_c,Wl_c);
i_a=i_a+ntot*nt;
j_a=j_a+2*nsec(1);
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a;
iAtIcount=iAtIcount+1;
% lp1
noll=0*P_lp1;
[dum,tl_c,dum,Wl_c]=fin_diff(@eq_Gm,noll,steady.tl_lp1,noll,steady.Wl_lp1,P_lp1,geom.a_lp1,geom.h_lp1);
[i_a,j_a,x_a]=get_index4AI(ncc,tl_c,Wl_c);
i_a=i_a+ntot*nt;
j_a=j_a+2*sum(nsec(1:2));
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a;
iAtIcount=iAtIcount+1;
% lp2
noll=0*P_lp2;
[dum,tl_c,dum,Wl_c]=fin_diff(@eq_Gm,noll,steady.tl_lp2,noll,steady.Wl_lp2,P_lp2,geom.a_lp2,geom.h_lp2);
[i_a,j_a,x_a]=get_index4AI(ncc,tl_c,Wl_c);
i_a=i_a+ntot*nt;
j_a=j_a+2*sum(nsec(1:3));
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a;
iAtIcount=iAtIcount+1;
%% riser
lrsr=eq_lrsr(alfa_u,tl_u,Wl_u,Wg_u,P_u,A_u,geom.h_upl);
[a_c,tl_c,Wg_c,Wl_c,P_c]=fin_diff(@eq_Gm,alfa_u,tl_u,Wg_u,Wl_u,P_u,A_u,geom.h_upl*lrsr);
[alfa_l,tl_l,Wl_l,Wg_l,P_l]=fin_diff(@eq_lrsr,alfa_u,tl_u,Wl_u,Wg_u,P_u,A_u,geom.h_upl);
GmHz_u=eq_Gm(alfa_u,tl_u,Wg_u,Wl_u,P_u,A_u,1);
a_c(l_upl)=a_c(l_upl)+sum(GmHz_u*alfa_l);
tl_c(l_upl)=tl_c(l_upl)+sum(GmHz_u*tl_l);
Wg_c(l_upl)=Wg_c(l_upl)+sum(GmHz_u*Wg_l);
Wl_c(l_upl)=Wl_c(l_upl)+sum(GmHz_u*Wl_l);
P_c(l_upl)=P_c(l_upl)+sum(GmHz_u*P_l);
[i_a,j_a,x_a]=get_index4AI(ncc,a_c,tl_c,Wg_c,Wl_c);
i_a=i_a+ntot*nt;
j_a=j_a+2*sum(nsec(1:4));
iAtI{iAtIcount}=i_a;
jAtI{iAtIcount}=j_a;
xAtI{iAtIcount}=x_a;
iAtIcount=iAtIcount+1;
% P
iAtI{iAtIcount}=nt*ntot+(1:ncc);
jAtI{iAtIcount}=nAI*ones(1,ncc);
xAtI{iAtIcount}=sum(P_c)*ones(1,ncc)*P_sc;
iAtIcount=iAtIcount+1;
%% Equations in dc and lp, Quick and dirty for now, Wl(k-1) = Wl(k)
bas_dclp=(0:2:(ndclp-2)*2);
ett_dclp=ones(size(bas_dclp));
iAI{iAIcount}=[bas_dclp+2   bas_dclp+2];
jAI{iAIcount}=[bas_dclp+2   bas_dclp+2+2];
xAI{iAIcount}=[ett_dclp      -ett_dclp];
iAIcount=iAIcount+1;
% For tl in dc and lp, just put them to zero for now
% expand bas_dclp to include the last node of lp2
bas_dclp1=(0:2:(ndclp-1)*2);
ett_dclp1=ones(size(bas_dclp1));
%                tl
iAI{iAIcount}=bas_dclp1+1;
jAI{iAIcount}=bas_dclp1+1;
xAI{iAIcount}=ett_dclp1;
iAIcount=iAIcount+1;
%% Equations in riser     Phasic mass malance Aj.1
bas_u=(0:4:(l_upl-1)*4)+2*ndclp;
ett_u=ones(1,l_upl);
bas_u_neig=bas_u;
bas_u_neig(1)=[]; % Neighbour to first node in riser is core
%%{
[a_c,P_c2,tl_c2]=fin_diff(@eq_gamph,alfa_u,p,tl_u);
a_c=a_c.*V_u;
tl_c2=tl_c2.*V_u;
P_c2=P_sc*P_c2.*V_u;
ipr=1:nsec(6); % Here is where the dependence in riser can be turned on ipr=1:nsec(6);
ipr=[];        % turned off (ipr=[])
iAI{iAIcount}=[bas_u(ipr)+1 bas_u(ipr)+1 bas_u(ipr)+1];
jAI{iAIcount}=[bas_u(ipr)+1 bas_u(ipr)+2 nAI*ones(size(ipr))];
xAI{iAIcount}=[a_c(ipr)'    tl_c2(ipr)'  P_c2(ipr)'*P_sc];
iAIcount=iAIcount+1;
%}
%                Wg(k-1)       -Wg(k)     alfa   tl
iAI{iAIcount}=[bas_u_neig+1     bas_u+1];
jAI{iAIcount}=[bas_u_neig+3-4   bas_u+3];
xAI{iAIcount}=[ones(1,l_upl-1) -ones(1,l_upl)];

iAIcount=iAIcount+1;
% First node in riser connects with core
%                Wg(k-1)
iAIt{iAItcount}=(2*ndclp+1)*ones(1,ncc);
jAIt{iAItcount}=ibas(kmax:kmax:kd)+2;
xAIt{iAItcount}=ones(1,ncc)*get_sym;
iAItcount=iAItcount+1;
iBI{iBIcount}=bas_u+1;
jBI{iBIcount}=bas_u+1;
xBI{iBIcount}=rog*V_u';
iBIcount=iBIcount+1;
%% Energy Equation dromum/dt = hg(Wg(k-1)-Wg(k)) + hl (Wl(k-1)-Wl(k)) Eq.  Aj.2
[a_c,P_c,tl_c]=fin_diff(@eq_romum,alfa_u,P_u,tl_u,tsat);
%               alfa        tl            
iBI{iBIcount}=[bas_u+2    bas_u+2 bas_u+2];
jBI{iBIcount}=[bas_u+1    bas_u+2 nAI*ones(1,l_upl)];
xBI{iBIcount}=[V_u'.*a_c'  V_u'.*tl_c'  V_u'.*P_c'*P_sc]/E_sc;
iBIcount=iBIcount+1;
dy2dWl=-(cpl*(tl_u-tsat)+p./cor_rol(p,tl_u));
%                tl(k)     Wg(k)       Wl(k)
iAI{iAIcount}=[bas_u+2     bas_u+2             bas_u+2];
jAI{iAIcount}=[bas_u+2     bas_u+3             bas_u+4];
xAI{iAIcount}=[-cpl*Wl_u'  -(hfg+p/rog)*ett_u  dy2dWl']/E_sc;
iAIcount=iAIcount+1;
%                tl(k-1)              Wg(k-1)                       Wl(k-1)
iAI{iAIcount}=[bas_u_neig+2           bas_u_neig+2                  bas_u_neig+2];
jAI{iAIcount}=[bas_u_neig+2-4         bas_u_neig+3-4                bas_u_neig+4-4];
xAI{iAIcount}=[cpl*Wl_u(1:l_upl-1)'   (hfg+p/rog)*ones(1,l_upl-1)  -dy2dWl(1:l_upl-1)']/E_sc;
iAIcount=iAIcount+1;

% First node in riser connects with core
dy2dWln=cpl*(tl(kmax,:)-tsat)+p./rol(kmax,:);
ris_nod1=2*ndclp*ones(1,ncc);
nod_out=ibas(kmax:kmax:kd);
%                tl(k-1)              Wg(k-1)              Wl(k-1)
iAIt{iAItcount}=[ris_nod1+2      ris_nod1+2               ris_nod1+2];
jAIt{iAItcount}=[nod_out+1       nod_out+2                nod_out+3;];
xAIt{iAItcount}=[cpl*Wl(kmax,:)  (hfg+p/rog)*ones(1,ncc)  dy2dWln]*get_sym/E_sc;
iAItcount=iAItcount+1;
%% Wl = A*(1-alfa)*rol*(jm-c15*alfa)/(1+alfa*(S-1) Eq. Aj.3
[a_c,tl_c,Wg_c,Wl_c,P_c]=fin_diff(@eq_Wl_u,alfa_u,tl_u,Wg_u,Wl_u,P_u,A_u);
iAI{iAIcount}=[bas_u+3  bas_u+3 bas_u+3 bas_u+3   bas_u+3];
jAI{iAIcount}=[bas_u+4  bas_u+1 bas_u+2 bas_u+3   nAI*ones(1,l_upl)];
xAI{iAIcount}=[-1+Wl_c' a_c'    tl_c'   Wg_c'     P_c'*P_sc];
iAIcount=iAIcount+1;
%% Volumetric flow continuity in riser: 0 = Wl(k)/rol + Wg(k)/rog - Wl(k-1)/rol - Wg(k-1)/rog  (Aj.4)
[Wl_c,Wg_c,P_c,tl_c]=fin_diff(@eq_jm,Wl_u,Wg_u,P_u,tl_u,ett_u'); % Note 1 instead of A
tl_c_n=tl_c;
tl_c_n(l_upl)=[];
Wg_c_n=Wg_c;
Wg_c_n(l_upl)=[];
Wl_c_n=Wl_c;
Wl_c_n(l_upl)=[];
%               tl(k)         Wg(k)         Wl(k)     P             tl(k-1)         Wg(k-1)         Wl(k-1) 
iAI{iAIcount}=[bas_u+4       bas_u+4       bas_u+4   bas_u(1)+4     bas_u_neig+4    bas_u_neig+4    bas_u_neig+4];
jAI{iAIcount}=[bas_u+2       bas_u+3       bas_u+4   nAI            bas_u_neig+2-4  bas_u_neig+3-4  bas_u_neig+4-4];
xAI{iAIcount}=[tl_c'         Wg_c'         Wl_c'     P_c(1)*P_sc    -tl_c_n'        -Wg_c_n'       -Wl_c_n'];  
iAIcount=iAIcount+1;

iAIt{iAItcount}=(2*ndclp+4)*ones(1,ncc);
jAIt{iAItcount}=ibas(kmax:kmax:kd)+6;
xAIt{iAItcount}=-A(kmax,:)*get_sym;
iAItcount=iAItcount+1;
%% Let the phase communication be active in the first node in riser
%%{
[a_c,P_c,tl_c]=fin_diff(@eq_gamph,alfa_u,p,tl_u);
xr=1/rog-1./cor_rol(p,tl_u);
a_c=a_c.*V_u.*xr;
tl_c=tl_c.*V_u.*xr;
P_c=P_c.*V_u.*xr;
iAI{iAIcount}=[bas_u(ipr)+4   bas_u(ipr)+4   bas_u(ipr)+4];
jAI{iAIcount}=[bas_u(ipr)+2   bas_u(ipr)+1   nAI*ones(size(ipr))];
xAI{iAIcount}=[-tl_c(ipr)'     -a_c(ipr)'   -P_c(ipr)'*P_sc];  
iAIcount=iAIcount+1;
%}
end
%% Create the sparse matrices
iA=cat(2,iAhyd{:})';
jA=cat(2,jAhyd{:})';
xA=cat(2,xAhyd{:})';
At=sparse(iA,jA,xA,nt*kd+2*ncc,nt*kd+2*ncc);
iB=cat(2,iBhyd{:})';
jB=cat(2,jBhyd{:})';
xB=cat(2,xBhyd{:})';
Bt=sparse(iB,jB,xB,nt*kd+2*ncc,nt*kd+2*ncc);
iAtf=cat(2,iAtf{:})';
jAtf=cat(2,jAtf{:})';
xAtf=cat(2,xAtf{:})';
Atf=sparse(iAtf,jAtf,xAtf,nt*kd+2*ncc,nf*kd);
%Atf=sparse(nt*kd+2*ncc,nf*kd);
Atq=sparse(iAtq,jAtq,xAtq,nt*kd+2*ncc,kd);
if ~CoreOnly
%%
iAI=cat(2,iAI{:})';
jAI=cat(2,jAI{:})';
xAI=cat(2,xAI{:})';
AI=sparse(iAI,jAI,xAI,nAI+5,nAI+5);
iBI=cat(2,iBI{:})';
jBI=cat(2,jBI{:})';
xBI=cat(2,xBI{:})';
BI=sparse(iBI,jBI,xBI,nAI+5,nAI+5);
%AI(20,20)=1.3+0.37j; % Ugly modelling of external bypass
iAtI=cat(2,iAtI{:})';
jAtI=cat(2,jAtI{:})';
xAtI=cat(2,xAtI{:})';
AtI=sparse(iAtI,jAtI,xAtI,nt*kd+2*ncc,nAI+5);
iAIt=cat(2,iAIt{:})';
jAIt=cat(2,jAIt{:})';
xAIt=cat(2,xAIt{:})';
AIt=sparse(iAIt,jAIt,xAIt,nAI+5,nt*kd+2*ncc);
BtI=sparse(iBtI,jBtI,xBtI,nt*kd+2*ncc,nAI+5);
BtI=0*BtI;
else
   AI=[];BI=[];AIt=[];AtI=[];BtI=[];
end
% Numbering AI:
%              1    2     3    4    5     6
%       nsec=[ndc1 ndc2 nlp1 nlp2 kmax nriser]
%       tl before core      1:2:(2*(ndc1+ndc2+nlp1+nlp2))
%       Wl before core      1:2:(2*(ndc1+ndc2+nlp1+nlp2))
%       Set j_upl_bas=2*(ndc1+ndc2+nlp1+nlp2)+(0:4:(nriser*4-1))
%       alfa                j_upl_bas+1
%       tl                  j_upl_bas+2
%       Wg                  j_upl_bas+3
%       Wl                  j_upl_bas+4
%       NP(pump)(Wdr for Jet)   2*(ndc1+ndc2+nlp1+nlp2)+4*nriser+1 = nAI-2
%       dP(pump)                2*(ndc1+ndc2+nlp1+nlp2)+4*nriser+2 = nAI-1
%       P (system pressure)     2*(ndc1+ndc2+nlp1+nlp2)+4*nriser+3 = nAI
%%
matr.nAI=nAI;
steady.tw_dyn=tw;
