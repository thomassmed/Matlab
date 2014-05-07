function [alfa,tl,Wg,Wl,tw,ploss,dporif,prestr,pfric,pelev,pexp]=void_only(fue_new,Oper,power,chflow,flowb)
%%
global msopt neu termo geom
%%
neu.delta=0.04;
neu.deltam=0.02;

if nargin<3,
    power=Oper.Power;
end
fue_new=expand_fuenew(fue_new);
fue_new.afuel=fue_new.afuel/1e4;        % Convert to m^2
fue_new.dhfuel=fue_new.dhfuel/1e2;      % Convert to m
fue_new.phfuel=fue_new.phfuel/1e2;      % Convert to m
for i=1:length(fue_new.A_wr),
    fue_new.A_wr{i}=fue_new.A_wr{i}/1e4;
    fue_new.Ph_wr{i}=fue_new.Ph_wr{i}/1e2;
    fue_new.Dhy_wr{i}=fue_new.Dhy_wr{i}/1e2;
end
msopt.CoreSym=1;
geom.ncc=fue_new.kan;
geom.kmax=fue_new.kmax;
geom.hx=fue_new.hx;
geom.hz=fue_new.hz;
geom.knum=(1:fue_new.kan)';
geom.nsec=[3;5;2;2;geom.kmax;4];
termo.Qtot=Oper.Qtot;
termo.p=Oper.p;
termo.htc=2000;
termo.tlp=Oper.tlp;
cssgl=[1.9   0.25   0.90   0.147]; % 'Default' from RAMONA
termo.css=cssgl;
knum=geom.knum;
vhifuel=fue_new.vhifuel(:,knum(:,1))';
vhofuel=fue_new.vhofuel(:,knum(:,1))';
Xcin=fue_new.Xcin(knum(:,1));
knum1=knum(:,1);
[vhspx,rhspx,zspx,ispac]=get_spacer4matstab(fue_new);
vhspx=vhspx(knum1,:);
rhspx=rhspx(knum1,:);
termo.avhspx=vhspx'/2;
termo.arhspx=rhspx';
termo.zsp=zspx;
termo.ispac=ispac;
if length(Oper.wlt_ctp)==1,
    termo.Wbyp_frac=interp1(Oper.wlt_cwt,Oper.wlt_bypass_frac,Oper.Wrel,'linear','extrap');
else
    termo.Wbyp_frac=interp2(Oper.wlt_cwt,Oper.wlt_ctp,Oper.wlt_bypass_frac,Oper.Wrel,Oper.Qrel);
end
if isnan(termo.Wbyp_frac), termo.Wbyp_frac=0.1;end
termo.Wtot=Oper.Wtot;
termo.twophasekorr='mnelson';
termo.slipkorr='bmalnes';
termo.Wbyp=termo.Wbyp_frac*termo.Wtot;
if nargin<4,
    chflow=Oper.Wtot/fue_new.kan*ones(1,fue_new.kan/get_sym(msopt));
end
if nargin<5,
    flowb=0.01*chflow;
end
%% set up reasonable initial conditions
[alfa,tl,Wg,Wl]=syst_f_ini(fue_new,power,chflow,flowb);
%% Wl(1,:)=chflow;
msopt.bwrdlp='off';
[conv,alfa,tl,Wg,Wl,tw,ploss,dporif,prestr,pfric,pelev,pexp]=syst_f4(fue_new,power,flowb,alfa,tl,Wg,Wl,0.1);
disp('2nd call');
[conv,alfa,tl,Wg,Wl,tw,ploss,dporif,prestr,pfric,pelev,pexp]=syst_f4(fue_new,power,flowb,alfa,tl,Wg,Wl,0.000000001);
