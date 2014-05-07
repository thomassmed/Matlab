function [ploss,dP,dpin,prestr,pfric,pelev,pexp]=eq_dP_core(alfa,tl,Wg,Wl,flowb,P,A,hz,vhk,Xcin,Dh,tlp,twophasekorr,amdt,bmdt)
Hz=ones(size(alfa))*hz/100;
if isstruct(vhk),
    fue_new=vhk;
    [vhspx,rhspx,zsp,ispac]=get_spacer4matstab(fue_new);
    Dh=fue_new.dhfuel;
    vhk=set_pkoeff(fue_new.vhifuel,vhspx'/2,rhspx',zsp,ispac,Wl,Wg,Dh,P,A,Hz);
    amdt=fue_new.amdt;
    bmdt=fue_new.bmdt;
end
if ~exist('twophasekorr','var'), twophasekorr='mnelson'; end
jm=eq_jm(Wl,Wg,P,tl,A);
S=eq_slip(alfa,P(1),'bmalnes');
wg=eq_vg(S,jm,alfa);
wl = Wl./A./cor_rol(P,tl)./(1-alfa);
pexp=eq_pacc(Wl,Wg,wl,wg,A);
pelev=eq_pelev(P,alfa,tl,Hz);
pfric=eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,twophasekorr,amdt,bmdt);
prestr=eq_prestr(Wl,Wg,P,tl,A,vhk);
ploss=pexp+pelev+pfric+prestr;
p=P(1,1);
dpin=eq_prestr(Wl(1,:)+flowb,0*Wg(1,:),p,tlp,A(1,:),Xcin);
ploss(1,:)=ploss(1,:)+dpin;
dP=sum(ploss);