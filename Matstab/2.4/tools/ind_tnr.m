function r=ind_tnr(ekvnr,maxnr)
%ind_tnr
%
%r=ind_tnr(varnr,maxnr)
%Hämtar index till raderna i systemmatrisen
%för termohydrauliken för ekvation
%nr ekvnr. maxnr är antalet ekvationer
%för noderna i termohydrauliken

%@(#)   ind_tnr.m 2.2   02/02/27     12:10:32

global geom
r = geom.ind_rows + ekvnr - 1;
