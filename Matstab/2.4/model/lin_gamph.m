function [alfa_c,P_c,tl_c]=lin_gamph(alfa,P,tl)
%lin_gamph
%
%[alfa_c,P_c,tl_c]=lin_gamph(alfa,P,tl)
%Ber�knar koefficienterna f�r variablerna i linj�riserade
%�nggenereringsekvationen EKV 4.4.57

%@(#)   lin_gamph.m 2.2   01/09/23     16:09:36

[alfa_c,P_c,tl_c]=fin_diff('eq_gamph',alfa,P,tl);
