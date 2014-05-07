function y = eq_gamph(alfa,P,tl);
%
% y = eq_gamph(alfa,P,tl)
%
% INDATA : Void,systemtryck,vattentemperatur.
%
% UTDATA : Ånggenerering eller kondensering beroende på vattentemperaturen.

% Ekvation 4.4.57

%@(#)   eq_gamph.m 2.2   02/02/27     12:05:23

global termo
C11 = termo.cpb(1);
C12 = termo.cpb(2);
C13 = termo.cpb(3);

tsat = cor_tsat(P);
hfg = cor_hfg(P);

y = (C11 + C12*alfa.*(1-alfa)).*((tl-tsat) + C13*abs(tl-tsat))./hfg;
