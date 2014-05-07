function [qprimw_c,P_c,tl_c,tw_c,alfa_c]=lin_gamv(qprimw,P,tl,tw,alfa,gammav,A)
%lin_gamv
%
%[qprimw_c,P_c,tl_c,tw_c,alfa_c]=lin_gamv(qprimw,P,tl,tw,alfa,gammav,A)
%Beräknar koefficienterna för variablerna i linjäriserade
%total ånggenereringsekvationen 4.4.51

%@(#)   lin_gamv.m 2.3   02/02/27     12:04:53

global geom

nin=geom.nin;

[alfa_c,P_c1,tl_c1]=lin_gamph(alfa,P,tl);
[qprimw_c,P_c2,tl_c2,tw_c]=lin_gamw(qprimw,P,tl,tw,A);
P_c = P_c1 + P_c2;
tl_c = tl_c1 + tl_c2;
c = (gammav>0);
c(nin)=zeros(length(nin),1);
qprimw_c = qprimw_c.*c;
P_c = P_c.*c;
tl_c = tl_c.*c;
tw_c = tw_c.*c;
alfa_c =alfa_c.*c;
