function [tw_c,tc_c,tl_c,P_c] = lin_tw(tw,tc,tl,P,Wl,A,Iboil,Dh)
%lin_tw
%
%[tw_c,tc_c,tl_c,P_c] = lin_tw(tw,tc,tl,P,Wl,A,Iboil,Dh)
%Linjärisering av eq_tw

%@(#)   lin_tw.m 2.2   01/09/23     16:09:57

[tw_c,tc_c,tl_c,P_c]=fin_diff('eq_tw',tw,tc,tl,P,Wl,A,Iboil,Dh);

j = find(tw==0);
z = zeros(length(j),1);


tw_c(j) = z;
tc_c(j) = z;
tl_c(j) = z;
P_c(j) = z;
