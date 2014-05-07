function x=eq_tl0(romum,P,alfa)
%eq_tl0
%
%x=eq_tl0(romum,P,alfa)
%Calulates tl as a function of the energy

%@(#)   eq_tl0.m 2.3   96/11/21     14:52:41

tsat=cor_tsat(P);
cpl=cor_cpl(tsat);
ug=cor_ug(P,tsat,tsat);
rog=cor_rog(tsat);
 
a=[1 P(1) P(1)^2]*[-0.8071;-0.1774e-6;0.5289e-14];
a = a*ones(get_thsize,1);
b = cor_rof(tsat)/2;
c = -(romum-ug.*alfa.*rog)./(cpl.*(1-alfa));
 
x = tsat + (sqrt(b.^2-a.*c)-b)./a;
x = real(x); %x can in some cases become slightly complex 
