function [dr,fd]=dw2drfd(d,w0)
% dw2drfd - Translate from dw to decay ratio and frequency
%
% [dr,fd]=dw2drfd(d,w0)
%
% Input
%   d  - d in the characteristic parametrization 
%         (s/w0)^2 + 2d (s/w0) + 1 = 0
%   w0 - w0 in the equation above
%
% Output
%   dr - decay ratio
%   fd - Frequency
%
% Example
%  [dr,fd]=dw2drfd(0.1,3.5);
%
% See  also: drfd2dw, p2drfd, drfd2p
dr=exp(-2*pi*d/sqrt(1-d^2));
fd=w0/2/pi*sqrt(1-d^2);