function y = eq_romum(alfa,P,tl,Tsat0);
%
% y = eq_romum(alfa,P,tl,Tsat0)
%
% INDATA : Void,systemtryck,vattentemperatur,startvärde på mättnadstemperaturen.
%
% UTDATA : Interna energidensiteten.
%
% Ekvation 4.4.79

%@(#)   eq_romum.m 2.1   96/08/21     07:56:49

tsat = cor_tsat(P);
rog = cor_rog(tsat);
ug = cor_ug(P,tl,Tsat0);
rol = cor_rol(P,tl);
ul = cor_ul(P,tl,Tsat0);

y = alfa.*rog.*ug + (1-alfa).*rol.*ul;
