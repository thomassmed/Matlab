function [P_c,gammav_c,tl_c]=lin_P(P,gammav,tl,alfa,V)
%lin_P
%
%[P_c,gammav_c,tl_c]=lin_P(P,gammav,tl,alfa,V)
%
%Linearization of system pressure (A.108)

%@(#)   lin_P.m 2.5   02/02/27     12:11:00

global geom termo
global DRog_DP DRol_DP DRol_Dtl

nfw=geom.nfw;

Rol = cor_rol(P,tl);
Tsat = cor_tsat(P);
Rog = cor_rog(Tsat);

%Get the core nodes
k = get_corenodes;
m = get_bnodes;
n = get_chnodes;
c = get_sym;
kk = get_realnodes;

alfa(1) = 1;
 
V(k) = V(k)*c;
z=find(alfa<=0);
den = sum((DRog_DP.*alfa./Rog + DRol_DP.*(1-alfa)./Rol).*V.*kk);

%P - system pressure
Wsl= sum(kk.*gammav.*V.*(Rol-Rog)./(Rol.*Rog))./...
   ((Rol(nfw)-Rog(1))/(Rol(nfw)*Rog(1))); Wfw=Wsl; %First find the steam mass flow
P_c = (eq_DPDt(gammav,tl,P*1.01,alfa,Wfw,Wsl,V)-eq_DPDt(gammav,tl,P,alfa,Wfw,Wsl,V))/(P(1)*1.01-P(1));

%gamma_v
gammav_c = zeros(get_thsize,1);
num = (Rol-Rog)./Rol./Rog.*V.*kk.*(gammav>0);
num(n) = num(n);
num(z) = num(z)*0;
index = [n get_risernodes];
gammav_c(index) = num(index)/den;


%tl
num = (1./(Rol.^2).*DRol_Dtl.*gammav.*V);
tl_c = num/den;
tl_c = tl_c.*kk.*(alfa>0);
