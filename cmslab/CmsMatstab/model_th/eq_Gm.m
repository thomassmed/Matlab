function Gm=eq_Gm(alfa,tl,Wg,Wl,P,A,Hz)

Rol = cor_rol(P,tl);
Rog = cor_rog(cor_tsat(P));

jm = eq_jm(Wl,Wg,P,tl,A);
S=eq_slip(alfa,P,'bmalnes');
wg = eq_vg(S,jm,alfa);
wl = eq_vl(S,jm,alfa);

Gm = alfa.*Rog.*wg + (1 - alfa).*Rol.*wl;                        % eq. 4.4.97

Gm=Gm.*Hz;