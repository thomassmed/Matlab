function lam=drfd2p(dr,fd)
% drfd2p - Translate decay ratio and frequency to the pole
%
% lam=drfd2p(dr,fd)
%
% See also p2drfd, dw2drfd, drfd2dw

w=2*pi*fd;
sig=log(dr).*fd;

lam=sig+1i*w;