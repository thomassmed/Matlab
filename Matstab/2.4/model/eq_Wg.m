function y = eq_Wg(P,wg,alfa,A);
%
% y = eq_Wg(P,wg,alfa,A)
%
% INDATA : systemtryck,�ngvolymfl�det,void samt area.
%
% UTDATA : �ngmassfl�det.

% Ekvation 6.4.24

%@(#)   eq_Wg.m 2.1   96/08/21     07:56:35

rog = cor_rog(cor_tsat(P));
y = A.*rog.*wg.*alfa;


