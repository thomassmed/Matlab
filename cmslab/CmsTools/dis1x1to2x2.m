function dis2x2=dis1x1to2x2(dis1x1,mminj)
% Convert from 2x2 to 1x1
%
% dis2x2=dis1x1to2x2(dis1x1,mminj)
%
% Input
%   dis1x1 - distribution (kmax by kan) in 1x1
%   mminj  - core contour
%
% Output
%   dis2x2 - Expanded distribution (2x2)
%
% Example
% 
% dis2x2=dis1x1to2x2(dis1x1,mminj);
%
% See also dis2x2to1x1

%%
mminj2x2=zeros(2*length(mminj),1);
mminj2x2(1:2:end)=2*mminj-1;
mminj2x2(2:2:end)=2*mminj-1;
kmax=size(dis1x1,1);
kan=size(dis1x1,2);
knum=crnum2knum(1:kan,mminj2x2);
dis2x2=zeros(kmax,4*kan);
for i=1:4,
    dis2x2(:,knum(:,i))=dis1x1;
end


