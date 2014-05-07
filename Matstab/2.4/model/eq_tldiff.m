function y = eq_tldiff(alfa,P,tl,romum,Tsat0);
%
% y = eq_tldiff(alfa,P,tl,romum,Tsat0)
%
% INDATA : Void,systemtryck,vattentemperatur,interna energi densiteten
%          samt startvärdet på mättnadstemperaturen.
%
% UTDATA : differensen för  4.4.80 och vattentemperaturen;
%
% Ekvation 4.4.80

%@(#)   eq_tldiff.m 2.1   96/08/21     07:56:51

tsat = cor_tsat(P);
rog = cor_rog(tsat);
ug = cor_ug(P,tl,Tsat0);
rol = cor_rol(P,tl);
cpl = cor_cpl(tsat);

%eq. 4.4.79 and 4.4.77 are used to get an implicit formulation for tl.
%fin_diff gives the results for this new eq. including an tl_c which
%has not to be -1.
%the results are checkt against the explicit formulation 4.4.80

y = (romum-alfa.*rog.*ug)./(1-alfa)./rol./cpl + Tsat0 - tl;
