function [stabn,stab1]=old2newmat(matfil_new,matfil_old)
% [stabn,stabo]=old2newmat(matfil_new,matfil_old)
% Translates old numbering to new for a matfile 

%%
load(matfil_new,'stab','matr','geom','fue_new','steady','msopt','termo','neu');
nAI=matr.nAI;
ifix=find(abs(stab.et-1)<1e-10);
if ~isempty(ifix),
    ifix=find(matr.ibas_t==ifix);
end
ibasf=matr.ibas_f; 
ibast=matr.ibas_t;
knum=geom.knum;
kmax=fue_new.kmax;
stabn.mminj=geom.mminj;
%% Pull out the variables from the new case
% alfa: (kmax-1)*ncc unknowns, since alfa(1,:)=0 is assumed             1 ibas
% tl:   (kmax-1)*ncc unknowns, since tl(1,:)=tlp+dE(1,:)/cpl is assumed 2 ibas+1
% Wg    (kmax-1)*ncc unknowns, since Wg(1,:)=0 is assumed               3 ibas+2
% Wl    (kmax-1)*ncc unknowns                                           4 ibas+3
% Gamv  (kmax-1)*ncc unknowns                                           5 ibas+4
% qprimw (kmax-1)*ncc unknowns, since qprimw(1,:) is of no interest     6 ibas+5
% jm    (kmax-1)*ncc unknowns                                           7
% ibas+6
ncc=size(knum,1);
stabn.lam=stab.lam;
stabn.Power=steady.Ppower;
stabn.en=sym_full(reshape(stab.en,kmax,ncc),knum);
stabn.eq=sym_full(reshape(stab.eq,kmax,ncc),knum);
stabn.evoid=sym_full(reshape(stab.et(ibast),kmax,ncc),knum);
stabn.etl=sym_full(reshape(stab.et(ibast+1),kmax,ncc),knum);
stabn.eWg=sym_full(reshape(stab.et(ibast+2),kmax,ncc),knum);
stabn.eWl=sym_full(reshape(stab.et(ibast+3),kmax,ncc),knum);
stabn.eGamw=sym_full(reshape(stab.et(ibast+4),kmax,ncc),knum);
stabn.eqp=matr.qp_sc*sym_full(reshape(stab.et(ibast+5),kmax,ncc),knum);
stabn.ejm=sym_full(reshape(stab.et(ibast+6),kmax,ncc),knum);
if ibasf(2)-ibasf(1)>6,
    stabn.etw=sym_full(reshape(stab.ef(ibasf+6),kmax,ncc),knum);
end
if nAI<(2*sum(geom.nsec(1:4))+4*geom.nsec(6)), % New style
    stabn.eWldc=stab.ej(1);
else
    stabn.eWldc=stab.ej(2);
end
j_upl_bas=nAI-3-4*geom.nsec(6)+(0:4:(geom.nsec(6)*4-1));
stabn.ev_upl=stab.ej(j_upl_bas+1);
stabn.etl_upl=stab.ej(j_upl_bas+2);
stabn.eWg_upl=stab.ej(j_upl_bas+3);
stabn.eWl_upl=stab.ej(j_upl_bas+4);
stabn.eN=stab.ej(matr.nAI-2);
stabn.edP=stab.ej(matr.nAI-1);
ef=stab.ef;
if ibasf(2)-ibasf(1)>6,
    ef(ibasf+6)=[];
