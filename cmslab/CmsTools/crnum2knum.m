% translates from cr position to channel number
%
%
% knum=crnum2knum(crnum,mminj)
% knum=crnum2knum(mminj)
%
% Input
%   crnum - Vector of control rod numbers
%   mminj - Core contour
%
% Output
%   knum - Matrix length(crnum) by 4 of channel numbers
%
% Example
%   knum=crnum2knum(mminj); % Give the four channel numbers for each
%                           % in order NW NE SW SE. For reactors with
%                           % supercells with only 3 bundles, the empty
%                           % position will have 0 in knum
%   knum=crnum2knum(1:10,mminj); % Gives the channel numbers for the 10
%                                % first control rods
%
% See also cor2cr, crnum2crpos, crpos2crnum, crpos2knum, cr2map, filtcr, map2cr,
%          mminj2crmminj
function knum=crnum2knum(varargin)
if nargin==1, 
    mminj=varargin{1};
    [crmminj,n_cr]=mminj2crmminj(mminj);
    crnum=1:n_cr;
elseif nargin==2,
    crnum=varargin{1};
    mminj=varargin{2};
    [crmminj,n_cr]=mminj2crmminj(mminj);
elseif nargin==3,
    crnum=varargin{1};
    mminj=varargin{2};
    crmminj=varargin{3};
else
    error('Number of input arguments has to be 1, 2 or 3');
end

crpos=crnum2crpos(crnum,mminj,crmminj);

cpos4=2*crpos;
cpos1=[cpos4(:,1)-1 cpos4(:,2)-1];
cpos2=[cpos4(:,1)-1 cpos4(:,2)];
cpos3=[cpos4(:,1) cpos4(:,2)-1];
knum1=cpos2knum(cpos1,mminj);
knum2=cpos2knum(cpos2,mminj);
knum3=cpos2knum(cpos3,mminj);
knum4=cpos2knum(cpos4,mminj);
knum=[knum1 knum2 knum3 knum4];
