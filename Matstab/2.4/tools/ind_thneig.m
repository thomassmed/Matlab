function [r,k]=ind_thneig(eqnr,varnr,maxnr)
% ind_thnneig
%
% [r,k]=ind_thneig(eqnr,varnr,maxnr)
% Gets the index for the thermo hydraulic neighbours in the A-matrix
% eqnr: equation number for the node
% varnr: column number (variable number) for the node
% maxnr: number fo variables

global geom

nin=geom.nin;

kk = get_thneig;
k = 1 + (kk-1)*maxnr + varnr;
r = ind_tnr(eqnr,maxnr);
r([1;nin]) = [];
