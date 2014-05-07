function x=cor_cpl(ts)
%x=cor_cpl(tsat)
%Specific heat for saturated liquid
%4.4.73

%@(#)   cor_cpl.m 2.1   96/08/21     07:56:21

ls = length(ts);
ts=ts(1);
a=[9.34851589e3
3.37797785e1
-3.18540182e-1
4.71558612e-4
-9.93425202e-8];
b=[2.21949939
8.92447927e-3
-8.63821184e-5
1.24688842e-7];

tsat1=[1 ts ts^2 ts^3 ts^4];
tsat2=[1 ts ts^2 ts^3];
x=ones(ls,1)*(tsat1*a)/(tsat2*b);
