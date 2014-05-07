function y = eq_haac(P,tw,Wl,A,Iboil,Dh)
%
%  y = eq_haac(P,tw,Wl,A,Iboil,Dh,mod)
%
% INDATA : systemtrycket,väggtemperatur,vattenmassflöde,arean,kokningsvektor
%          hydraulisk diameter och boiling region. Om mod==1 kommer hc beräknas 
%          endast beroende på Iboil. Ingen check på noder görs
% 
% UTDATA : värmeövergångstalet hc
% eq. 4.4.30 /34

%@(#)   eq_haac.m 2.1   96/08/21     07:56:40


tsat = cor_tsat(P);

%NUCLEATE BOILING
ynb = 2.555*(exp(P*6.45e-7)).*(tw-tsat).^3;
ynb = Iboil.*ynb;

cpl = cor_cpl(tsat);
kl = cor_kl(tsat);
myl = cor_myl(tsat);

%FORCED CONVECTION
y = zeros(size(tw));
Nre = Wl./A.*Dh./myl;
Npr = myl.*cpl./kl;
yfc = (~Iboil).*(0.023*kl./Dh.*(Nre.^0.8).*(Npr.^0.4));

y = ynb + yfc;

