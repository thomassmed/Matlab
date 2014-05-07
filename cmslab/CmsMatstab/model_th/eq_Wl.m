function y = eq_Wl(P,jm,alfa,tl,A)
%
% y = eq_Wl(P,jm,alfa,tl,A)
% 
% Calculates the water mass flow
%
%
% Eq. 4.4.110 + 4.4.105


global termo

c15=termo.css(:,4);c15=0.1470;

rol = cor_rol(P,tl);

S=eq_slip(alfa,P,'bmalnes');

y = A.*(1-alfa).*rol.*(jm-c15.*alfa)./(1 + alfa.*(S-1));