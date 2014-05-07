% Convert cr postion to cr number
%
% crnum=crpos2crnum(icr,jcr,mminj,irmx)
% crnum=crpos2crnum(ij_cr,mminj,irmx)
% 
% Input
%   icr   - (Vector of) Control i-index (Note: i-index is y) 
%   jcr   - (Vector of) Control j-index (Note  j-index is x)
%   mminj - Core contour
%
% Input (Alternative)
%   ij_cr - Matrix, each row is a pair of i,j for control rods
%   mminj - Core contour
%
% Output
%   crnum - Vector of control rod numbers
%
% Example
%   crnum=crpos2crnum([1 7],mminj,irmx);
%   crnum=crpos2crnum(1,7,mminj,irmx);
%
% See also cor2cr, crnum2crpos, crnum2knum, crpos2knum, cr2map, filtcr, map2cr,
%          mminj2crmminj
function crnum=crpos2crnum(varargin)
if nargin==3,
    ij=varargin{1};
    mminj=varargin{2};
    irmx=varargin{3};
elseif nargin==4,
    icr=varargin{1};
    jcr=varargin{2};
    mminj=varargin{3};
    irmx=varargin{4};
    ij=[icr(:) jcr(:)];
else
    error('Number of input arguments have to be 3 or 4');
end
crmminj=mminj2crmminj(mminj,irmx);
crnum=cpos2knum(ij,crmminj);
