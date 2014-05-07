function [eWl]=Wl_matstab2dist(matfil);
% [eWl]=Wl_matstab2dist(matfil);
%
%
global geom termo stab msopt

r = ind_tnr(4,get_varsize);
eWl=stab.e(r);
eWl=set_th2ne(eWl,termo.ihydr);
eWl=mstab2dist(eWl,msopt.DistFile,msopt.CoreSym);


%@(#)   Wl_matstab2dist.m 1.2   03/08/26     08:10:34
