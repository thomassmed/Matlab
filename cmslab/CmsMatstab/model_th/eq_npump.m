function n=eq_npump(Wl,P,tl,ppump,pump,pk1,pk2)
% n=eq_npump(Wl,P,tl,ppump,pump,pk1,pk2)
% Calculates the speed for the recirculation pumps
%
% Wl: Mass flow through recirculation pumps [kg/s]
% P: Pressure in pumps
% tl: Water temp
% ppump: Pressure increase over pumps [Pa]
% pump: Pump data def. in get_pumpdata
% pk1, pk2: Pump char. ptype 1 and 2

%@(#)   eq_npump.m 2.5   02/02/27     11:49:20

global termo

rol = cor_rol(P,tl);
Q = Wl/rol;

termo.pspeedq=[Q rol ppump];


n = fzero(@eq_pspeed,8,optimset('disp','off'));
if isnan(n),
    n=fminbnd(@eq_pspeed2,0,20);
end

