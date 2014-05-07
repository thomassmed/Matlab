function [alfa,Wl,Wg,gammav,tl,WgD,WlD] = sysalgfd(mg,romum,phi0,jm0,qprimw,tw,Wlci,Wbyp,Wfw,fwpos,P,A,V,Hz)
%[alfa,Wl,Wg,gammav,tl,WgD,WlD] = sysalgfd(mg,romum,phi0,jm0,qprimw,tw,Wlci,Wbyp,Wfw,fwpos,P,A,V,Hz)
%
%Calculates the algebraic variables. Used when calculating
%finite differences in sysf.

%@(#)   sysalgfd.m 1.6   02/02/27     12:17:20

global geom termo
nin=geom.nin;
nout=geom.nout;
ncc=geom.ncc;
kmax=geom.kmax;
c15 = termo.css(:,4);

alfa = mg./cor_rog(cor_tsat(P))./V;
tl = eq_tl0(romum,P,alfa);
rof = cor_rof(cor_tsat(P));
gammav = eq_gamv(eq_gamw(qprimw,P,tl,tw,A),eq_gamph(alfa,P,tl)).*(alfa>0);
S = eq_slip(alfa,P,'bmalnes');

wl = eq_vl(S,jm0,alfa);
Wl = (1-alfa).*wl.*rof.*A;
wg = (S.*wl + c15).*(alfa>0);
Wg = eq_Wg(P,wg,alfa,A);

%This section is used to calculate the finate differences
%in the nodes where gammav has influence, that is not
%in the neigbour nodes 
phiD = eq_volexp(gammav,P,tl,A,Hz)-phi0;
wlD = eq_vl(S,jm0+phiD./A,alfa);
WlD = (1-alfa).*wlD.*rof.*A;
wgD = (S.*wlD + c15).*(alfa>0);
WgD = eq_Wg(P,wgD,alfa,A);



