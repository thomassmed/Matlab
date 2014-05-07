function [d,w0]=drfd2dw(dr,fd)
% dw2drfd - Translate from decay ratio and frequency to d and w
%
% [d,w0]=dw2drfd(dr,fd)
%
% Input
%   dr - decay ratio
%   fd - Frequency
%
% Output
%   d  - d in the characteristic parametrization 
%         (s/w0)^2 + 2d (s/w0) + 1 = 0
%   w0 - w0 in the equation above
%
% Example
%  [d,w0]=drfd2dw(.8,.5);
%
% See  also: drfd2dw, p2drfd, drfd2p
lndr2=log(dr).^2;
d=sqrt(lndr2./(4*pi^2+lndr2));
w0=2*pi*fd./sqrt(1-d.^2);
