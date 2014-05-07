function y = eq_vl(S,jm,alfa);
%
% y = eq_vl(S,jm,alfa)
%
% INPUT: slip,volumeflux and void.
%
% OUTPUT : Axial liquid velocity 
%
% Equation 4.4.106

%@(#)   eq_vl.m 2.2   02/02/27     12:07:40

global termo

c15 = termo.css(:,4);

y = (jm - alfa.*c15)./(1+alfa.*(S-1));
y(1) = 0;
