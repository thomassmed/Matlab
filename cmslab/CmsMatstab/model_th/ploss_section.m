function [a_c,t_c,Wg_c,Wl_c,P_c]=ploss_section(alfa,tl,Wg,Wl,P,vhk,Dh,Hz,A)
l_sec=length(alfa);
[ploss_a,ploss_t,ploss_Wg,ploss_Wl,ploss_P]=fin_diff(@eq_ploss_1,alfa,tl,Wg,Wl,P,vhk,Dh,Hz,A);
%% Acceleration losses
[pacc_a,pacc_t,pacc_Wg,pacc_Wl,pacc_P]=fin_diff(@eq_paccD,alfa,tl,Wg,Wl,P,A);
% alfa
a_c=ploss_a;
a_c(1)=ploss_a(1)+pacc_a(1);
a_c(l_sec)=ploss_a(l_sec)-pacc_a(l_sec);
% tl
t_c=ploss_t;
t_c(1)=ploss_t(1)+pacc_t(1);
t_c(l_sec)=ploss_t(l_sec)-pacc_t(l_sec);
% Wg
Wg_c=ploss_Wg;
Wg_c(1)=ploss_Wg(1)+pacc_Wg(1);
Wg_c(l_sec)=ploss_Wg(l_sec)-pacc_Wg(l_sec);
% Wl
Wl_c=ploss_Wl;
Wl_c(1)=ploss_Wl(1)+pacc_Wl(1);
Wl_c(l_sec)=ploss_Wl(l_sec)-pacc_Wl(l_sec);
% Pressure
P_c=ploss_P;
P_c(1)=ploss_P(1)+pacc_P(1);
P_c(l_sec)=ploss_P(l_sec)-pacc_P(l_sec);