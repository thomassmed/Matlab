function p=eq_pelev(P,alfa,tl,Hz)
%p=eq_pelev
%
%p=eq_pelev(P,alfa,tl,Hz)
%Calculates elevation pressure drop for all nodes


Tsat = cor_tsat(P);
Rol = cor_rol(P,tl);
Rog = cor_rog(Tsat);
Rom = alfa.*Rog + (1-alfa).*Rol;

p = 9.81*Rom.*Hz;
