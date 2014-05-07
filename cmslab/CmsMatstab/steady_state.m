function Xsec=steady_state(fue_new,Oper)

%%
global msopt geom termo neu steady

CoreOnly=get_bool(msopt.CoreOnly);
[keff,power,fa1,fa2,tl,alfa,dens,Wg,Wl,flowb,Wbyp,tfm,tcm,tw,Iboil,ploss,dp_wr,dpin,dp_sup,Xsec,XS,X]=power_void(fue_new,Oper);
Tfm=mean(tfm')';
%% Delayed neutrons
if isempty(msopt.DistFile)
    %[al,b]=read_beta_sim3(msopt.LibFile,fue_new,dens/1000,Tfm+273.13,XS,X,geom.knum(:,1));
    alb=xs_pin_lib(msopt.LibFile,fue_new,dens,Tfm+273.13,geom.knum(:,1),XS,1:12);
    al=alb(:,7:12)';
    b=alb(:,1:6)';
else
    [speed,b,al]=delay2mstab7(msopt.DistFile,sym_full(dens*1000));
end
neu.b=b;
neu.betasum=sum(b);
neu.al=al;
%%
dP_core=mean(sum(ploss));
p=Oper.p;
if ~CoreOnly
%% dc1 pressure drop
noll=zeros(geom.nsec(1),1);ett=ones(geom.nsec(1),1);
Wl_dc1=noll;tl_dc1=noll;
Wl_dc1(1)=sum(Wl(geom.kmax,:))+sum(flowb)+Wbyp;Wl_dc1(1)=Wl_dc1(1)*get_sym;
Wl_dc1(2:geom.nsec(1))=termo.Wtot;
tl_dc1(1)=cor_tsat(termo.p);tl_dc1(2:geom.nsec(1))=termo.tlp;
ploss_dc1 = eq_pelev(termo.p*ett,noll,tl_dc1,geom.h_dc1)...
    - eq_pfric(noll,Wl_dc1,termo.p*ett,tl_dc1,geom.a_dc1,geom.dh_dc1,geom.h_dc1,termo.twophasekorr)...
    - eq_prestr(Wl_dc1,noll,termo.p*ett,tl_dc1,geom.a_dc1,geom.vh_dc1); 

%% dc2 pressure drop
noll=zeros(geom.nsec(2),1);ett=ones(geom.nsec(2),1);
Wl_dc2=termo.Wtot;
Wl_dc2=Wl_dc2*ett;
tl_dc2=termo.tlp;
ploss_dc2 = eq_pelev(termo.p*ett,noll,tl_dc2,geom.h_dc2)...
    - eq_pfric(noll,Wl_dc2,termo.p*ett,tl_dc2,geom.a_dc2,geom.dh_dc2,geom.h_dc2,termo.twophasekorr)...
    - eq_prestr(Wl_dc2,noll,termo.p*ett,tl_dc2,geom.a_dc2,geom.vh_dc2); 
tl_dc2=termo.tlp*ett;
%% lp1 pressure drop
noll=zeros(geom.nsec(3),1);ett=ones(geom.nsec(3),1);
Wl_lp1=termo.Wtot;
Wl_lp1=Wl_lp1*ett;
tl_lp1=termo.tlp;
ploss_lp1 = - eq_pfric(noll,Wl_lp1,termo.p*ett,tl_lp1,geom.a_lp1,geom.dh_lp1,geom.h_lp1,termo.twophasekorr)...
    - eq_prestr(Wl_lp1,noll,termo.p*ett,tl_lp1,geom.a_lp1,geom.vh_lp1); 
tl_lp1=tl_lp1*ett;
%% lp2 pressure drop
noll=zeros(geom.nsec(4),1);ett=ones(geom.nsec(4),1);
Wl_lp2=termo.Wtot;
Wl_lp2=Wl_lp2*ett;
tl_lp2=termo.tlp;
ploss_lp2 = -eq_pelev(termo.p*ett,noll,tl_lp2,geom.h_lp2)...
    - eq_pfric(noll,Wl_lp2,termo.p*ett,tl_lp2,geom.a_lp2,geom.dh_lp2,geom.h_lp2,termo.twophasekorr)...
    - eq_prestr(Wl_lp2,noll,termo.p*ett,tl_lp2,geom.a_lp2,geom.vh_lp2); 
tl_lp2=tl_lp2*ett;
%% riser pressure drop
noll=zeros(geom.nsec(6),1);ett=ones(geom.nsec(6),1);
Wg_upl=sum(Wg(geom.kmax,:))*get_sym;Wg_upl=Wg_upl*ett;
Wl_upl=Oper.Wtot-Wg_upl;
tl_upl=tl_dc1(1)*ett;
Wg_sl=Wg_upl(geom.nsec(6));
alfa_upl=mean(alfa(geom.kmax,:));alfa_upl=alfa_upl*ett;
y=eq_alfa_core(alfa_upl,tl_upl,Wg_upl,Wl_upl,termo.p,geom.a_upl);
y_a=eq_alfa_core(alfa_upl+0.01,tl_upl,Wg_upl,Wl_upl,termo.p,geom.a_upl);
dyda=(y_a-y)/.01;alfa_upl=alfa_upl-y./dyda;
slip_upl=1.2;
for i=1:5,
    y=eq_alfa_core(alfa_upl,tl_upl,Wg_upl,Wl_upl,termo.p,geom.a_upl);
    alfa_upl=alfa_upl-y./dyda;
    if norm(y)<1e-4, break; end
end
slip_upl=eq_slip(alfa_upl,termo.p,'bmalnes');
ploss_upl = -eq_pelev(termo.p*ett,alfa_upl,tl_upl,geom.h_upl)...
    - eq_pfric(Wg_upl,Wl_upl,termo.p*ett,tl_upl,geom.a_upl,geom.dh_upl,geom.h_upl,termo.twophasekorr)...
    - eq_prestr(Wl_upl,Wg_upl,termo.p*ett,tl_upl,geom.a_upl,geom.vh_upl); 
%% Feedwater temperature
% A bit rough, should really use full non-linear tables, but in order to keep it within the same
% set of equations and correlations, the ones available in matstab are used
Wl_fw=Wg_sl;
tsat=cor_tsat(p);
tl_fw=(cor_hfg(p)-Oper.Qtot/Wl_fw)/cor_cpl(tsat)+tsat;
%%
phcpump=dP_core-sum(ploss_dc1)-sum(ploss_dc2)-sum(ploss_lp1)-sum(ploss_lp2)-sum(ploss_upl);
NoPump=get_bool(msopt.NoPump);
termo.phcpump=phcpump;

if CoreOnly,
    nhcpump=[];
else
    if NoPump,
        nhcpump=[];
    else
        if termo.per_jet(1)==0,
            nhcpump = eq_npump(Wl_lp1(1),termo.p,tl_lp1(1),phcpump,termo.pump,termo.pk1,termo.pk2);
        else
            rol_dc2=cor_rol(termo.p,tl_lp1(1));
            termo.rol_dc2=rol_dc2;
            termo.Wdr=fzero(@(x) eq_jet(x,termo.Wtot),termo.Wtot/3);
            termo.Krcl=fzero(@(x) eq_jet_precirc(x,termo.Wdr,termo.Wtot),100);
            nhcpump=termo.per_pmp{5};
        end
    end
end
%%
termo.nhcpump=nhcpump;
% Bypass flow dynamic koefficient
Abyp=1.5;
Dhbyp=0.0225;
HzCore=geom.kmax*geom.hz/100;
rol_lp=cor_rol(termo.p,termo.tlp);
f=@(x) eq_prestr(termo.Wbyp,0,termo.p,termo.tlp,1.5,x)+dP_core-rol_lp*HzCore*9.81;
K=fzero(f,300);
termo.K=K;
geom.Abyp=Abyp;
geom.Dhbyp=Dhbyp;
end

termo.Wbyp=Wbyp*get_sym;

P=p*ones(size(alfa));
steady.P=P;
termo.P=P;

steady.Wl=Wl;
steady.Wbyp=Wbyp*get_sym;
steady.flowb=flowb;
steady.tl=tl;
steady.keff=keff;
steady.Ppower=sym_full(power,geom.knum);
steady.Pvoid=sym_full(alfa,geom.knum);
steady.Pdens=sym_full(dens,geom.knum);
steady.power=power;
steady.alfa=alfa;
steady.dens=dens;
steady.Tfm=Tfm;
steady.fa1=fa1;
steady.fa2=fa2;
steady.tfm=tfm;
steady.tcm=tcm;
steady.tw=tw;
steady.Iboil=Iboil;
steady.Wg=Wg;
steady.dP_core=dP_core;
steady.ploss=ploss;
steady.dpin=dpin;
steady.dp_wr=dp_wr;
if ~CoreOnly
steady.dp_sup=dp_sup;
steady.ploss_dc1=ploss_dc1;
steady.ploss_dc2=ploss_dc2;
steady.ploss_lp1=ploss_lp1;
steady.ploss_lp2=ploss_lp2;
steady.ploss_upl=ploss_upl;
steady.slip_upl=slip_upl;
steady.tl_dc1=tl_dc1;
steady.Wl_dc1=Wl_dc1;
steady.Wl_fw=Wl_fw;
steady.tl_fw=tl_fw;
steady.tl_dc2=tl_dc2;
steady.Wl_dc2=Wl_dc2;
steady.tl_lp1=tl_lp1;
steady.Wl_lp1=Wl_lp1;
steady.tl_lp2=tl_lp2;
steady.Wl_lp2=Wl_lp2;
steady.alfa_upl=alfa_upl;
steady.tl_upl=tl_upl;
steady.Wg_upl=Wg_upl;
steady.Wl_upl=Wl_upl;
steady.Wg_sl=Wg_sl;
end


save(msopt.MstabFile,'msopt','geom','steady','termo','neu','fue_new','Oper','Xsec','XS','X')  
