function [conv,alfa,tl,Wg,Wl,tw,ploss,dporif,prestr,pfric,pelev,pexp,Iboil]=syst_f4(fue_new,power,flowb,alfa,tl,Wg,Wl,tol)
%
%
% 

%%
global geom termo neu msopt
if ~isfield(msopt,'bwrdlp'), msopt.bwrdlp='on';end
ncc=geom.ncc;kan=ncc;
kmax=geom.kmax;
hx=geom.hx;
knum=geom.knum;
tlp=termo.tlp;tlb=tlp;

if nargin<8, tol=0.005; end

chflow=Wl(1,:);                                                                     

ini_tl=1;

if ~ini_tl,
    dt0=(283.7963-tlp)/4;
    tl0 = [tlp,tlp+dt0,tlp+2*dt0,tlp+3*dt0,283.7963,285.2436,285.9591,286.2996,286.4711,286.5717,...
        286.6528,286.7132,286.7572,286.7856,286.8033,286.8145,286.7791,286.7409,286.7171,286.6895,...
        286.6543,286.5985,286.5102,286.3726,286.1417]';
    tl=tl0*ones(1,kan);
end

twophasekorr=termo.twophasekorr;
delta=neu.delta;
deltam=neu.deltam;
qtherm=termo.Qtot/get_sym;
Wbyp = termo.Wtot/get_sym - sum(chflow+flowb);
aby=1.5330;
Dhby=0.0161;
p=termo.p;
htc=termo.htc;
tlp=termo.tlp;
hz=geom.hz;

tsat=cor_tsat(termo.p);
cpl=cor_cpl(tsat);
rog=cor_rog(tsat);
tlm=mean(mean(tl));
hfg=cor_hg(p,tlm,tsat);
rol=cor_rol(p,tl);
%Algebraic variables
P=p*ones(size(power));
%%
phm=fue_new.phfuel;
phm=phm(:,knum(:,1));
Dh=fue_new.dhfuel;
Dh=Dh(:,knum(:,1));
A=fue_new.afuel;
A=A(:,knum(:,1));
pbm=4*A./Dh-phm;
if ~isempty(fue_new.amdt)
    amdt=fue_new.amdt(knum(:,1));
    bmdt=fue_new.bmdt(knum(:,1));
else
    amdt=[];
    bmdt=[];
end

ntot=kmax*ncc;
qprimw = (1-delta)*power*qtherm/ntot./(hz/100);
qtrissf=power*qtherm/ntot/(hx/100)^2/(hz/100);
q3l = (delta-deltam)*qtrissf*(hx/100)^2./A;

