function k=ind_tnk(varnr,maxnr)
%ind_tnk
%
%r=ind_tnk(varnr,maxnr)
%Hämtar index till kolumnerna i systemmatrisen
%för termohydrauliken för variabel
%nr varnr. maxnr är antalet variabler
%för noderna i termohydrauliken

%@(#)   ind_tnk.m 2.2   02/02/27     12:04:25

global geom
k = geom.ind_cols + varnr - 1;
