function [gammav_c,P_c,tl_c] = lin_volexp(gammav,P,tl,A,Hz);
%lin_volexp
%
%[gammav_c,P_c,tl_c] = lin_volexp(gammav,P,tl,A,Hz)
%Linjäriserar eq_volexp

%@(#)   lin_volexp.m 2.2   01/09/23     16:10:00

if 0
  [gammav_c,P_c,tl_c] = fin_diff('eq_volexp',gammav,P,tl,A,Hz);
else

  global DRol_Dtl DRol_DP DRog_DP

  tsat = cor_tsat(P);
  Rog = cor_rog(tsat);
  Rol = cor_rol(P,tl);

  x=(Rol-Rog)./Rol./Rog;

  gammav_c=A.*Hz.*x.*(gammav~=0);
  tl_c=A.*Hz.*gammav.*(DRol_Dtl./Rol./Rog-x./Rol.*DRol_Dtl);
  P_c=A.*Hz.*gammav.*(DRol_DP-DRog_DP-x.*(DRol_DP.*Rog+DRog_DP.*Rol)./Rol./Rog);
end


  P_c = zeros(get_thsize,1); %Trycktermen tas bort enligt verifiering 95-09-05 Påk
