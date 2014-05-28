% antkan - Calculates nmber of fuel bundles from mminj
%
% kan=antkan(mminj);
%
% Input
%   mminj - core contour
%
% Output
%   kan - number of fuel bundles in core
%
% Example
%   fue_new=read_polca_bin('f3_boc_19.dat');
%   kan=antkan(fue_new.mminj);
%
% See also
%   cor2vec, ij2mminj, readdist, read_polca_bin, read_restart_bin, vec2cor 

%@(#)   antkan.m 1.3	 97/11/05     12:31:23
% Written Richard Jansson Forsmark, summer 2009
function kkan=antkan(mminj)
nx=length(mminj);
kkan=sum(nx+2-2*mminj);
