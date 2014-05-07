function y = dWdrdt(Wdr,Wtot,Krcl)
% y = dWdrdt
% Calculate the loss coefficient, Krcl, Wdr, of the recirculation pump in order 
% for the pressure increase over the pump, y, to be correct.
% Used by fzero

%TODO fix pumpspeed in a more general manner
%Right now only RPM1 is used

global termo
%%
rol=termo.rol_dc2;
%pump=termo.pump;
pk1=termo.pk1;
pk2=termo.pk2;
ndrv=termo.per_jet(1);
njpump=termo.per_jet(2);
Asct=termo.per_jet(3);
Anoz=termo.per_jet(4);
Ksct=termo.per_jet(6);
Knoz=termo.per_jet(8);
%Kdif=termo.per_jet(9);
%nloops=termo.per_rcp(1);
Drcl=termo.per_rcp(3);
Lrcl=termo.per_rcp(4);
%Krcl=termo.per_rcp(5);
rspeed=termo.per_pmp{2};
Qr=termo.per_pmp{3};
Headr=termo.per_pmp{4};
W =termo.per_pmp{5}; %RPM1

%Kdif=Kdif*(ndrv/njpump)^2;
%Knoz=Knoz;
Ksct=Ksct*(ndrv/njpump)^2;
WdrI=Wdr/ndrv;
WdcI=Wtot/ndrv;
WsctI=WdcI-WdrI;
Arcl=pi*Drcl^2/4;
Anoz=Anoz*njpump/ndrv;
Asct=Asct*njpump/ndrv;
%Ath=Anoz+Asct;
dPsct=-(Ksct+1/(2*rol*Asct^2))*WsctI^2;
%dPth=(WdrI^2/Anoz+WsctI^2/Asct-WdcI^2/Ath)/rol/Ath;
%dPdif=-(Kdif-1/(2*rol*Ath^2))*WdcI^2;
%dPrcl=dPsct+dPth+dPdif;
%%



q = Wdr/rol/Qr;
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
%%
h=h*Headr;
dPrcp=h*9.81*rol;
%Krcl=222;
dPnoz=-(Knoz+1/(2*rol*Anoz^2))*WdrI^2;
f=eq_fl(WdrI,0,Drcl,termo.p,Arcl);
y=dPnoz-dPsct+dPrcp-1/(2*rol)*(f*Lrcl/Drcl+Krcl)*(WdrI/Arcl)^2;  % RHS of Eq. 206 in SSP 98/13 rev 4. S3k Methodoloy 

termo.ptype=typ;
termo.pk=pk;

