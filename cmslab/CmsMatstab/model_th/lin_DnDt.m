function [Wl_c,P_c,tl_c,n_c]=lin_DnDt(Wl,P,tl,nhcpump)
% [Wl_c,P_c,tl_c,n_c]=lin_DnDt(Wl,P,tl,nhcpump)
%
% Linearization of the pump dynamics
% Wl, P and tl are flow, pressure and tl in first node of lp1
% pump: Pump data def. in get_pumpdata
% pk: Pump char.
% ptype: Type 1 or 2

global termo

pump=termo.pump;
pk=termo.pk;
ptype=termo.ptype;



rol = cor_rol(P,tl);
Q = Wl/rol;

% retrive pump data
w = nhcpump/pump(1);
q = Q/pump(3);
b1 = pump(8);
b2 = pump(9);
b3 = pump(10);
w1 = pump(11);
w2 = pump(12);

Mhyd0 = eq_Mpump(Wl,P,tl,nhcpump,pump,pk,ptype);

Wl_c = -(eq_Mpump(Wl+1,P,tl,nhcpump,pump,pk,ptype)-Mhyd0)/pump(2);
P_c = -(eq_Mpump(Wl,P+1,tl,nhcpump,pump,pk,ptype)-Mhyd0)/pump(2);
tl_c = -(eq_Mpump(Wl,P,tl+0.01,nhcpump,pump,pk,ptype)-Mhyd0)/0.01/pump(2);

ndist = nhcpump*1.001;
if ndist>w2,
  Mf1 = b1*ndist^2;
  Mf0 = b1*nhcpump^2;
else
  if ndist>w1,
    Mf1 = b2;
    Mf0 = b2;
  else
    Mf1 = b3;
    Mf0 = b3;
  end
end

if pump(15)==0,
  %Electrical torque, steady state
  global NPUMP MMOT
  NPUMP = nhcpump;MMOT = Mhyd0 + Mf0;
  nmot = fzero(@eq_Mel0,nhcpump*1.001,optimset('disp','off'));   %1.001 just for startguess
  %Elctrical torque, disturbance
  global NMOT
  NMOT = nmot;
  Mel = eq_Mel(ndist); 
else
  Mel = Mhyd0 + Mf0;
end

%M0 is zero
M1 = (Mel - Mf1 - (eq_Mpump(Wl,P,tl,ndist,pump,pk,ptype)))/pump(2);
n_c = M1/(ndist-nhcpump); % Probably )/2/pi vdb;




