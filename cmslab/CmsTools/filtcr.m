% Filters out channel numbers for which mink<konrod<maxk
%
% [ikan,ikancr]=filtcr(konrod,mminj,mink,maxk)
%
% find fuel channel numbers for fuel in supercells with  control rods between mink and maxk 
% each control rod that satisfies mink<crod<maxk gives a row in ikan ikan will be four columns
%
% Input
%   konrod - vector of control rod values
%   mminj  - core contour
%   mink   - min cr-pos value (default = min(konrod)-1)
%   maxk   - max cr-pos value (default = max(konrod)+1)
%
% Output
%   ikan   - (No-of-hits) by 4 matrix with channel number that satisfy condition
%   ikancr - vector of control rod number that satisfy condition
%
%
% Example
% ikan=filtcr(konrod,mminj); % Gives all bundles that have a control rod
% ikan=filtcr(konrod,mminj,100,500) % Gives all bundles with control rods
%                                   % between 100 and 500
% ikan=filtcr(konrod,mminj,min(konrod)+0.1,max(konrod)-0.1); % Gives all bundles that
%                                                            % have an "active" control rod
%
% See also cor2cr, crnum2crpos, crnum2knum, crpos2crnum, crpos2knum, cr2map, map2cr,
%          mminj2crmminj
function [ikan,ikancr]=filtcr(konrod,mminj,mink,maxk)
if nargin<3, mink=min(konrod)-1;end
if nargin<4, maxk=max(konrod)+1;end
if nargin<5, irmx=length(mminj)/2; end

% Check if the plant is like Fitzpatrick:
[~, n_cr] = mminj2crmminj(mminj);
if n_cr>length(konrod),
    irmx=length(mminj)/2-1;
else
    irmx=length(mminj)/2;
end
[map,mpos]=cr2map(konrod,mminj,irmx);
ikancr=find(konrod>=mink&konrod<=maxk);
if ~isempty(ikancr),
  cpos=2*mpos(ikancr,:)+length(mminj)/2-irmx;
  knum1=cpos2knum(cpos(:,1)-1,cpos(:,2)-1,mminj);
  knum2=cpos2knum(cpos(:,1)-1,cpos(:,2),mminj);
  knum3=cpos2knum(cpos(:,1),cpos(:,2)-1,mminj);
  knum4=cpos2knum(cpos(:,1),cpos(:,2),mminj);
  ikan=[knum1 knum2 knum3 knum4];
else
  ikan=[];
end
