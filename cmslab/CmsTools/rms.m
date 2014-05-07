% rms - root mean square
%
% y=rms(x)
%
% Input:
%  x - Input vector (or matrix)
% 
% Output
%  y - scalar containing rms-value
function y=rms(x)
N=numel(x);
y=sqrt(x(:)'*x(:)/N);
