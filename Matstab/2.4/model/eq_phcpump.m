function [phcpump,pk,ptype]=eq_phcpump(Wd,P,tl,n,pump,pk1,pk2)
% eq_phcpump
%
% [phcpump,pk,ptype]=eq_phcpump(Wd,P,tl,n,pump,pk1,pk2)
% calculates pressure drop over hcpump for given pumpspeed
%
% Wl: Massflow through pumps [kg/s]
% P: Pressure in the pump
% tl: Water temp.
% n: pump speed
% pump: Pump data def. in get_pumpdata
% pk1, pk2: Pump char. ptype 1 and 2

%@(#)   eq_phcpump.m 2.1   96/08/21     07:56:42

rol = cor_rol(P,tl);
Q = Wd/rol;

global termo
termo.pspeedq=[Q rol n];

phcpump = fzero('eq_phcdrop',1.3e6,optimset('disp','off'));


