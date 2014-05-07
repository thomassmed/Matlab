function [Wd_c,P_c,tl_c]=lin_phcpump(Wd,P,tl,n,pump,pk)
%lin_phcpump
%
%[Wd_c,P_c,tl_c]=lin_npump(Wd,P,tl,n,pump,pk)
%Linjärisering av pumdynamiken
%se eq_phcpump.
%Wl,P,tl är termohydrauliska vektorer

%@(#)   lin_phcpump.m 2.1   96/08/21     07:57:20

global geom

j = geom.nin(3)+1;

Wd=Wd/pump(17);
[Wd_c,P_c,tl_c] = fin_diff('eq_phcpump',Wd,P(j),tl(j),n,pump,pk,pk);



