function y = eq_pspeed(x)
% y = eq_pspeed(x)
% Calculate the speed, x, of the recirculation pump in order 
% for the pressure increase over the pump, y, to be correct.
% Used by fzero

%@(#)   eq_pspeed.m 2.4   02/02/27     11:50:23

global termo
pump=termo.pump;
pk1=termo.pk1;
pk2=termo.pk2;
Q =termo.pspeedq(1);
rol = termo.pspeedq(2);
ppump = termo.pspeedq(3);

q = Q/pump(3);
w = x/pump(1);
h = (ppump/9.81/rol - pump(7)*(Q^2))/pump(4);
if (h<0)&(~any(pk2(:,1)<0))
  error('Negative pump head and no negative head data defined in CARD 547xxx')
end

if ((q/w) > 1),
  pk = pk2;
  typ = 2;
else
  pk = pk1;
  typ = 1;
end

if typ==1,
  qw = min([q/w max(pk(:,2))]);
  qw = max([qw min(pk(:,2))]);
  y = h - interp1(pk(:,2),pk(:,1),qw)*(w^2);
else
  qw = min([w/q max(pk(:,2))]);
  qw = max([qw min(pk(:,2))]);
  y = h - interp1(pk(:,2),pk(:,1),qw)*(q^2);
end

termo.ptype=typ;
termo.pk=pk;

