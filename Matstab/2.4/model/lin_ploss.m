function [Wl_c,Wg_c,wg_c,P_c,alfa_c,tl_c]=lin_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2corr,korrtype)
%lin_ploss
%
%[Wl_c,Wg_c,wg_c,P_c,alfa_c,tl_c]=lin_ploss(Wl,Wg,wg,P,alfa,tl,vhk,Dh,Hz,A,dc2corr,korrtype)
%Linjäriserar funktionen eq_ploss
%Utarmumenten innehåller
%de partiella derivatorerna för ploss map
%Wl,Wg,wg,P,alfa,tl

global geom

nin=geom.nin;
nout=geom.nout;
ncc=geom.ncc;


%@(#)   lin_ploss.m 2.5   02/02/27     12:07:24

[P_c1,alfa_c1,tl_c1] = fin_diff('eq_pelev',P,alfa,tl,Hz,dc2corr);
[Wg_c2,Wl_c2,P_c2,tl_c2] = fin_diff('eq_pfric',Wg,Wl,P,tl,A,Dh,Hz,korrtype);
[Wl_c3,Wg_c3,P_c3,tl_c3] = fin_diff('eq_prestr',Wl,Wg,P,tl,A,vhk);

%Acceleration losses

j1 = nin;
j1(1:4) = j1(1:4)+1;
j1(5:(5+ncc)) = j1(5:(5+ncc)) + ncc + 1; 
j1(5+ncc+1) = j1(5+ncc+1) + 1;
j2 = nout;
z = zeros(get_thsize,1);
Wl_c4 = z;Wg_c4 = z;wg_c4 = z;P_c4 = z;tl_c4 = z;alfa_c4 = z;

[c1,c2,c3,c4,c5,c6] =fin_diff('eq_paccD',Wl,Wg,wg,P,tl,alfa,A);

Wl_c4(j1) = -c1(j1);Wl_c4(j2) = c1(j2);
Wg_c4(j1) = -c2(j1);Wg_c4(j2) = c2(j2);
wg_c4(j1) = -c3(j1);wg_c4(j2) = c3(j2);
P_c4(j1) = -c4(j1);P_c4(j2) = c4(j2);
tl_c4(j1) = -c5(j1);tl_c4(j2) = c5(j2);
alfa_c4(j1) = -c6(j1);alfa_c4(j2) = c6(j2);

%Sum of all coefficents

Wl_c = -Wl_c2 - Wl_c3 - Wl_c4;
Wg_c = (-Wg_c2 - Wg_c3 - Wg_c4).*(alfa>0);
wg_c = -wg_c4.*(alfa>0);
P_c = -P_c1 - P_c2 - P_c3 - P_c4;
alfa_c = (-alfa_c1 - alfa_c4).*(alfa>0);
tl_c = -tl_c1 - tl_c2 - tl_c3 - tl_c4;
