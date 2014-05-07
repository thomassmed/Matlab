function ys=chsamp(y);
%
% ys=chsamp(y) , ndrar samplingstiden frn 0.1 till 0.08.
%
%
y1=interp(y,5);
y2=decimate(y1,4);
ys=smooth(y2);
