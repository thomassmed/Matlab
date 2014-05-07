function [r,k,c]=kan_koeff(koeff,varnr,maxvar)
% [r,k,c]=kan_koeff(koeff,varnr,maxvar)
%
% Get channel index for system matrix
% r, k, c are the row, column and coefficients for
% the variables with the variable number varnr.
% maxvar is the number of equations per node.
% koeff are the coefficients

global geom
nin=geom.nin;
ncc=geom.ncc;

[rtmp,ktmp] = ind_kanj(1,varnr,maxvar);

r = ones(1,length(ktmp))'*(1:(ncc+1));r = r(:)';
r = r + 1 + maxvar*get_thsize;

k = ind_tnk(varnr,maxvar);

gk = get_kan;
gk = gk(:);

k = k(gk);
c = koeff(gk);
