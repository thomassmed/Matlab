function x=cor_kl(tsat)
%x=cor_kl(tsat)
%konduktivitet för vatten
% eq. 4.4.83

%@(#)   cor_kl.m 2.1   96/08/21     07:56:24

ls = length(tsat);
tsat=tsat(1);
a=[6.09937e-1
-2.0561149e-3
-9.675658e-6
3.94689e-8
-3.170096e-11];
b=[1
-5.38878e-3
3.6415529e-6
5.99807e-9];

tsat1=[1 tsat tsat^2 tsat^3 tsat^4];
tsat2=[1 tsat tsat^2 tsat^3];
x=ones(ls,1)*(tsat1*a)/(tsat2*b);
