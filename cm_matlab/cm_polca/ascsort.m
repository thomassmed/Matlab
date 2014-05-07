%@(#)   ascsort.m 1.3	 97/11/05     09:00:54
%
%function [strut,i]=ascsort(strin)
%Sorts vector of ascii string in ascending order
%Input:  strin - vector of strings
%Output: strut - sorted vector of strings
%        i     - index
%
function [strut,i]=ascsort(strin)
[is,js]=size(strin);
jj=(2*js-2:-2:0)';
jj=10.^jj;
x=abs(strin)*jj;
[xx,i]=sort(x);
strut=strin(i,:);
