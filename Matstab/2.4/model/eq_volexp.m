function y = eq_volexp(gammav,P,tl,A,Hz);
%
%  y = eq_volexp(gammav,P,tl,A,Hz)
%
% INDATA : Totala ånggenereringshastigheten,void,systemtryck,vattentemperatur
%          matarvattenmassflöde,ångmassflöde ut från reaktorn samt volymen.
%
% UTDATA : Volymexpansionshastigheten
%
% Ekvation 4.4.115,4.4.117,4.4.119

%@(#)   eq_volexp.m 2.1   96/08/21     07:56:52

tsat = cor_tsat(P);
rog = cor_rog(tsat);
rol = cor_rol(P,tl);

y = A.*Hz.*((rol-rog).*gammav./rol./rog);
