function y = eq_DPDt(gammav,tl,P,alfa,Wfw,Wsl,V);
%
% y = eq_DPDt(gammav,tl,P,alfa,Wfw,Wsl,V)
%
%  Calculates the time derivative of the system pressure as a function of 
%  steam generation, system pressure, water temp. void, mass flow of feed water,
%  steam flow and volume
%
%  Equation 4.4.94

kk = get_realnodes;

global DRog_DP DRol_DP 

global geom
nfw=geom.nfw;

tsat = cor_tsat(P);
rol = cor_rol(P,tl);
rog = cor_rog(tsat);

den = sum((DRog_DP.*alfa./rog + DRol_DP.*(1-alfa)./rol).*V.*kk);
y = (Wfw/rol(nfw) - Wsl/rog(1) + sum(kk.*(rol-rog).*gammav.*V./rol./rog))/den;
