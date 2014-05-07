%function [map]=ascdist2map(dist,mminj,width)
%
% Arguments:
%  dist               Ascii distribution to be printed
%  mminj              Core shape vector
%  width (optional)   Width of field for each printed value
%
function [map]=ascd2map(dist,mminj,varargin)

if nargin<3
  width=size(dist,2)-min(sum(dist'==' '));
else
  width=varargin{1};
end

presp=char(ones(1,width)*double(' '));

map='';
ind=1;
for i=1:length(mminj),
  for j=1:mminj(i)-1,
    map=[map sprintf('%s ',presp)];
  end
  for j=mminj(i):length(mminj)-mminj(i)+1
    map=[map sprintf('%s ',dist(ind,1:width))];
    ind=ind+1;
  end
  map=[map sprintf('\n')];
end