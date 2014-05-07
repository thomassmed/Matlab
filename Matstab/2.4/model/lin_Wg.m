function [P_c,wg_c,alfa_c]=lin_Wg(P,wg,alfa,A)
%lin_Wg
%
%[P_c,wg_c,alfa_c]=lin_Wg(P,wg,alfa,A)
%Beäknar koefficienterna för den linjäriserade 
%ångmass-balansekvationen EKV. 6.4.24

%@(#)   lin_Wg.m 2.2   01/09/23     16:10:02

global DRog_DP

Rog = cor_rog(cor_tsat(P));

c = get_realnodes;
c(1) = 0;

%alfa
alfa_c = A.*Rog.*wg.*(alfa>0).*c;

%wg
wg_c = A.*Rog.*alfa.*(wg>0).*c;

%P
P_c = A.*wg.*alfa*DRog_DP.*c;
