%@(#)   minmax.m 1.5	 97/11/05     09:05:52
%
%function dis2d=minmax(dis3d,xmean)
%Takes the value with the highest deviation, and presents
%it with its sign. minmax operates on columns of dis3d
%
% Input: dis3d - input matrix
%        xmean - value from which deviation is measured, default=mean(mean(dis3d))
function dis2d=minmax(dis3d,xmean)
if nargin<2,
  m=mean(mean(dis3d));
else
  m=xmean;
end
[v,i]=max(abs(dis3d-m));
dis2d=getspars(dis3d,i,1:size(dis3d,2))';
