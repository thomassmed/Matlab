function [r,k,nneu]=get_neutnodes(nvt,nvn)
%
%[r,k,nneu]=get_neutnodes(nvt,nvn)
%nvt : Equation number for T/H
%nvn : Equation number for neutronics
%
%Example: [r,k]=get_neutnodes; gives r rows for the T/H
%and k kolumns for the neutronics

%@(#)   get_neutnodes.m 2.3   02/02/27     12:09:52

global geom termo

ncc=geom.ncc;
kmax=geom.kmax;
kan=geom.kan;
ihydr=termo.ihydr;


if nargin<=1,nvn=1;end
if nargin<=0,nvt=1;end

rtmp = ind_tnr(nvt,get_varsize);
r = set_th2ne(rtmp,ihydr);

ne = get_varsize('neut');
j = 1:ne:(kmax*kan*ne);
k = j + get_hydsize + nvn - 1; 

nneu = hist(ihydr,1:ncc);
nneu = ones(1,kmax)'*nneu(:,ihydr);nneu=nneu(:);
