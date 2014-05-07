function y=eq_alfa(alfa,jm,Wg,Wl,p,A,rog)
S=eq_slip(alfa,p,'bmalnes');
wg=eq_vg(S,jm,alfa);
y=alfa.*wg-Wg./A./rog;