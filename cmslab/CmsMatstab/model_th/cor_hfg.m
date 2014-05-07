function x=cor_hfg(P)
%x=cor_hfg(P)
%Ångbildningsentalpi, [Ws/kg]

%@(#)   cor_hfg.m 2.1   96/08/21     07:56:22

lp = length(P);
tsat=cor_tsat(P(:));
tsat=tsat(1);
a=[4.77535376e6
5.61714074e3
-1.16595582e2
1.80674174e-1];
b=[1.90919998
4.10909278e-3
-4.46664907e-5
5.43248060e-8
1.62749641e-12];
tsat1=[1 tsat tsat^2 tsat^3];
tsat2=[1 tsat tsat^2 tsat^3 tsat^4];
x=ones(size(P))*(tsat1*a)/(tsat2*b);
