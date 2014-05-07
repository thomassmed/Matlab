function [r,x]=cor_rol(P,tl)
%[r x]=cor_rol(P,tl)
%densitet för vatten

%@(#)   cor_rol.m 2.1   96/08/21     07:56:26

lp = length(P);
P=P(1);
a=[-0.8071
-0.1774e-6
0.5289e-14];
p1=[1 P P^2];
x=(p1*a);
ts=cor_tsat(P);
r=cor_rof(ts)+x*(tl-ts);
