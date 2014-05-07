function y = eq_dP_pump(Wl,n,tl,p)
% y = eq_dP_pump(Wl,n)
% Calculate the pump head in Pa


global termo
pump=termo.pump;
pk1=termo.pk1;
pk2=termo.pk2;
if nargin<3
    rol = termo.pspeedq(2);
else
    if nargin<4, p=termo.p;end
    rol=cor_rol(p,tl);
end
hrated=pump(4);
   %pump(7)=-rcploss/((dh_pump/2)^2*pi)^2/2/9.81/nrcp/nrcp; % See SSP-07/119, p 22 and RAMONA input card 547100
                                                                       % /nrcp^2 is to account for the fact that we model one
                                                                       % equivalent pump
rcploss_ramona=pump(7);
Q=Wl/rol;
q = Q/pump(3);
w = n/pump(1);

if ((q/w) > 1),
  pk = pk2;
  typ = 2;
else
  pk = pk1;
  typ = 1;
end

if typ==1,
  qw = q/w;
  h = interp1(pk(:,2),pk(:,1),qw,'linear','extrap')*(w^2);
else
  qw = w/q;
  h = interp1(pk(:,2),pk(:,1),qw,'linear','extrap')*(q^2);
end
y=(h*hrated+rcploss_ramona*Q^2)*9.81*rol;



