function fl=eq_fl(Wl,Wg,dh,P,A)
%eq_fl
%
%fl=eq_fl(Wl,Wg,dh,P,A)
%Single phase pressure drop
%Ekv. 4.4.44

%@(#)   eq_fl.m 1.2   02/03/04     14:06:37

Nre = eq_Nre(Wl,Wg,dh,P,A);

Nre(1) = Inf;
fl = 0.23./(Nre.^0.2); %New koefficient according to L.Moberg/SSP-01/210

