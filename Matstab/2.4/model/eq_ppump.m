function p=eq_ppump(ploss)
%eq_pump
%
%p=eq_ppump(ploss)
%Beräknar tryckfallet över HC-pumparna
%vid tryckfördelningen ploss (termohydraulisk vektor).

%@(#)   eq_ppump.m 2.3   02/02/27     12:06:30

global geom

psum = kan_sum(ploss);
p = -mean(psum(1:geom.ncc));

