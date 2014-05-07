%@(#)   sorttorrf.m 1.2	 94/08/12     12:15:48
%
function [garut,rest,restsek]=sorttorrf(antorrf,garburn,weight,eta,bpcost);
garut=weight.*garburn.*antorrf*24/1e6*eta;
rest=garut;
restsek=bpcost.*antorrf;
end
