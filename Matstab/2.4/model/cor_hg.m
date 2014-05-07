function hg=cor_hg(P,tl,Tsat0)
%cor_rog     remark to 6.4.31
%
%hg=cor_hg(P,tl,Tsat0)

%@(#)   cor_hg.m 2.1   96/08/21     07:56:22

tsat=cor_tsat(P);
rol = cor_rol(P,tl);
rog = cor_rog(tsat);

hg = cor_hfg(P) + P.*(1./rol - 1./rog) + cor_cpl(tsat).*(tsat - Tsat0);
