function k=get_kanj(j)
%kan_sum
%
%k=get_kanj(j)
%Hämtar index från nod 2 till
%riserns utlopp genom kanal j

%@(#)   get_kanj.m 2.1   96/08/21     07:57:01

k = [get_dcnodes,get_lp1nodes,get_lp2nodes,get_ch(j),get_risernodes];
