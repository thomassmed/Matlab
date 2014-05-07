function r=ind_tnr(ekvnr,maxnr)
%ind_tnr
%
%r=ind_tnr(varnr,maxnr)
%H�mtar index till raderna i systemmatrisen
%f�r termohydrauliken f�r ekvation
%nr ekvnr. maxnr �r antalet ekvationer
%f�r noderna i termohydrauliken

%@(#)   ind_tnr.m 2.2   02/02/27     12:10:32

global geom
r = geom.ind_rows + ekvnr - 1;
