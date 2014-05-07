function [cnum,cden]=dtf2ctf(dnum,dden,T);
%
%[cnum,cden]=dtf2ctf(dnum,dden,T);
%
%Omvandlar verfringsgunktionen fr ett diskret system till
%en kontinuerlig verfringsfunktion. T r samplingstiden.
%
%
[adss,bdss,cdss,ddss]=tf2ss(dnum,dden);
[acss,bcss]=d2c(adss,bdss,T);
[cnum,cden]=ss2tf(acss,bcss,cdss,ddss,1);