%tlb=zeros(kmax,1);
%tlb(1)=tlp;tlb(2)=tlb(1);
vhifuel=fue_new.vhifuel(:,knum(:,1))';
vhofuel=fue_new.vhofuel(:,knum(:,1))';
Xcin=fue_new.Xcin(knum(:,1));
vhk = set_pkoeff(vhifuel,vhofuel,termo.avhspx,termo.arhspx,termo.zsp,termo.ispac,Wl,Wg,Dh,P,A,hz/100);
%%
nt=4;
k=1:kmax;
kd=kmax*ncc;
ibas=1:nt:kd*nt;i_off_diag=ibas;
i_off_diag(1:kmax:kd)=[];
ett=ones(size(ibas));
ett_o=ones(size(i_off_diag));
%% Total of (4*kmax-3)*ncc+1 equations 
% alfa: (kmax-1)*ncc unknowns, since alfa(1,:)=0 is assumed             1
% tl:   (kmax-1)*ncc unknowns, since tl(1,:)=tlp+dE(1,:)/cpl is assumed 2
% Wg    (kmax-1)*ncc unknowns, since Wg(1,:)=0 is assumed               3
% Wl     kmax*ncc unknowns                                4 and 5 (Wl(1,:)
% dPcore 1 unknown                                          treated as rhs
% Total of (4*kmax-3)*ncc+1 unknowns
% TODO: fix tlb
%% Equations to be solved
%{
y1=eq_alfa_core(alfa,tl,Wg,Wl,p,A);                             % kmax by ncc
y2=eq_Energy_core(alfa,tl,Wg,Wl,qprimw,q3l,tsat,P(1),A,hz,chflow,tlp);     % kmax by ncc
tlb=tlp;
y3=eq_Wg_core(alfa,tl,Wg,Wl,qprimw,p,A,hz,tlb,htc,pbm,phm,Dh);                     % kmax by ncc
y4=Wg+Wl-ones(kmax,1)*(chflow);                                 % kmax by ncc, note that chflow=Wl(1,:)!
y5=sum(Wl(1,:))-sum(chflow);                                    % 1 Equation
[ploss,y6]=eq_dP_core(alfa.*(alfa>0),tl,Wg,Wl,P,A,hz,flowb,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt); %  ncc
dPcore=mean(y6);
y6=y6-dPcore;
%}
%% dy1/dx
icount=1;
clear iJ jJ xJ
Y1tl=cpl*Wl(k,:)/1e5;                                   % dy1/dtl   
Y1tln=-cpl*Wl(1:kmax-1,:)/1e5;
Y12=q3l(k,:).*A(k,:)*hz/100/1e5;                        % dy1/dalfa
Y1Wg=(hfg+p/rog)/1e5;                                   % dy1/dWg
%Y1Wgn=-Y1Wg;                                           % dy1/dWgn
Y1Wl=cpl*(tl(k,:)-tsat)+p./rol(k,:);Y1Wl=Y1Wl/1e5;
Tl=[tl(1,:);tl];Rol=[rol(1,:);rol];
Y1Wln=-(cpl*(Tl(k,:)-tsat)+p./Rol(k,:));Y1Wln=Y1Wln(:)'/1e5;
j_off_diag=1:kd;j_off_diag(1:kmax:kd)=[];
Y1Wln=Y1Wln(j_off_diag);
dE_dchflow=-(cpl*(tlp-tsat)+p/cor_rol(p,tlp))*ones(1,ncc)/1e5;
iJ{icount}=[ibas+1 ibas+1 i_off_diag+1        ibas+1     i_off_diag+1    ibas+1   i_off_diag+1      (1:kmax*nt:nt*ntot)+1];
%              alfa   tl(k)    tl(k-1)           Wg(k)           Wg(k-1)    Wl(k)    Wl(k-1)    
jJ{icount}=[ibas     ibas+1   i_off_diag+1-nt  ibas+2      i_off_diag+2-nt ibas+3   i_off_diag+3-nt  nt*ntot+(1:ncc)];
xJ{icount}=[Y12(:)'  Y1tl(:)'  Y1tln(:)'       Y1Wg*ett    -Y1Wg*ett_o     Y1Wl(:)' Y1Wln            dE_dchflow];
icount=icount+1;
%% eq_alfa_core
[a_c,tl_c,Wg_c,Wl_c]=fin_diff(@eq_alfa_core,alfa,tl,Wg,Wl,p,A);
iJ{icount}=[ibas ibas ibas ibas];
jJ{icount}=[ibas ibas+1 ibas+2 ibas+3];
xJ{icount}=[a_c(:)' tl_c(:)' Wg_c(:)' Wl_c(:)'];
icount=icount+1;
%% eq_Wg_core
tw=eq_tw0(p,qprimw,htc,pbm,phm,tlb,tl,Wl,Wg,Dh,A);
gammav=eq_gamw(qprimw,p,tl,tw,A)+eq_gamph(alfa,p,tl);
twt=eq_tw0(p,qprimw,htc,pbm,phm,tlb,tl+.01,Wl,Wg,Dh,A);
gammavt=eq_gamw(qprimw,p,tl+.01,twt,A)+eq_gamph(alfa,p,tl+.01);
tl_c=-(gammavt-gammav).*A*hz/100/.01;
tl_c=tl_c.*(gammav>0);
C12=termo.cpb(2);
hfg=cor_hfg(p);
a_c=-C12*(1-2*alfa).*(tl-tsat).*A*hz/100/hfg;
iJ{icount}=[ibas+2   ibas+2    ibas+2   i_off_diag+2];
jJ{icount}=[ibas     ibas+1    ibas+2   i_off_diag+2-nt];
xJ{icount}=[a_c(:)'  tl_c(:)'    ett     -ett_o];
icount=icount+1;
%% Wl+Wg=chflow+flowb
iJP=zeros(1,ntot);
for i=1:ncc,
    iJP((i-1)*kmax+1:i*kmax)=i+ntot*nt;
end
iJ{icount}=[ibas+3   ibas+3    ibas+3];
jJ{icount}=[ibas+2   ibas+3    iJP];
xJ{icount}=[ett      ett       -ett];
icount=icount+1;
%% sum(chflow)=constant
if ~strcmp(msopt.bwrdlp,'off'),
iJ{icount}=(ntot*nt+ncc+1)*ones(1,ncc);
jJ{icount}=ntot*nt+(1:ncc);
xJ{icount}=ones(1,ncc);
icount=icount+1;
%% Ploss
[a_c,tl_c,Wg_c,Wl_c]=fin_diff(@eq_dP_core,alfa,tl,Wg,Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt);
iJ{icount}=[iJP     iJP      iJP      iJP    ntot*nt+(1:ncc)];
jJ{icount}=[ibas    ibas+1   ibas+2   ibas+3  (ntot*nt+ncc+1)*ones(1,ncc)];
xJ{icount}=[a_c(:)' tl_c(:)' Wg_c(:)' Wl_c(:)' -ones(1,ncc)];
icount=icount+1;
end
%%
iJ=cat(2,iJ{:})';
jJ=cat(2,jJ{:})';
xJ=real(cat(2,xJ{:})');
ndimJ=nt*kd+ncc+1;
J=sparse(iJ,jJ,xJ,ndimJ,ndimJ);
if strcmp(msopt.bwrdlp,'off'),
    J=J(1:nt*kd,1:nt*kd);
end
[L,U]=lu(J);
%%
if ~strcmp(msopt.bwrdlp,'off'),
tot_flow=sum(chflow);
[ploss,y6]=eq_dP_core(alfa,tl,Wg,Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt);
dPcore=mean(real(y6));
end
%%
if ~strcmp(msopt.bwrdlp,'off'),
    for i=1:10,
        [ploss,y6]=eq_dP_core(alfa,tl,Wg,Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt);
        y6=real(y6)-dPcore;
        y5=sum(chflow)-tot_flow;
        y2=eq_Energy_core(alfa,tl,Wg,Wl,qprimw,q3l,tsat,P(1),A,hz,chflow,tlp);
        y1=eq_alfa_core(alfa,tl,Wg,Wl,p,A);
        y3=eq_Wg_core(alfa,tl,Wl,Wg,qprimw,p,A,hz,tlb,htc,pbm,phm,Dh);
        y4=Wg+Wl-ones(kmax,1)*chflow;
        Y=[y1(:) y2(:) y3(:) y4(:)];Y=Y';Y=Y(:);
        Y=real([Y;y6(:);y5]);
        
        dY=-U\(L\Y);
        %dY=-J\Y;
        dalfa=reshape(dY(ibas),kmax,ncc);
        dtl=reshape(dY(ibas+1),kmax,ncc);
        dWg=reshape(dY(ibas+2),kmax,ncc);
        dWl=reshape(dY(ibas+3),kmax,ncc);
        alfa=alfa+dalfa;
        Wg=Wg+dWg;
        tl=tl+dtl;
        Wl=Wl+dWl;
        chflow=chflow+dY(ntot*nt+(1:ncc))';
        dPcore=dPcore+dY(ntot*nt+ncc+1);
        conv(i)=Y'*Y;
        %fprintf(1,'%15.5g \n',conv(i))
        if conv(i)<tol; break; end
        if i>3,
            if (conv(i)>0.9*conv(i-1))&&conv(i)>0.8*conv(i-2), break;end
        end
    end
    dporif=[];prestr=[];pfric=[];pelev=[];pexp=[];
else
    for i=1:30,
        y2=eq_Energy_core(alfa,tl,Wg,Wl,qprimw,q3l,tsat,P(1),A,hz,chflow,tlp);
        y1=eq_alfa_core(alfa,tl,Wg,Wl,p,A);
        y3=eq_Wg_core(alfa,tl,Wl,Wg,qprimw,p,A,hz,tlb,htc,pbm,phm,Dh);
        y4=Wg+Wl-ones(kmax,1)*chflow;
        Y=[y1(:) y2(:) y3(:) y4(:)];Y=Y';Y=Y(:);

        dY=-U\(L\Y);%dY=dY*.7;
        dalfa=reshape(dY(ibas),kmax,ncc);
        dtl=reshape(dY(ibas+1),kmax,ncc);
        dWg=reshape(dY(ibas+2),kmax,ncc);
        dWl=reshape(dY(ibas+3),kmax,ncc);
        alfa=alfa+dalfa;
        Wg=Wg+dWg;
        tl=tl+dtl;
        Wl=Wl+dWl;
        conv(i)=Y'*Y;
        fprintf(1,'%15.5g \n',conv(i))
        if conv(i)<tol; break; end
    end
    [ploss,dP,dporif,prestr,pfric,pelev,pexp]=eq_dP_core(alfa,tl,Wg,Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt);
end    
[tw,Iboil]=eq_tw0(p,qprimw,htc,pbm,phm,tlb,tl,Wl,Wg,Dh,A);

