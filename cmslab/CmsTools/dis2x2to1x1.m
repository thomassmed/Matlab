function dis1x1=dis2x2to1x1(dis2x2,mminj2x2,subnum,fcn)
% Convert from 1x1 to 2x2
%
% dis1x1=dis2x2to1x1(dis2x2,mminj2x2)
%
% Input
%   dis2x2   - distribution (kmax by kan) in 2x2
%   mminj2x2 - core contour (for 2x2)
%   subnum   - Numbering flag, if true, the ch no in first assembly is
%   1,2,3,4
%
% Output
%   dis1x1   - Compacted distribution
%
% Example
% 
% dis1x1=dis2x2to1x1(dis2x2,mminj2x2);
%
% See also dis1x1to2x2

%%
if nargin<3, subnum=true;end
if nargin<4, fcn=@mean;end
kmax=size(dis2x2,1);
kan=size(dis2x2,2);
if subnum,
    knum=convert2x2('2subnum',1:kan/4,mminj2x2);
else
    knum=crnum2knum(1:kan/4,mminj2x2);
end
dis1x1=zeros(kmax,kan/4);
for i=1:kan/4,
    dis1x1(:,i)=fcn(dis2x2(:,knum(i,:))');
end


