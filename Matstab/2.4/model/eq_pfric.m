function p=eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,korrtype);
%p=eq_pfric
%
%p=eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,korrtype)
%Beräknar friktionstryckfallen för alla noder

%@(#)   eq_pfric.m 2.1   96/08/21     07:56:44

Wl(1)=Wl(2);
fl = eq_fl(Wl,Wg,Dh,P,A);
phi2 = eq_phi2(Wg,Wl,P,tl,A,korrtype);
Rol = cor_rol(P,tl);

Gm2 = ((Wl + Wg)./A).^2;

p = Hz.*fl.*phi2.*Gm2./Rol./Dh/2;
