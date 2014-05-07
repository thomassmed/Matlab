function [Qijk,kinf]=eq_Qijk(pijk,rijk,usig1,usig2,sig1,sig2,sig21,rho,keff,hx,hz,B1,C1)
% [Qijk,kinf]=eq_Qijk(pijk,rijk,usig1,usig2,sig1,sig2,sig21,rho,keff,hx,hz,B1,C1);
%
% ref: eq. 6.2.97-6.2.102 in Wulff et. al

kinf=(usig1+usig2.*sig21./sig2)./sig1;

D=rho.*rho;

qijk=-hx^2*sig1./D.*(kinf/keff-1);

Qijk=(pijk+qijk.*(B1+C1*rijk))./(1-C1*qijk);

%@(#)   eq_Qijk.m 1.2   97/09/22     10:26:18
