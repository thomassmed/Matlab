function AQfn=A_Qfn(keff,Afn,pijk,rijk,usig1,usig2,sig1,sig2,sig21,rho,hx,hz,B1,C1);
% AQfn=A_Qfn(keff,Afn,pijk,rijk,usig1,usig2,sig1,sig2,sig21,rho,hx,hz,B1,C1);
Qijk=eq_Qijk(pijk,rijk,usig1,usig2,sig1,sig2,sig21,rho,keff,hx,hz,B1,C1);
NTOT=length(Qijk);
AQfn=spdiags(Qijk,0,NTOT,NTOT)-Afn;
%@(#)   A_Qfn.m 1.2   97/09/22     10:24:40
