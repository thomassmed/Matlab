function [P_c,Wl_c,tw_c,tl_c]=lin_qprimw(P,Wl,tw,tl,A,phm,Dh,Htc,Iboil)
%lin_qprimw
%
%[P_c,Wl_c,tw_c,tl_c]=lin_qprimw(P,Wl,tw,tl,A,phm,Dh,Htc,Iboil)
%Beräknar finita differensen för funktionen eq_qprimw

%@(#)   lin_qprimw.m 2.3   02/02/27     12:11:59

[P_c,Wl_c] = fin_diff('eq_qprimw',P,Wl,tw,tl,A,phm,Dh,Htc,Iboil);

hc = eq_haac(P,tw,Wl,A,Iboil,Dh);
tw_c = 4*phm.*hc.*Iboil + phm.*hc.*(~Iboil);
tl_c = -phm.*hc.*(~Iboil);


