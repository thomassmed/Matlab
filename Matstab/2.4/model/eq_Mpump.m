function M=eq_Mpump(Wl,P,tl,n,pump,pk,ptype)
%eq_Mpump
%
%M=eq_Mpump(Wl,P,tl,n,ppump,pump,pk,ptype)
%Beräknar det hydrauliska momentet för HC-pumparna 
%
%Wl: Massflöde genom hc-pumparna [kg/s]
%P: Absoluttrycket i pumpen
%tl: Vattentemperaturen
%n: pumpvarvtalet [1/s]
%n: pumpvarvtal [1/s]
%pump: Pump data def. in get_pumpdata
%pk: Pump char.
%ptype: Type 1 or 2


%@(#)   eq_Mpump.m 2.1   96/08/21     07:56:34

rol = cor_rol(P,tl);
Q = Wl/rol;

w = n/pump(1);
q = Q/pump(3);

if ptype==1,
  M = (w^2)*interp1(pk(:,2),pk(:,3),q/w);
else
  M = (q^2)*interp1(pk(:,2),pk(:,3),w/q);
end

M = M*pump(6)*rol/pump(5);
