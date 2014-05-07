function [r,k]=ind_kanj(j,varnr,maxnr)
%ind_kanj
%
%[r,k]=ind_kanj(j,varnr,maxnr)
%Hämtar index för kanal j till
%system-matrisen.
%j är kanalnummret 
%varnr är kolumnraden (variabelnummret) för noden
%maxnr är antalet variabler

%@(#)   ind_kanj.m 2.1   96/08/21     07:57:08

kk = get_kanj(j);
k = 1 + (kk-1)*maxnr + varnr;
r = ones(1,length(k))*j;
