function outdat = fill2x2(data,mminj,knum,sym,opt)
% fill2x2 is used to create a 2x2 vector or matrix from a 1x1 distribution
% 
%   outdat = fill2x2(data,mminj,knum)
%   outdat = fill2x2(data,mminj,knum,sym)
%   outdat = fill2x2(data,mminj,knum,sym,opt)
%
% Input
%   data        - 1x1 data to expand
%   mminj       - core conture
%   knum        - list of channel numbers
%   sym         - symmetry wanted (default: 'full')
%   opt         - 'vec' for verctor output, 'mat' for matrix output
%   (default: 'vec')
%   
% Output
%   outdat      - 2x2 distribution
% 
% See also convert2x2

% Mikael Andersson 2012-04-06

if nargin < 4
    sym = 'FULL';
    knum = 1:max(knum(:));
elseif nargin > 3 && strcmpi(sym,'FULL') && size(knum,2) ~=1
    knum = 1:max(knum(:));
end
if nargin ~=5
    opt = 'vec';
end
    
[coremap mminj2x2] = convert2x2('2core',knum,mminj,sym);
subnum = convert2x2('2subnum',knum,mminj,sym);
datmat = zeros(size(coremap));
for i = 1:size(subnum,1)
    logic = subnum(i,1) ~=0 & coremap == subnum(i,1)  | subnum(i,2) ~=0 & coremap == subnum(i,2) | subnum(i,3) ~=0 & coremap == subnum(i,3) | subnum(i,4) ~=0 & coremap == subnum(i,4);
    datmat(logic) = data(i);
end

if strcmp(opt,'mat')
    outdat = datmat;
else
    outdat = cor2vec(datmat,mminj2x2);
end


