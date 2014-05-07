function [Wl_c,P_c,tl_c,ppump_c]=lin_npump(Wl,P,tl,phcpump,pump,pk)
%lin_npump
%
%[Wl_c,P_c,tl_c,ppump_c]=lin_npump(Wl,P,tl,phcpump,pump,pk)
%Linjärisering av pumdynamiken
%se eq_npump.
%Wl,P,tl är termohydrauliska vektorer

%@(#)   lin_npump.m 2.3   02/02/27     12:11:49

global geom

j = geom.nin(3)+1;

[Wl_c,P_c,tl_c,ppump_c] = fin_diff('eq_npump',Wl(j),P(j),tl(j),phcpump,pump,pk,pk);



