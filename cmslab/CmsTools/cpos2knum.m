% Translates core-coordinates to channel number
%
% kannum=cpos2knum(i,j,mminj)
% kannum=cpos2knum(ij,mminj)
%
% Input
%   i     - i-coordinate
%   j     - j-coordinate
%   mminj - core contour
%
% Input (Alternative)
%   ij    - ij-coordinates, one pair of (i,j) per row
%   mminj - core contour
%
% Output
%   kannum - channel number, if (i,j) is outside core, kannum will be zero
%
% Example
%   kannum=cpos2knum(1,15,mminj);
%   kannum=cpos2knum([12 10;13 14],mminj);
%
% See also cor2vec, ij2mminj, knum2cpos, sym_full, vec2cor
%          Control rods: mminj2crmminj
function kannum=cpos2knum(y,x,mminj)
if nargin==2, mminj=x;x=y(:,2);y=y(:,1);end
lx=min(length(x),length(y));
ll=length(mminj)+2;
kannum=zeros(size(x));
for i=1:lx,
  if min(x(i),y(i))>0,
    if x(i)<mminj(y(i))||x(i)>(ll-1-mminj(y(i))),
    else
      kannum(i)=sum(ll-2*mminj(1:y(i)-1))+x(i)-mminj(y(i))+1;
    end
  end
end
