function [black,white]=chess(pow,mminj)
kan=size(pow,2);
j=(1:kan)';
ij=knum2cpos(j,mminj);
ijsum=sum(ij')';
white=(round(ijsum/2)==ijsum/2);
black=1-white;
%@(#)   chess.m 1.1   98/03/06     13:18:25
