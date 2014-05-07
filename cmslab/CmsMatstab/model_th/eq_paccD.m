function p=eq_paccD(alfa,tl,Wg,Wl,P,A)
%p=eq_paccD
%
%p=eq_paccD(Wl,Wg,wg,P,tl,alfa,A)
%Used by lin_ploss to calulate the finite difference
%for the acceleration pressure drops

%@(#)   eq_paccD.m 2.2   02/02/27     11:49:22

jm=eq_jm(Wl,Wg,P,tl,A);
S=eq_slip(alfa,P(1),'bmalnes');
wg=eq_vg(S,jm,alfa);
wl = Wl./A./cor_rol(P,tl)./(1-alfa);
p = (Wl.*wl + Wg.*wg)./A;

