function y=quant(x,n,rmax,rmin)
%quant quatisizes a signal into discrete
%steps according to the resolution in 2^n
%and the range rmax-rmin. Def. rmin = 0.

%Påk, 960201

if nargin==3,rmin=0;end

r = rmax-rmin;
y = round(x/r*2^n)*r/2^n;
