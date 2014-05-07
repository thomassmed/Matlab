function y = eq_pflow(x)
% y = eq_pflow(x)
% Calculate the flow, x, of the recirculation pump in order 
% for the pressure increase over the pump, y, to be correct.
% Used by fzero

%TODO fix pumpspeed in a more general manner
%Right now only RPM1 is used

global termo
rol=termo.rol_dc2;
pump=termo.pump;
pk1=termo.pk1;
pk2=termo.pk2;
ndrv=termo.per_jet(1);
njpump=termo.per_jet(2);
Asct=termo.per_jet(3);
Anoz=termo.per_jet(4);
Ksct=termo.per_jet(6);
Knoz=termo.per_jet(8);
nloops=termo.per_rcp(1);
rcpdia=termo.per_rcp(3);
rcplen=termo.per_rcp(4);
rcploss=termo.per_rcp(3);
rspeed=termo.per_pmp{2};
Qr=termo.per_pmp{3};
Headr=termo.per_pmp{4};
W =termo.per_pmp{5}; %RPM1

Kdc2=.5;
KD=rcploss+Kdc2+Knoz;

%y=h+(Ksct+1/(2*rol*Asct*Asct))*(Wtot-Wrcl)^2/njpump^2-(KD/ndrv^2+1/(2*rol*Anoz^2*njpump^2))*Wrcl^2;

q = x/Qr;
w = W/rspeed;


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
  h = interp1(pk(:,2),pk(:,1),qw)*(w^2);
else
  qw = min([w/q max(pk(:,2))]);
  qw = max([qw min(pk(:,2))]);
  h = interp1(pk(:,2),pk(:,1),qw)*(q^2);
end

Wrcl=x*rol;
h=h*Headr;
Pp=h*9.81*rol;
y=Pp+(Ksct+1/(2*rol*Asct*Asct))*(termo.Wtot-Wrcl)^2/njpump^2-(KD/ndrv^2+1/(2*rol*Anoz^2*njpump^2))*Wrcl^2;

termo.ptype=typ;
termo.pk=pk;

