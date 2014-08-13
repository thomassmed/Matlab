function [err,power,alfa,tl,Wg,Wl,flowb,Wbyp,tw,tcm,tfm,tfmm,Iboil,keff,fa1,fa2,ploss,dp_wr,dpin,dp_sup,Sn]=syst_f57(power,flowb,alfa,dens0,tl,Wg,Wl,Wbyp,tfmm0,tol,fa1,fa2,keff,...
    d10,d20,sigr0,siga10,siga20,usig10,usig20,ny,d1d,d2d,sigrd,siga1d,siga2d,usig1d,usig2d,...
    d1t,d2t,sigrt,siga1t,siga2t,usig1t,usig2t,neig,a11,a21,a22,cp,n_iter,nn_iter,DF1,DF2,Sn,C1nm,C2nm,fid,NeuModel)
%
%
% 

if nargin<8, tol=0.005; end
%%
global geom termo neu fuel msopt
ncc=geom.ncc;kan=ncc;
kmax=geom.kmax;
hx=geom.hx;
knum=geom.knum;
tlp=termo.tlp;tlb=tlp;
Midpoint=get_bool(msopt.Midpoint);


chflow=Wl(1,:);   

twophasekorr=termo.twophasekorr;
delta=neu.delta;
deltam=neu.deltam;
qtherm=termo.Qtot/get_sym;

aby=1.5330;
Dhby=0.0161;
p=termo.p;
htc=termo.htc;
tlp=termo.tlp;
hz=geom.hz;

  mmc=fuel.mmc;
  rf=fuel.rf;
  rca=fuel.rca;
  drca=fuel.drca;
  nrods=fuel.nrods;
  rcca=fuel.rcca;
  e1=fuel.e1;
  e2=fuel.e2;
  gcamx=fuel.gcamx;
  gca0=fuel.gca0;
  gca1=fuel.gca1;
  gca2=fuel.gca2;
  rlca=fuel.rlca;

tsat=cor_tsat(termo.p);
cpl=cor_cpl(tsat);
rog=cor_rog(tsat);
tlm=mean(mean(tl));
hfg=cor_hg(p,tlm,tsat);
rol=cor_rol(p,tl);
%Algebraic variables
P=p*ones(size(power));
%%
amdt=termo.amdt;
bmdt=termo.bmdt;
phm=termo.phm;
Dh=termo.Dh;
pbm=termo.pbm;
A=geom.A;
A_wr=termo.A_wr;
Ph_wr=termo.Ph_wr;
Dhy_wr=termo.Dhy_wr;
Kin_wr=termo.Kin_wr;
Kex_wr=termo.Kex_wr;
i_wr=size(A_wr,1);
Xcin=termo.Xcin;

ntot=kmax*ncc;
qprimw = (1-delta)*power*qtherm/ntot./(hz/100);
qtrissf=power*qtherm/ntot/(hx/100)^2/(hz/100);
q3l = (delta-deltam)*qtrissf*(hx/100)^2./A;

%tlb=zeros(kmax,1);
%tlb(1)=tlp;tlb(2)=tlb(1);
vhifuel=termo.vhifuel;
vhofuel=termo.vhofuel;
amdt=termo.amdt;
bmdt=termo.bmdt;

