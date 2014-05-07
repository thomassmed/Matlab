function p=eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,korrtype,amdt,bmdt)
%p=eq_pfric
%
%p=eq_pfric(Wg,Wl,P,tl,A,Dh,Hz,korrtype)
%Beräknar friktionstryckfallen för alla noder

%@(#)   eq_pfric.m 2.1   96/08/21     07:56:44

amdflag=true;
if nargin<9, 
    amdflag=false;
elseif isempty(amdt),
    amdflag=false;
end

if amdflag, 
    fl = eq_fl(Wl,Wg,Dh,P,A,amdt,bmdt);
else
    fl = eq_fl(Wl,Wg,Dh,P,A); 
end
phi2 = eq_phi2(Wg,Wl,P,tl,A,korrtype);
Rol = cor_rol(P,tl);

Gm2 = ((Wl + Wg)./A).^2;

p = Hz.*fl.*phi2.*Gm2./Rol./Dh/2;
