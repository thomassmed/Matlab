function h=h_v(T,P)
%---------------------------------------------------------------
% h_v(T,P)	Funktion för beräkning av entalpin för underkylt
%		vatten. Temperatur och tryck ges i Kelvin resp.
%		Pa.
%		Referens: VDI Wasserdampftafeln, Auflage 6B
%	
%		Giltigt område: underkylt vatten med t<350 C
%
%		Stefan Ahlinder/FTTP - 19950710
%
%---------------------------------------------------------------

%--------------------------------------------------------------
%		K O N S T A N T E R
%--------------------------------------------------------------
ALFA0=0;
A0=6.824687741e3;
A1=-5.422063673e2;
A2=-2.096666205e4;
A3=3.941286787e4;
A4=-6.733277739e4;
A5=9.902381028e4;
A6=-1.093911774e5;
A7=8.590841667e4;
A8=-4.511168742e4;
A9=1.418138926e4;
A10=-2.017271113e3;
A11=7.982692717;
A12=-2.616571843e-2;
A14=2.284279054e-2;
A15=2.421647003e2;
A16=1.269716088e-10;
A17=2.074838328e-7;
A18=2.174020350e-8;
A19=1.105710498e-9;
A20=1.293441934e1;
A21=1.308119072e-5;
A22=6.047626338e-14;
AL1=8.438375405e-1;
AL2=5.362162162e-4;
AL3=1.720000000;
AL4=7.342278489e-2;
AL5=4.975858870e-2;
AL6=6.537154300e-1;
AL7=1.150000000;
AL8=1.510800000e-5;
AL9=1.418800000e-1;
AL10=7.002753165;
AL11=2.995284926e-4;
AL12=2.040000000e-1;
L0=1.574373327e1;
L1=-3.417061978e1;
L2=1.931380707e1;
HKRIT=70120.4;
PKRIT=221.2;
TKRIT=647.3;
TABS=273.15;
%---------------------------------------------------------------
%		B E R Ä K N I N G A R
%---------------------------------------------------------------
p=P/1e5;			% Gör om tryck till bar
beta=p/PKRIT;
teta=T/TKRIT;
reg=region(T,P);
betalp=L1+2*L2*teta;
yprim=-2*AL1*teta+6*AL2*teta.^(-7);
y=1-AL1*teta.^2-AL2*teta.^(-6);
z=y+sqrt(AL3*y.^2-2*AL4*teta+2*AL5*beta);
summa=-A1+teta.*teta.*(A3+teta.*(2*A4+teta.*(3*A5+teta.*(4*A6+teta.*(5*A7+teta.*(6*A8+teta.*(7*A9+teta.*8*A10)))))));
epsilon=ALFA0+A0*teta-summa;
summa=(z.*(17*(z./29-y./12)+5*teta.*yprim./12)+AL4*teta-(AL3-1)*teta.*y.*yprim);
summa=A11*summa.*z.^(-0.294118);
epsilon=epsilon+summa;
summa=A12-A14*teta.*teta+A15*(9*teta+AL6).*(AL6-teta).^9;
summa=summa+A16*(20*teta.^19+AL7).*(AL7+(teta.^19)).^(-2);
epsilon=epsilon+summa.*beta;
summa=(12*teta.^11+AL8).*(AL8+(teta.^11)).^(-2);
summa=summa.*(A17*beta+A18*beta.^2+A19*beta.^3);
epsilon=epsilon-summa;
summa=A20*(teta.^18).*(17*AL9+19*teta.^2);
summa=summa.*((AL10+beta).^(-3)+AL11*beta);
epsilon=epsilon+summa;
summa=A21*AL12*beta.^3+21*A22*teta.^(-20).*beta.^4;
epsilon=epsilon+summa;
h=epsilon*HKRIT/1000;
return
