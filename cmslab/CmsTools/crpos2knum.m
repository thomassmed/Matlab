% Translates from cr position to channel number
%
%
% knum=crpos2knum(crpos,mminj,irmx)
% knum=crpos2knum(cri,crj,mminj,irmx)
%
% Example
% 
%   knum=crpos2knum([7,7;7,8],mminj,irmx); These three calls give same result
%   knum=crpos2knum([7 7],[7 8],mminj,irmx);
%   knum=crpos2knum([7;7],[8;8],mminj,irmx);
%
% See also cor2cr, crnum2crpos, crnum2knum, crpos2crnum, cr2map, filtcr, map2cr,
%          mminj2crmminj
function knum=crpos2knum(varargin)
if nargin==3, 
    crpos=varargin{1};
    mminj=varargin{2};
    irmx=varargin{3};
elseif nargin==4,
    cri=varargin{1};
    crj=varargin{2};
    mminj=varargin{3};
    irmx=varargin{4};
    crpos=[cri(:) crj(:)];
else
    error('Number of input arguments has to be 3 or 4');
end

cpos4=2*crpos+length(mminj)/2-irmx;
cpos1=[cpos4(:,1)-1 cpos4(:,2)-1];
cpos2=[cpos4(:,1)-1 cpos4(:,2)];
cpos3=[cpos4(:,1) cpos4(:,2)-1];
knum1=cpos2knum(cpos1,mminj);
knum2=cpos2knum(cpos2,mminj);
knum3=cpos2knum(cpos3,mminj);
knum4=cpos2knum(cpos4,mminj);
knum=[knum1 knum2 knum3 knum4];
