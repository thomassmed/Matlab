function [alfa,S,Wl,wl,Wg,wg,jm,gammav,tl,phi,romum] = sysalg0(mg,romum,qprimw,tw,chflow,flowb,Wbyp,Wfw,fwpos,P,A,V,Hz,type)
%[alfa,S,Wl,wl,Wg,wg,jm,gammav,tl,phi,romum] = sysalg0(mg,romum,qprimw,tw,chflow,flowb,Wbyp,Wfw,fwpos,P,A,V,Hz,type)
%
%Caluculates algebraic variables for steady state 
%If type = 1, the riser section is calculated too
%else not.

%@(#)   sysalg0.m 1.10   02/02/27     12:17:05

global geom termo

kmax=geom.kmax;
ncc=geom.ncc;
nin=geom.nin;
nout=geom.nout;
c15 = termo.css(:,4);

tsat = cor_tsat(P);
rof = cor_rof(tsat);
rog = cor_rog(tsat);
alfa = mg./rog./V;
tl = eq_tl0(romum,P,alfa);
Wlci = chflow - flowb;

gammav = eq_gamv(eq_gamw(qprimw,P,tl,tw,A),eq_gamph(alfa,P,tl)).*(alfa>0);
phi = eq_volexp(gammav,P,tl,A,Hz);
phi1 = reshape(phi(get_corenodes),ncc+1,kmax+1)';
phi1(1,:) = ([Wlci+flowb;Wbyp]/rof(nin(5)))';
phi1(2,:) = ([-flowb;0]/rof(nin(5)))';
phi1 = cumsum(phi1);
jm0 = zeros(get_thsize,1);
jm0(get_corenodes) = reshape(phi1',(ncc+1)*(kmax+1),1);
jm0(fwpos:(nout(4))) = get_sym*ones(1+nout(4)-fwpos,1)*(sum(Wlci)+Wbyp)./rof(fwpos:(nout(4)));
jm0(1:(fwpos-1)) = (jm0(fwpos)-Wfw/rof(fwpos))*ones(fwpos-1,1);
ri = get_risernodes;phi(ri(1)) = phi(ri(1))+sum(jm0(nout(5:5+ncc)));
jm0(get_risernodes) = get_sym*cumsum(phi(get_risernodes));
jm = jm0./A;jm(1)=0;

S = eq_slip(alfa,P,'bmalnes');
wl = eq_vl(S,jm,alfa);
Wl = (1-alfa).*wl.*rof.*A;
wg = (S.*wl + c15).*(alfa>0);
Wg = eq_Wg(P,wg,alfa,A);

if exist('type'),
  %Riser section
  ko = nout(5:(5+ncc));
  kr = get_risernodes;
  lkr = length(kr);

  Wl(kr) = get_sym*sum(Wl(ko))*ones(lkr,1);
  Wg(kr) = get_sym*sum(Wg(ko))*ones(lkr,1);

  ain = newtons('polriser',0.75,1e-3,Wl,Wg,rof,rog,A);

  alfa(kr) = ain*ones(length(kr),1);
  S = eq_slip(alfa,P,'bmalnes');
  mg(kr) = alfa(kr).*rog(kr).*V(kr);
  wg = eq_vg(S,jm,alfa);
  wl = eq_vl(S,jm,alfa);
  kri = get_risernodes; 
  romum(kri) = eq_romum(alfa(kri),P(kri),tl(kri),cor_tsat(P(kri)));
end


