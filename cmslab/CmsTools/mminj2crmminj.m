% Converts bundle core-contour to control rod core contour
%
% [crmminj,n_cr] = mminj2crmminj(mminj,irmx)
% 
% Note: the this use of the function assumes that there is a control rod if and only if
%       there are four bundles in a possible control rod position.
%       For a plant like Cooper, use the second option: 
% [crmminj,n_cr] = mminj2crmminj(crtyp_map);
%
% Input
%   mminj - core contour
%   irmx   - max number of control rods (irmx by irmx) (default = iamax/2)
%   
% Output
%   crmminj - Control rod contour
%   ncr     - Number of control rods
%
% Example
%   fue_new=read_restart_bin('s3-1.res');
%   mminj=fue_new.mminj;
%   [crmminj,n_cr]=mminj2crmminj(mminj); % Generates the control rod position shape
%                                        % and number of control rods
%   [crmminj,n_cr]=mminj2crmminj(crtyp_map); 
%
% See also cor2cr, crpos2crnum, cr2map, crnum2crpos, crpos2knum, filtcr, map2cr,


function [crmminj, n_cr] = mminj2crmminj(mminj,irmx)

if min(size(mminj))>1,
    crtyp_map=mminj;
    crmminj=zeros(size(crtyp_map,1),1);
    for i=1:size(crtyp_map,1),
        crmminj(i)=find(crtyp_map(i,:),1);
    end
else
    smminj = length(mminj);
    if nargin<2, irmx=smminj/2; end
    j = 1;
    crmminj = zeros(irmx, 1);
    if irmx==smminj/2,              
        istart1=1;
        istop1=smminj/2 -1;
        istart2=smminj/2+1;
        istop2=smminj;
    else                % Deals with Fitzpatrick with a completely uncontrolled outer row
        istart1=2; 
        istop1=smminj/2-2;
        istart2=smminj/2;
        istop2=smminj-2;
    end     
    for i = istart1:2:istop1
        crmminj(j) = floor((mminj(i)-istart1+1)/2 + 1);
        j = j + 1;
    end
    for i = floor(istart2):2:floor(istop2)
        crmminj(j) = floor((mminj(i)-istart1+1)/2 + 1);
        j = j + 1;
    end
end
n_cr=sum(length(crmminj)-2*(crmminj-1));

