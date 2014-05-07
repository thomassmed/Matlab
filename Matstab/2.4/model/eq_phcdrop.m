function y = eq_phcdrop(x)
%eq_phcdrop
%
%y = eq_phcdrop(x)
%
%searches pressure drop for given pump speed
%Used by fzero

%@(#)   eq_phcdrop.m 2.1   96/08/21     07:56:48

global termo

Q = termo.pspeedq(1);
rol = termo.pspeedq(2);
n = termo.pspeedq(3);
pump=termo.pump;

q = Q/pump(3);
w = n/pump(1);
h = (x/9.81/rol - pump(7)*(Q^2))/pump(4);

if ((q/w) > 1),
  pk = tero.pk2;
  typ = 2;
else
  pk = termo.pk1;
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

termo.pk=pk;


