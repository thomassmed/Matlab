function y = eq_gamw(qprimw,P,tl,tw,A);
% y = eq_gamw(qprimw,P,tl,tw,A)
%
% INDATA : Endimensionella värmetillskottet,arean,systemtrycket,vatten-
%	   temperaturen samt bränslets väggtemperatur.
%
% UTDATA : Ånggenereringshastigheten pga bränsleväggstemperaturen.
%
% Ekvation 4.4.56

%@(#)   eq_gamw.m 2.1   96/08/21     07:56:40

tsat = cor_tsat(P);
hfg = cor_hfg(P);
cpl = cor_cpl(tsat);

rol = cor_rol(P,tl);
rog = cor_rog(tsat);

%Fel i ekv 4.4.56 
y = qprimw./A./(hfg+cpl.*((tsat-tl).*rol./rog + 0.5*(tw-tsat).*(rol./rog - 1)));

