% Converts control rod number to control rod position
%
% crpos=crnum2crpos(crnum,mminj,irmx)
% crpos=crnum2crpos(mminj,irmx)
%
% Input
%   crnum - Control rod number vector
%   mminj - Core contour
%   irmx   - max number of control rods (irmx by irmx)
% 
% Input (Alternative)
%   mminj - Core Contour
%
% Output
%   crpos - Control rod coordinates (i,j)
% Example
%   crpos=crnum2crpos(mminj); % Gives all control rod positions in
%                             % i,j-coordinates
% 
% See also cor2cr, crnum2knum, crpos2crnum, crpos2knum, cr2map, filtcr, map2cr,
%          mminj2crmminj
function crpos=crnum2crpos(varargin)
if nargin==1,
    mminj = varargin{1};
    irmx=length(mminj)/2;
    [crmminj,n_cr]=mminj2crmminj(mminj,irmx);
    crnum=1:n_cr;
elseif nargin==2,
    if length(varargin{2})==1,
        mminj=varargin{1};
        irmx=varargin{2};
        [crmminj,n_cr]=mminj2crmminj(mminj,irmx);
        crnum=1:n_cr;
    else
        crnum=varargin{1};
        mminj=varargin{2};
        irmx=length(mminj)/2;
        [crmminj,n_cr]=mminj2crmminj(mminj,irmx);
    end
elseif nargin==3,
    crnum=varargin{1};
    mminj=varargin{2};
    if length(varargin{3})==1,
        irmx=varargin{3};
        [crmminj,n_cr]=mminj2crmminj(mminj,irmx);
    else
        crmminj=varargin{3};
        irmx=length(crmminj);
    end
else
    error('Number of input arguments have to be 2 or 3');
end
crpos=knum2cpos(crnum,crmminj);
