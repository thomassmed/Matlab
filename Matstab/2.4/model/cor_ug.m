function y=cor_ug(P,tl,tsat0);
%y=cor_ug(P,tl,tsat0);        eq. 4.4.75

%Specifika interna energin i mättad ånga

%@(#)   cor_ug.m 2.1   96/08/21     07:56:28

ts=cor_tsat(P);
y=cor_hfg(P)+P.*(1./cor_rol(P,tl)-1./cor_rog(ts))+cor_cpl(ts).*(ts-tsat0); 
