function [lpeig,apeig]=fft2e(xref,x,Ts)
Xref=fft(detrend(xref));
X=fft(detrend(x));
nmin=round(0.3*Ts*length(xref));
nmax=round(0.7*Ts*length(xref));
[xxref,ixref]=max(abs(Xref(nmin:nmax)));
ixref=ixref+nmin-1;
lpeig=X(ixref,:);
apeig=Xref(ixref);
%@(#)   fft2e.m 1.1   03/08/26     08:02:52
