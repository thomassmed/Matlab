function ts=cor_tsat(P);
%ts=cor_tsat(P);
%saturation temperature
%in RAMONA
%eq. 4.4.69

%@(#)   cor_tsat.m 2.1   96/08/21     07:56:27

lp=length(P);
P=P(1);
a=[-3.84576467e2
0.570716464
1.04091792e-4
1.02949324e-9
8.52096126e-16
5.56170847e-23];
b=[1.99967470e1
2.09487630e-2
1.30393669e-6
6.75716812e-12
3.17424682e-18
1e-25];
P=[1 P P^2 P^3 P^4 P^5];
ts=ones(lp,1)*(P*a)./(P*b);


