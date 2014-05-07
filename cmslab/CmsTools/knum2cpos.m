% Translates channel numbers to core-coordinates 
%
% ij=knum2cpos(kannum,mminj)
%
% Input 
%   kannum - channel number
%   mminj  - core contour
%
% Output
%   ij - Core coordinates, one pair per row, if kannum(i)>number of channels
%        in core, ij(i)=[0 0]
%
% Example
%   cpos_ij=knum2cpos(10,mminj);
%   ij=knum2cpos(1:kan,mminj);
%
% See also cor2vec, cpos2knum, ij2mminj, sym_full, vec2cor
%          Control rods: mminj2crmminj
function yx=knum2cpos(kannum,mminj)
ll=length(mminj)+2;
csum=cumsum(ll-2*mminj);
yx=zeros(length(kannum),2);
for i=1:length(kannum)
  if kannum(i)>sum(ll-2*mminj)
    yx(i,:)=[0 0];
  else
    k=find(kannum(i)<=csum,1);
    yx(i,1)=k;
    if k==1, cs=0;else cs=csum(k-1);end
    yx(i,2)=kannum(i)-cs+mminj(k)-1;
  end
end
