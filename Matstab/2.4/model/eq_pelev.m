function p=eq_pelev(P,alfa,tl,Hz,dc2corr);
%p=eq_pelev
%
%p=eq_pelev(P,alfa,tl,Hz,dc2corr)
%Calculates elevation pressure drop for all nodes


gz = set_gz;
j1 = get_dc2nodes;
gz(j1) = gz(j1)*dc2corr;
Tsat = cor_tsat(P);
Rol = cor_rol(P,tl);
Rog = cor_rog(Tsat);
Rom = alfa.*Rog + (1-alfa).*Rol;

p = gz.*Rom.*Hz;
