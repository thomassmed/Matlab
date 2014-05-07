function r=cor_rog(tsat);
%r=cor_rog(tsat);
%saturation temperature
%in RAMONA

%@(#)   cor_rog.m 2.3   97/08/18     10:36:52

ls = size(tsat);
tsat=tsat(1);
a=[8.86026769e-4
5.57796447e-5
1.86320039e-6
1.17529683e-8
4.44786646e-10
-1.07762569e-12];
b=[1.82518113e-1
-7.49696090e-4
1.12657020e-6
-9.93469591e-10];
tsat1=[1 tsat tsat^2 tsat^3 tsat^4 tsat^5];
tsat2=[1 tsat tsat^2 tsat^3];
r=ones(ls(1),ls(2))*(tsat1*a)/(tsat2*b);