vhk = set_pkoeff(vhifuel,vhofuel,termo.avhspx,termo.arhspx,termo.zsp,termo.ispac,Wl,Wg,Dh,P,A,hz/100);
%%
nt=5;
k=1:kmax;
kd=kmax*ncc;
ibas=1:nt:kd*nt;i_off_diag=ibas;
i_off_diag(1:kmax:kd)=[];
ett=ones(size(ibas));
ett_o=ones(size(i_off_diag));
%% Total of (4*kmax-3)*ncc+1 equations 
% tl:   (kmax-1)*ncc unknowns, since tl(1,:)=tlp+dE(1,:)/cpl is assumed 1
% alfa: (kmax-1)*ncc unknowns, since alfa(1,:)=0 is assumed             2
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
[ploss,y6]=eq_dP_core(alfa.*(alfa>0),tl,Wg,Wl,P,A,hz,flowb,vhk,Dh); %  ncc
dPcore=mean(y6);
y6=y6-dPcore;
%}
%% dy1/dx
icount=1;
icount21=1;
icount2=1;
icount12=1;
clear iJ jJ xJ iJ2 jJ2 xJ2 iJ12 jJ12 xJ12 iJ21 jJ21 xJ21
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
Y17=-(qtherm/ntot*(1-delta+(1-alfa)*(delta-deltam)))/1e5;
iJ{icount}=[ibas+1 ibas+1 i_off_diag+1        ibas+1     i_off_diag+1    ibas+1   i_off_diag+1      ibas+1];
%              alfa   tl(k)    tl(k-1)           Wg(k)           Wg(k-1)    Wl(k)    Wl(k-1)    
jJ{icount}=[ibas     ibas+1   i_off_diag+1-nt  ibas+2      i_off_diag+2-nt ibas+3   i_off_diag+3-nt ibas+4];
xJ{icount}=[Y12(:)'  Y1tl(:)'  Y1tln(:)'       Y1Wg*ett    -Y1Wg*ett_o     Y1Wl(:)' Y1Wln           Y17(:)'];
icount=icount+1;
iJ12{icount12}=(1:kmax*nt:nt*ntot)+1;
jJ12{icount12}=1:ncc;
xJ12{icount12}=dE_dchflow(:)';
icount12=icount12+1;
y2=eq_Energy_core(alfa,tl,Wg,Wl,qprimw,q3l,tsat,P(1),A,hz,chflow,tlp);
y22=eq_Energy_core(alfa,tl,Wg,Wl,qprimw*1.001,q3l*1.001,tsat,P(1),A,hz,chflow,tlp);
dydp=(y22-y2)*1000;
iJ{icount}=[ibas+1];
jJ{icount}=[ibas+4];
xJ{icount}=[dydp(:)'];
icount=icount+1;
%% eq_alfa_core
[a_c,tl_c,Wg_c,Wl_c]=fin_diff(@eq_alfa_core,alfa,tl,Wg,Wl,p,A);
iJ{icount}=[ibas ibas ibas ibas];
jJ{icount}=[ibas ibas+1 ibas+2 ibas+3];
xJ{icount}=[a_c(:)' tl_c(:)' Wg_c(:)' Wl_c(:)'];
icount=icount+1;
%% eq_Wg_core
[tw,Iboil]=eq_tw0(p,qprimw,htc,pbm,phm,tlb,tl,Wl,Wg,Dh,A);
gammav=eq_gamv(eq_gamw(qprimw,p,tl,tw,A),eq_gamph(alfa,p,tl));

[tw_l,Iboil_l]=eq_tw0(p,qprimw,htc,pbm,phm,tlb,tl+0.01,Wl,Wg,Dh,A);
gammav_l=eq_gamv(eq_gamw(qprimw,p,tl+0.01,tw_l,A),eq_gamph(alfa,p,tl+0.01));
tl_c=-(gammav_l-gammav).*A*hz;

C12=termo.cpb(2);
hfg=cor_hfg(p);
a_c=-C12*(1-2*alfa).*(tl-tsat).*A*hz/100/hfg;
iJ{icount}=[ibas+2   ibas+2    ibas+2   i_off_diag+2];  
jJ{icount}=[ibas     ibas+1    ibas+2   i_off_diag+2-nt];
xJ{icount}=[a_c(:)'  tl_c(:)'    ett     -ett_o  ];
icount=icount+1;

[y3,tw,Iboil]=eq_Wg_core(alfa,tl,Wl,Wg,qprimw,p,A,hz,tlb,htc,pbm,phm,Dh);
y33=eq_Wg_core(alfa,tl,Wl,Wg,qprimw*1.001,p,A,hz,tlb,htc,pbm,phm,Dh);
dydp=(y33-y3)*1000;
iJ{icount}=[ibas+2];  
jJ{icount}=[ibas+4];
xJ{icount}=[dydp(:)'];
icount=icount+1;
%% Wl+Wg=chflow+flowb
iJ{icount}=[ibas+3   ibas+3];
jJ{icount}=[ibas+2   ibas+3];
xJ{icount}=[ett      ett];
icount=icount+1;
iJP=zeros(1,ntot);
for i=1:ncc,
    iJP((i-1)*kmax+1:i*kmax)=i;
end
iJ12{icount12}=ibas+3;
jJ12{icount12}=iJP;
xJ12{icount12}=-ett;
icount12=icount12+1;
%% sum(chflow)=constant
iJ2{icount2}=2*ncc+ones(1,ncc);
jJ2{icount2}=(1:ncc);
xJ2{icount2}=ones(1,ncc);
icount2=icount2+1;
iJ2{icount2}=2*ncc+ones(1,ncc); %Flowb part
jJ2{icount2}=ncc+(1:ncc);
xJ2{icount2}=ones(1,ncc);
icount2=icount2+1;
%% Power
%iJ{icount}=[ibas+4  i_off_diag+4   ibas+4];
%jJ{icount}=[ibas    i_off_diag-nt   ibas+4];
%xJ{icount}=[-.6*sqrt(power(:)')  -.5*sqrt(power(j_off_diag)) -ett];
% xJ{icount}=[-.7*ett  -.3*ones(1,length(j_off_diag)) -ett];
iJ{icount}=[ibas+4  ibas+4];
jJ{icount}=[ibas   ibas+4];
%xJ{icount}=[-sqrt(power(:))' -ett];
xJ{icount}=[-.8*power(:)' -ett];
icount=icount+1;
%%
iJ=cat(2,iJ{:})';
jJ=cat(2,jJ{:})';
xJ=real(cat(2,xJ{:})');
J=sparse(iJ,jJ,xJ,nt*kd,nt*kd);
[L,U]=lu(J);
%%
iJ12=cat(2,iJ12{:})';
jJ12=cat(2,jJ12{:})';
xJ12=real(cat(2,xJ12{:})');
J12=sparse(iJ12,jJ12,xJ12,ntot*nt,2*ncc+1);
%%
%tot_flow=sum(chflow+flowb)+Wbyp;
tot_flow=termo.Wtot/get_sym;
[ploss,y6,dpin]=eq_dP_core(alfa,tl,Wg.*(Wg>0),Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt);
dPcore=mean(y6);
a_c=(eq_dP_core(alfa+0.01,tl,Wg.*(Wg>0),Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt)-ploss)/.01;
tl_c=(eq_dP_core(alfa,tl+1,Wg.*(Wg>0),Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt)-ploss);
Wl_c=(eq_dP_core(alfa,tl,Wg.*(Wg>0),Wl+0.01,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt)-ploss)/.01;
flowbc=(eq_dP_core(alfa,tl,Wg.*(Wg>0),Wl+0.01,flowb+0.01,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt)-ploss)/.01;
chfl_c=Wl_c(1,:);
Wl_c(1,:)=0*Wl_c(1,:);
dJ=U\(L\J12);
iJ21=[iJP     iJP      iJP      iJP];
jJ21=[ibas    ibas+1   ibas+2   ibas+3];
Wg_c=(eq_dP_core(alfa,tl,Wg.*(Wg>0)+0.1,Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt)-ploss)/.1;
xJ21=[a_c(:)' tl_c(:)' Wg_c(:)' Wl_c(:)'];
J21=sparse(iJ21,jJ21,real(xJ21),2*ncc+1,ntot*nt);
%% chflow and flowb
iJ2{icount2}=1:ncc;
jJ2{icount2}=1:ncc;
xJ2{icount2}=chfl_c;
icount2=icount2+1;
iJ2{icount2}=1:ncc;
jJ2{icount2}=(ncc+1):2*ncc;
xJ2{icount2}=flowbc(1,:);
icount2=icount2+1;
rol_lp=cor_rol(p,tlp);
rol_by=0.5*cor_rol(p,tsat)+0.5*rol_lp;
dp_wr=(dPcore-dpin)-hz/100*kmax*9.81*rol_by;
dp_wr=dp_wr.*(dp_wr>0);
flowbc1=zeros(1,ncc);
for j=1:i_wr
    flowbc1=flowbc1+sqrt(rol_lp./(2*dp_wr.*Kin_wr(j,:)+eps)).*A_wr(j,:);
end
%               flowb        chflow           dP
iJ2{icount2}=[(ncc+1):2*ncc (ncc+1):2*ncc (ncc+1):2*ncc];
jJ2{icount2}=[(ncc+1):2*ncc  1:ncc         ones(1,ncc)*(2*ncc+1)];
xJ2{icount2}=[ones(1,ncc)   -chfl_c.*flowbc1  flowbc1];
icount2=icount2+1;
%% Ploss
iJ2{icount2}=1:ncc;
jJ2{icount2}=(2*ncc+1)*ones(1,ncc);
xJ2{icount2}=-ones(1,ncc);
iJ2=cat(2,iJ2{:})';
jJ2=cat(2,jJ2{:})';
xJ2=real(cat(2,xJ2{:})');
J2=sparse(iJ2,jJ2,xJ2,2*ncc+1,2*ncc+1);
%J2_=J2-J21*dJ;
%[L2,U2]=lu(J2_);
%%
iupd=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
ipow=[1 2 3 4 5 6 8 10 12 14 16 18 20];
%iupd=[1 4 7 10 13 16 19];
%iupd=1:2:20;
Power{1}=sym_full(power);
WL{1}=sym_full(Wl);
Flowb{1}=sym_full(flowb);
WBYP(1)=Wbyp;
ALFA{1}=sym_full(alfa);
flowbvar=flowb;
debug_mode=0; %TODO fixa O1
if debug_mode,
    DdPcore=1000;
    calc_pow
    Pown{1}=sym_full(reshape(pown,kmax,ncc));
end
for i=1:20, 
    if any(iupd==i),
        [ploss,y6,dpin]=eq_dP_core(alfa,tl,Wg,Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt);
        flowb=0*flowb;
        dp_wr=(sum(ploss)-dpin)-hz/100*kmax*9.81*rol_by;
        %dp_wr=(dPcore-dpin)-hz/100*kmax*9.81*rol_by;
        dp_wr=dp_wr.*(dp_wr>0);
        for j=1:i_wr
            flowb=flowb+sqrt(2*rol_lp*dp_wr./(Kin_wr(j,:)+eps)).*A_wr(j,:);
        end
        dp_sup=mean(real(y6))-hz/100*kmax*9.81*rol_by;
        %TODO: fix this properly
        switch upper(msopt.BYP)
            case 'SUP'
                Wbyp=0;     % TODO: Fix leakage flow
                for j=1:length(termo.casup),
                    Wbyp=Wbyp+(termo.casup(j)*sqrt(dp_sup)+termo.cbsup(j)*dp_sup+termo.ccsup(j)*dp_sup*dp_sup)*sqrt(rol_lp/termo.rhoref_bypass(1));
                end
                Wbyp=Wbyp/get_sym;
            case 'S3K'
                Wbyp=termo.Wbyp_S3K*termo.Wtot/get_sym-sum(flowb);
            case 'FRAC'
                Wbyp=termo.Wbyp_frac*termo.Wtot/get_sym;
                Wbyp=Wbyp-sum(flowb);
            otherwise
                if ischar(msopt.BYP),
                    msopt.BYP=str2double(msopt.BYP);
                end
                Wbyp=msopt.BYP*termo.Wtot/get_sym;
        end
        WBYP(i+1)=Wbyp;
        DdPcore_bck=(mean(real(y6))-dPcore);
        y6=real(y6)-dPcore;
        Y6{i}=y6;
        chflow=Wl(1,:);
%         if i>2,
%             idamp_y6=find((Y6{i-1}.*Y6{i})./max(abs([Y6{i-1}';Y6{i}'])).^2<-.7);
%             if ~isempty(idamp_y6),
%                 damp_f=abs(Y6{i}(idamp_y6))./(abs(Y6{i}(idamp_y6))+abs(Y6{i-1}(idamp_y6)));
%                 damp_f=max(damp_f,.5);
%                 y6(idamp_y6)=y6(idamp_y6).*damp_f;
%             end
%         end
        yb=flowbvar-flowb;
        y5=sum(chflow)+sum(flowbvar)+Wbyp-tot_flow;
        Y2=[real(y6(:));yb(:);y5];
        if 1,%i<4,
            Wg_c=(eq_dP_core(alfa,tl,Wg+0.01,Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt)-ploss)/.01;
            xJ21=[a_c(:)' tl_c(:)' Wg_c(:)' Wl_c(:)'];
            J21=sparse(iJ21,jJ21,real(xJ21),2*ncc+1,ntot*nt);
            J2_=J2-J21*dJ;
            [L2,U2]=lu(J2_);
        end
        if i==1, DdPcore=1000;end
        calc_Y
        y7=zeros(size(y4));
        Y=[y1(:) y2(:) y3(:) y4(:) y7(:)];Y=Y';Y=Y(:);   
        Y2=Y2-J21*(U\(L\Y));
        dY2=-U2\(L2\Y2);
        dfl=dY2(1:ncc);
        dflb=dY2((ncc+1):2*ncc);
        if i<3, dampfl=1;else dampfl=1;end
        DdPcore=dY2(2*ncc+1);
        dPcore=dPcore+dampfl*DdPcore;
        chflow=chflow+dampfl*dfl';
        flowbvar=flowbvar+dampfl*dflb';
        flowb=flowbvar;
        %Flowb{i+1}=sym_full(flowb);
        Wl(1,:)=chflow;
    end
    calc_Y
    calc_pow
    y7=pown-power(:);y7=.6*y7;
    Y=[y1(:) y2(:) y3(:) y4(:) y7(:)];Y=Y';Y=Y(:);    
    dY=-U\(L\Y);
    dalfa=reshape(dY(ibas),kmax,ncc);
    dtl=reshape(dY(ibas+1),kmax,ncc);
    dWg=reshape(dY(ibas+2),kmax,ncc);
    dWl=reshape(dY(ibas+3),kmax,ncc);
    dPow=reshape(dY(ibas+4),kmax,ncc);
    ii=find(abs(dalfa(:))>0.99*abs(alfa(:)));
    damp=1;
    dPow(ii)=damp*dPow(ii);
    dalfa(ii)=damp*dalfa(ii);
    dtl(ii)=damp*dtl(ii);
    dWg(ii)=damp*dWg(ii);
    dWl(ii)=damp*dWl(ii);
    DPOW{i}=dPow;
    if 0,%>1,
      dampp=1;
      idamp_pow=find((DPOW{i-1}(:).*DPOW{i}(:))./max(abs([DPOW{i-1}(:)';DPOW{i}(:)']))'.^2<-.7);
      if ~isempty(idamp_pow),
          dampp=abs(DPOW{i}(idamp_pow))./(abs(DPOW{i-1}(idamp_pow))+abs(DPOW{i}(idamp_pow)));
          dampp=max(dampp,.5);
          dalfa(idamp_pow)=dalfa(idamp_pow).*dampp;
          dtl(idamp_pow)=dtl(idamp_pow).*dampp;
          dWg(idamp_pow)=dWg(idamp_pow).*dampp;
          dWl(idamp_pow)=dWl(idamp_pow).*dampp;
          dPow(idamp_pow)=dPow(idamp_pow).*dampp;
      end
      %     iboost_pow=find((DPOW{i-1}(:).*DPOW{i}(:))./max(abs([DPOW{i-1}(:)';DPOW{i}(:)']))'.^2>0.8);
 %     dPow(iboost_pow)=dPow(iboost_pow)*1.2;
    end
    power=power+dPow;
    qprimw = (1-delta)*power*qtherm/ntot./(hz/100);
    qtrissf=power*qtherm/ntot/(hx/100)^2/(hz/100);
    q3l = (delta-deltam)*qtrissf*(hx/100)^2./A;
    alfa=alfa+dalfa;
    Wg=Wg+dWg;
    tl=tl+dtl;
    Wl=Wl+dWl;
    conv1(i)=Y'*Y;
    conv2(i)=Y2'*Y2;
    if debug_mode,
        Power{i+1}=sym_full(power);
        WL{i+1}=sym_full(Wl);
        Flowb{i+1}=sym_full(flowb);
        WBYP(i+1)=Wbyp;
        ALFA{i+1}=sym_full(alfa);
        Pown{i+1}=sym_full(reshape(pown,kmax,ncc));
    end
    [xy,iy]=max(abs(Y));
    [xy2,iy2]=max(abs(Y2));
    [xp,ip]=max(abs(y7));

%fprintf(1,'%i,%i,%2i %11.5f %11.5f %11.5f %11.5f %8i %8i %11.5f %11.5f\n',n_iter,nn_iter,i,dPow(ip),DdPcore/1000,keff,Y(iy),iy,iy2,Y2(iy2),DdPcore_bck);
 %   fprintf(1,'%2i %11.5f %11.5f %11.5f %11.5f %8i %8i %11.5f %11.5f\n',i,dPow(ip),DdPcore/1000,keff,Y(iy),iy,iy2,Y2(iy2),power(ip));
    fprintf(1,'%2i %11.5f %11.5f %11.5f \n',i,dPow(ip),DdPcore/1000,keff);
    if xp<tol && DdPcore/1000<tol, break; end
end
[xx,ii]=max(abs(y7));
[xx,iii]=max(abs(Y2));
err=[conv1(i) conv2(i)/1e3 norm(Y) norm(Y2)/1e3 y7(ii) Y2(iii)/1e3 max(abs(dPow(:))) DdPcore/1000];
if debug_mode
    [ploss,dP,dpin,prestr,pfric,pelev,pexp]=eq_dP_core(alfa,tl,Wg,Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt);
    save msdebug_powvoid ploss dP dpin prestr pfric pelev pexp Power Pown ALFA WL Flowb WBYP
end

    function calc_Y
        y1=eq_alfa_core(alfa,tl,Wg,Wl,p,A);
        if i>1,
            y2=eq_Energy_core(alfa,tl,Wg,Wl,qprimw,q3l,tsat,P(1),A,hz,chflow,tlp);
            [y3,tw,Iboil]=eq_Wg_core(alfa,tl,Wl,Wg,qprimw,p,A,hz,tlb,htc,pbm,phm,Dh);
        end
        y4=Wg+Wl-ones(kmax,1)*chflow;
    end
    function calc_pow
        [tfm,tcm] =eq_tftc(tw(:),qtherm,power(:),hz,rf,e1,e2,gca0,gca1,gca2,gcamx,rlca,rca,drca,rcca,p,delta,nrods);
        tfmm=mean(tfm')';tfmm=reshape(tfmm,kmax,ncc);
        if Midpoint
            alfam=bound2mid(alfa);
        else
            alfam=alfa;
        end
        densm=void2dens(alfam,P,tl)/1000;
        d1=d10+d1d.*(densm-dens0)+d1t.*(tfmm-tfmm0);
        d2=d20+d2d.*(densm-dens0)+d2t.*(tfmm-tfmm0);
        sigr=sigr0+sigrd.*(densm-dens0)+sigrt.*(tfmm-tfmm0);
        siga1=siga10+siga1d.*(densm-dens0)+siga1t.*(tfmm-tfmm0);
        siga2=siga20+siga2d.*(densm-dens0)+siga2t.*(tfmm-tfmm0);
        usig1=usig10+usig1d.*(densm-dens0)+usig1t.*(tfmm-tfmm0);
        usig2=usig20+usig2d.*(densm-dens0)+usig2t.*(tfmm-tfmm0);
        switch upper(NeuModel)
            case 'NEU3'
                [keff,fa1,fa2,pown,r,raa,Sn,C1nm,C2nm]=...
                    solv_neu3(keff,fa1,fa2,qtherm,neig,usig1(:),usig2(:),siga1(:),sigr(:),siga2(:),ny(:),ny(:),d1(:),d2(:),hx,hz,a11,a21,a22,DF1,DF2,2,C1nm,C2nm,Sn);
            case 'NEU1'
                Tol=abs(DdPcore)/1e5;
                Tol=min(Tol,1e-4);
                Tol=max(Tol,1e-8);
                [keff,fa1,fa2,pown]=solv_fi(keff,fa1(:),fa2(:),qtherm,neig,usig1(:),usig2(:),siga1(:),sigr(:),...
                    siga2(:),ny(:),ny(:),d1(:),d2(:),hx,hz,a11,a21,a22,cp,Tol);
        end
        pown=pown/mean(pown);
    end
end