function y = eq_DPDt(gammav,tl,P,alfa,DRog_DP,DRol_DP,rol_fw,V)
%
% y = eq_DPDt(gammav,tl,P,alfa,Wfw,Wsl,V)
%
%  Calculates the time derivative of the system pressure as a function of 
%  steam generation, system pressure, water temp. void, mass flow of feed water,
%  steam flow and volume
%
%  Equation 4.4.94

global steady geom

Wl_fw=steady.Wl_fw;
Wg_sl=steady.Wg_sl;
p=P(1);
tsat=cor_tsat(p);
rog=cor_rog(tsat);

Tsat = cor_tsat(P);
Rol = cor_rol(P,tl);
Rog = cor_rog(Tsat);

V = V*get_sym;



den_core = sum(sum((DRog_DP.*alfa./Rog + DRol_DP.*(1-alfa)./Rol).*V));
%% dc1
drol_dp=fin_diff(@cor_rol,p,steady.tl_dc1);
den_dc1=sum(drol_dp./cor_rol(p,steady.tl_dc1).*geom.a_dc1.*geom.h_dc1);
%% dc2
drol_dp=fin_diff(@cor_rol,p,steady.tl_dc2);
den_dc2=sum(drol_dp./cor_rol(p,steady.tl_dc2).*geom.a_dc2.*geom.h_dc2);
%% lp1
drol_dp=fin_diff(@cor_rol,p,steady.tl_lp1);
den_lp1=sum(drol_dp./cor_rol(p,steady.tl_lp1).*geom.a_lp1.*geom.h_lp1);
%% lp2
drol_dp=fin_diff(@cor_rol,p,steady.tl_lp2);
den_lp2=sum(drol_dp./cor_rol(p,steady.tl_lp2).*geom.a_lp2.*geom.h_lp2);
%% riser or upper plenum
drol_dp=fin_diff(@cor_rol,p,steady.tl_upl);
alfa_u=steady.alfa_upl;
den_l_upl=sum(drol_dp.*(1-alfa_u)./cor_rol(p,steady.tl_upl).*geom.a_upl.*geom.h_upl);
drog_dp=(cor_rog(cor_tsat(p+1000))-cor_rog(cor_tsat(p)))/1000;
den_g_upl=sum(drog_dp*alfa_u/rog.*geom.a_upl.*geom.h_upl);
%% Steam dome
den_sd=drog_dp/rog*sum(geom.v_sd);
%% Sum it up
den= den_core + den_dc1 + den_dc2 + den_lp1 + den_lp2 + den_l_upl + den_g_upl + den_sd;

y = (Wl_fw/rol_fw - Wg_sl/rog + sum(sum((Rol-Rog).*gammav.*V./Rol./Rog)))/den;
