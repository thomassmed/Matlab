function ul=cor_ul(P,tl,tsat0)
%cor_ul
%
%ul=cor_ul(P,tl,tsat0)  eq. 4.4.77

%@(#)   cor_ul.m 2.1   96/08/21     07:56:28

ul = cor_cpl(cor_tsat(P)).*(tl-tsat0);
