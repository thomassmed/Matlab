function y=eq_alfa_core(alfa,tl,Wg,Wl,p,A,S)
tsat=cor_tsat(p);
rog=cor_rog(tsat);
if nargin<7,
    S=eq_slip(alfa,p,'bmalnes');
end
jm=eq_jm(Wl,Wg,p,tl,A);
wg=eq_vg(S,jm,alfa);
y=alfa.*wg-Wg./A./rog;