end
lillbasf=1:6:(ncc*kmax*6);
stabn.ef1=sym_full(reshape(ef(lillbasf),kmax,ncc),knum);
stabn.ef2=sym_full(reshape(ef(lillbasf+1),kmax,ncc),knum);
stabn.ef3=sym_full(reshape(ef(lillbasf+2),kmax,ncc),knum);
stabn.ef4=sym_full(reshape(ef(lillbasf+3),kmax,ncc),knum);
stabn.ef5=sym_full(reshape(ef(lillbasf+4),kmax,ncc),knum);
stabn.ef6=sym_full(reshape(ef(lillbasf+5),kmax,ncc),knum);
stabn.ej=stab.ej;
stabn.eSHF=100*geom.hz/100*sum(stabn.eqp(:))/termo.Qnom; % (SHF in %)
% APRM, note that q''' is in W/m^3, to get nodal the scaling hx^2*hz*1e-6
% is used. The 100 upfront and Qnom in the end is to scale it to percent
stabn.eAPRM=matr.q3_sc*100*geom.hx*geom.hx*geom.hz*1e-6*sum(stabn.eq(:))/termo.Qnom;
stabn.eQcool=stabn.eSHF+(neu.delta-neu.deltam)*stabn.eAPRM;
stabn.eP=stab.ej(nAI)*matr.P_sc/1e5; % In BAR, matr.P_sc is 1e5 presently, so
                                     % right now matr.P_sc/1e5=1, but if we
                                     % change the scaling this precation
                                     % may avoid confusion
if length(stab.ej)>nAI,
    stabn.ePut=stab.ej(nAI+2);
    stabn.eNeutfilt=stab.ej(nAI+3);
    stabn.eBAFR=stab.ej(nAI+4);
    stabn.emst=stab.ej(nAI+5);
end

stabn.msopt=msopt;
%%
if nargout>1
matfilnew=['new',matfil_old];
load(matfil_old,'geom','steady','msopt','termo','stab')
exflag=true;
try
    load(matfil_old,'ex');
    e=ex;
catch
    e=stab.e;
    exflag=false;
end
%%
k=geom.k;
r=geom.r;
e=e/e(r(ifix));
kc=geom.nin(5):geom.nout(geom.ncc+5);
index=(geom.ncc+1):(geom.ncc+1):length(kc);
kc=kc(index);
ibypass=(kc-1)*geom.nvt+2;
%%
stab1.lam=stab.lam;
stab1.Power=steady.Ppower;
stab1.en=sym_full(reshape(e(k),kmax,ncc),knum);
stab1.eq=sym_full(reshape(e(k+5),kmax,ncc),knum);
%%
stab1.ef1=sym_full(reshape(e(k+6),kmax,ncc),knum);
stab1.ef2=sym_full(reshape(e(k+7),kmax,ncc),knum);
stab1.ef3=sym_full(reshape(e(k+8),kmax,ncc),knum);
stab1.ef4=sym_full(reshape(e(k+9),kmax,ncc),knum);
stab1.ef5=sym_full(reshape(e(k+10),kmax,ncc),knum);
stab1.ef6=sym_full(reshape(e(k+11),kmax,ncc),knum);
stab1.evoid=sym_full(reshape(e(r),kmax,ncc),knum);
stab1.eE=sym_full(reshape(e(r+1),kmax,ncc),knum);
stab1.etl=sym_full(reshape(e(r+6),kmax,ncc),knum);
stab1.ejm=sym_full(reshape(e(r+11),kmax,ncc),knum);
stab1.evoid_byp=e(ibypass);
stab1.eE_byp=e(ibypass+1);
stab1.etl_byp=e(ibypass+6);
stab1.ejm_byp=e(ibypass+11);
stab1.eAPRM=1e6*100*geom.hx*geom.hx*geom.hz*1e-6*sum(stab1.eq(:))/termo.Qnom;
stab1.eP=e(1)*1e6/1e5; % See scale_A, ke(1)=1e-6, kv(1)=1e6
                       % Then we convert to BAR, thus /1e5
stab1.eN=e(geom.k(1)-2);
stab1.edP=e(geom.k(1)-1)*1e4; % See scale_A, kv(j+1) = 1e4; %p hcpump, 
                                 
j_upl_bas=(geom.k(1)-3-geom.ncc-13*(geom.nsec(6)+1)):13:(geom.k(1)-3-geom.ncc-1);
stab1.ev_upl=e(j_upl_bas);
stab1.eE_upl=e(j_upl_bas+1);
stab1.eWl_upl=e(j_upl_bas+3);
stab1.etl_upl=e(j_upl_bas+6);
stab1.eWg_upl=e(j_upl_bas+8);
stab1.ejm_upl=e(j_upl_bas+11);
if exflag,
    stab1.ealfa=sym_full(reshape(e(r+2),kmax,ncc),knum);
    stab1.eWl=sym_full(reshape(e(r+3),kmax,ncc),knum);
    stab1.eGamw=sym_full(reshape(e(r+4),kmax,ncc),knum);
    qp_sc=1e8; % see scale_A, qprimw
    stab1.eqp=qp_sc*sym_full(reshape(e(r+5),kmax,ncc),knum);
    stab1.etw=sym_full(reshape(e(r+7),kmax,ncc),knum);
    stab1.eWg=sym_full(reshape(e(r+8),kmax,ncc),knum);
    stab1.ewg=sym_full(reshape(e(r+9),kmax,ncc),knum);
    stab1.eS=sym_full(reshape(e(r+10),kmax,ncc),knum);
    stab1.ephi=sym_full(reshape(e(r+12),kmax,ncc),knum);
    stab1.eSHF=qp_sc*100*geom.hz/100*sum(stab1.eqp(:))/termo.Qnom;
    stab1.eWldc=e(18);
end

stab1.msopt=msopt;
end






