function x=cor_myl(tsat)
%x=cor_myl(tsat)
%dynamisk viskositet för vatten
%eq. 4.4.85

%@(#)   cor_myl.m 2.1   96/08/21     07:56:24

[iT,jT] = size(tsat);
tsat=tsat(1);
a=[-7.37828137e-5
6.51521474e-7
-1.77519264e-9
1.19957482e-11
-1.44047622e-14];
b=[-4.0980976e-2
-1.03565416e-3
9.45025134e-7
7.94131516e-8];

tsat1=[1 tsat tsat^2 tsat^3 tsat^4];
tsat2=[1 tsat tsat^2 tsat^3];
x=ones(iT,jT)*(tsat1*a)/(tsat2*b);
