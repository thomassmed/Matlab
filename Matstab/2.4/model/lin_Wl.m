function [P_c,jm_c,alfa_c,S_c,tl_c]=lin_Wl(P,jm,alfa,S,tl,A,Wl)
%lin_Wl
%
%[P_c,jm_c,alfa_c,S_c,tl_c]=lin_Wl(P,jm,alfa,S,tl,A,Wl)
%Linjäriserar eq_Wl

%@(#)   lin_Wl.m 2.6   02/02/27     12:11:15

global DRol_DP DRol_Dtl
global termo

c15=termo.css(:,4);

if 0,
  [P_c,jm_c,alfa_c,S_c,tl_c] = fin_diff('eq_Wl',P,jm,alfa,S,tl,A);
else
  Rol=cor_rol(P,tl);
  den=1+alfa.*(S-1);
  P_c=Wl./Rol.*DRol_DP;
  jm_c=A.*(1-alfa).*Rol./den;
  alfa_c=(-A.*Rol.*c15-Rol.*jm.*A+2*A.*Rol.*c15.*alfa-Wl.*(S-1))./den;
  S_c=-Wl./den.*alfa;
  tl_c=Wl./Rol.*DRol_Dtl;
end

c = get_realnodes;
c(1) = 0;
P_c = P_c.*c;
alfa_c = alfa_c.*c.*(alfa>0);
S_c = S_c.*c.*(alfa>0);
tl_c = tl_c.*c;

