function y = eq_tw(tw,tc,tl,P,Wl,A,Iboil,Dh)
%
% y = eq_tw(tw,tc,tl,P,Wl,A,Iboil,Dh)
%
% Calculates the deviation from the stedy state wall temperature.
%
% Eq 6.3.34



global fuel

mmc=fuel.mmc;

hc = eq_haac(P,tw,Wl,A,Iboil,Dh);

%tfl = water temp. at sub-cooled boiling, ie. tsat
% At FC is tfl = tland at
% NB when  tl>tsat is tfl = tsat

i = find(Iboil);
tfl = tl;
tfl(i) = cor_tsat(P(i)); 

[ii,jj]=size(tl);
drca=reshape(fuel.drca,ii,jj);
rlca=reshape(fuel.rlca,ii,jj);

y = -tw + tfl  + (tc-tfl)./(1+hc.*drca./rlca/2/mmc);

