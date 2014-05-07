function lrsr=eq_lrsr(alfa,tl,Wl,Wg,P,A,Hz)

global geom termo

nsep=geom.nsep;
rleff0=termo.rleff0;

l=length(alfa);

Rol = cor_rol(P,tl);
Rog = cor_rog(cor_tsat(P));

jm = eq_jm(Wl,Wg,P,tl,A);
S=eq_slip(alfa,P,'bmalnes');
wg = eq_vg(S,jm,alfa);
wl = eq_vl(S,jm,alfa);

Gm = alfa.*Rog.*wg + (1 - alfa).*Rol.*wl;                        % eq. 4.4.97

Gg = alfa.*Rog.*wg;

x=Gg(l)/Gm(l);

hrsr = sum(Hz); %Height of separator
lrsr = A(l)/hrsr/nsep*(1-x)*(rleff0 + 118*(11.5 + 55.6*x)*x);    % eq. 4.4.156

