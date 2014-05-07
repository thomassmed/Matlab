function c=get_sym
%get_sym
%
%c=get_sym
%Hämtar skalningsfaktor beroende på 
%härdsymmetri. Kvartshärd ger c=4.
 
%@(#)   get_sym.m 2.1   96/08/21     07:57:01

global msopt

j=[1 2 2 2 4 4 4 4 8 NaN NaN 2 2];
c=j(msopt.CoreSym);
