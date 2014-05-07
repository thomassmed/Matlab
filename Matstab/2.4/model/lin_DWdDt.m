function [Wl_c,Wd_c,phcpump_c]=lin_DWdDt(Wl,P,tl,pump)
%[Wl_c,Wd_c,phcpump_c]=lin_DWdDt(Wl,P,tl,pump)
% 
% Linearization of the pump dynamics
% Wl, P, tl are thermo hydraulic vectors
% pump: Pump data 

global geom
nin=geom.nin;

j = nin(3)+1;

Wl =Wl(j);P = P(j);tl = tl(j);

rol = cor_rol(P,tl);

ijpump=pump(16);
idrl=pump(17);
anoz=pump(18);
asct=pump(19);
rkdr=pump(21);
rksct=pump(22);
rlad=pump(24);
wdr=pump(25);


a=rkdr/idrl^2+1/2/rol/anoz^2/ijpump^2;
b=(rksct+1/2/rol/asct^2)/ijpump^2;

phcpump_c=idrl/rlad;
Wl_c=-2*(Wl-wdr)*b*idrl/rlad;
Wd_c=(2*(Wl-wdr)*b-2*wdr*a)*idrl/rlad;



