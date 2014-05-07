function y = eq_vg(S,jm,alfa);
%
% y = eq_vg(S,jm,alfa)
%
% INPUT: slip,volumeflux and void.
%
% OUTPUT : Axial steam velocity 
%
% Equation 4.4.106

%@(#)   eq_vg.m 2.2   02/02/27     12:06:50

global termo

c15 = termo.css(:,4);c15=0.1470;

y = (S.*jm + (1-alfa).*c15)./(1+alfa.*(S-1));

% steamvelocity is zero when there is no steam present
%y = y.*(alfa>0);
