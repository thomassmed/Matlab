function [alfa_c,P_c] = lin_slip(alfa,P,korrtype)
%
%[alfa_c,P_c] = lin_slip(alfa,P,korrtype)
%Linjärisering av eq_slip 

%@(#)   lin_slip.m 2.3   01/09/23     16:09:54

[alfa_c,P_c] = fin_diff('eq_slip',alfa,P,korrtype);
alfa_c(1) = 0;
alfa_c = alfa_c.*(alfa>0);
