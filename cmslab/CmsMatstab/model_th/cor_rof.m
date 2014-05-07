function r=cor_rof(tsat);
%r=cor_rof(tsat);
%Beräknar densiteten längs  mättnadslinjen
%i RAMONA

%@(#)   cor_rof.m 2.1   96/08/21     07:56:25

ls = length(tsat);
tsat=tsat(1);
a=[2.57204355
3.42510110e-3
-6.20322340e-5
9.27165324e-8];
b=[2.57224487e-3
3.36388317e-6
-4.53522220e-8
3.03855554e-11
5.06034191e-14];
tsat1=[1 tsat tsat^2 tsat^3];
tsat2=[1 tsat tsat^2 tsat^3 tsat^4];
r=ones(ls,1)*(tsat1*a)/(tsat2*b);
