function p=eq_prestr(Wl,Wg,P,tl,A,vhk)
%p=eq_prestr
%
%p=eq_prestr(Wl,Wg,P,tl,A,vhk)
%Beräknar engångstryckfall för
%den slutna kretsen genom kanalerna. 
%k är tryckfallskoefficienten i ekvationen
%
%               2
%      1       G       2        2        Rol
% dp = - vhk ------ phi    , phi = 1 + x(--- - 1), x är flow quality
%      2      Rol                        Rog

%@(#)   eq_prestr.m 2.1   96/08/21     07:56:47

Rol = cor_rol(P,tl);
Rog = cor_rog(cor_tsat(P));

Gm = (Wl+Wg)./A;

x = Wg./(Wl + Wg);

p = -vhk.*(Gm.^2).*(1 + x.*(Rol./Rog-1))./Rol/2;
