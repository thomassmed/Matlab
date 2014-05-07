function y = eq_gamv(gammaw,gammaph);
% y = eq_gamv(gammaw,gammaph)
%
% INDATA : Ånggenereringshastighet från bränsleväggen samt ånggenererings-
%	   kondensationshastighet från vattnet.
%
% UTDATA : Totala ånggenereringen
%
% Ekvation 4.4.51

%@(#)   eq_gamv.m 2.1   96/08/21     07:56:39

temp = gammaw + gammaph;

y = temp.*(temp>0);
