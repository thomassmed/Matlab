function k=ind_tnk(varnr,maxnr)
%ind_tnk
%
%r=ind_tnk(varnr,maxnr)
%H�mtar index till kolumnerna i systemmatrisen
%f�r termohydrauliken f�r variabel
%nr varnr. maxnr �r antalet variabler
%f�r noderna i termohydrauliken

%@(#)   ind_tnk.m 2.2   02/02/27     12:04:25

global geom
k = geom.ind_cols + varnr - 1;
