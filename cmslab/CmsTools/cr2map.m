% Convert control rod value vector to control rod map
%
% [map,mpos]=cr2map(konrod,mminj,irmx)
%
% Input
%   konrod - Control rod value vector
%   mminj  - Core contour
%   irmx   - max number of control rods (irmx by irmx) (default = iamax/2)
%
% Output
%   map - Control rod value map matrix (iamax/2 by iamax/2)
%   mpos - Control rod ij-indices
%
% Example
%   [crmminj,n_cr]=mminj2crmminj(mminj);  
%   [map,mpos]=cr2map(1:n_cr,mminj); % Gives a control rod number map
%   For a plant like Fitzpatrick, with the entire outermost row of bundles
%   is uncontrolled, irmx=
% 
% See also cor2cr, crnum2crpos, crnum2knum, crpos2crnum, crpos2knum, filtcr, map2cr,
%          mminj2crmminj
function [map,mpos,cpos]=cr2map(konrod,mminj,irmx)
if nargin<3, irmx=length(mminj)/2; end

% Check if the plant is like Fitzpatrick:
[crmminj, n_cr] = mminj2crmminj(mminj);
if n_cr>length(konrod),
    irmx=length(mminj)/2-1;
    [crmminj,n_cr]=mminj2crmminj(mminj,irmx);
else
    irmx=length(mminj)/2;
end
iacrmax=length(crmminj);
map=zeros(iacrmax,iacrmax);
mpos=zeros(n_cr,2);
icount=0;
for i=1:iacrmax,
    for j=crmminj(i):(iacrmax-crmminj(i)+1),
        icount=icount+1;
        map(i,j)=konrod(icount);
        mpos(icount,:)=[i j];
    end
end
cpos=2*mpos+length(mminj)/2-irmx;
