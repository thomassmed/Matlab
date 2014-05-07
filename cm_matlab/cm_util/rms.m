%@(#)   rms.m 1.7	 97/11/05     09:03:58
%
%function y=rms(x)
function y=rms(x)
if size(x,1)==1, x=x';end
N=size(x,1);
y=diag(sqrt(x'*x/N))';
