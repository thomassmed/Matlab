function p=eq_paccD(Wl,Wg,wg,P,tl,alfa,A)
%p=eq_paccD
%
%p=eq_paccD(Wl,Wg,wg,P,tl,alfa,A)
%Used by lin_ploss to calulate the finite difference
%for the acceleration pressure drops

%@(#)   eq_paccD.m 2.2   02/02/27     11:49:22


wl = Wl./A./cor_rol(P,tl)./(1-alfa);
p = (Wl.*wl + Wg.*wg)./A;

