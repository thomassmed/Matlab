function hl=cor_hl(mg,romum,tl,P,Tsat0,V)
%cor_hl
%
%hl=cor_hl(mg,romum,tl,P,Tsat0,V)

%@(#)   cor_hl.m 2.1   96/08/21     07:56:23

hg = cor_hg(P,tl,Tsat0);
hl = (romum.*V - mg.*hg)./(V - mg./cor_rog(cor_tsat(P)))./cor_rol(P,tl);

