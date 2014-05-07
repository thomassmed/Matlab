function [qprimw_c,P_c,tl_c,tw_c]=lin_gamw(qprimw,P,tl,tw,A)
%lin_gamw
%
%[qprimw_c,P_c,tl_c,tw_c]=lin_gamw(qprimw,P,tl,tw,A)
%Beräknar koefficienterna för variablerna i linjäriserade
%ånggenereringsekvationen EKV 4.4.56

%@(#)   lin_gamw.m 2.2   01/09/23     16:09:39

[qprimw_c,P_c,tl_c,tw_c]=fin_diff('eq_gamw',qprimw,P,tl,tw,A);
