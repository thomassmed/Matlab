function [dnum,dden]=ctf2dtf(num,den,T);
%
%[dnum,dden]=ctf2dtf(num,den,T);
%
%Omvandlar verfringsgunktionen fr ett kontinuerligt system till
%en diskret verfringsfunktion. T r samplingstiden.
%
%
[acss,bcss,ccss,dcss]=tf2ss(num,den);
[adss,bdss]=c2d(acss,bcss,T);
[dnum,dden]=ss2tf(adss,bdss,ccss,dcss,1);
