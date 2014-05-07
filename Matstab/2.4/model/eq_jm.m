function y = eq_jm(Wl,Wg,P,tl,A);
%
% y = eq_jm(Wl,Wg,P,tl,A);
%
% INDATA : Vattenmassflödet,ångans axiella hastighet,systemtrycket
%          vattentemperaturen samt arean.
%
% UTDATA : Volymfluxen.
%
% Ekvation 6.4.24, 4.4.10

%@(#)   eq_jm.m 2.1   96/08/21     07:56:41

rol = cor_rol(P,tl);
rog = cor_rog(cor_tsat(P));

y = (Wl./rol + Wg./rog)./A;
