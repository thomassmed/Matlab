function y=eq_Nre(Wl,Wg,dh,P,A)
%eq_Nre
%
%y=eq_Nre(Wl,Wg,dh,P,A)
%Beräknar reeynolds tal till enfasfaktorn
%Ekv. 4.4.31

%@(#)   eq_Nre.m 2.1   96/08/21     07:56:35

y = (Wl+Wg).*dh./cor_myl(cor_tsat(P))./A;
