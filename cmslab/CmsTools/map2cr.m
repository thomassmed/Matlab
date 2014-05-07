% Convert control rod value map to control rod value vector
%
% Input 
%   map   - control rod value matrix
%   mminj - core contour
%
% Output
%   konrod - control rod value vector
%
% Example
%   map=ones(15,15);
%   konrod=map2cr(map,mminj); % Sort of silly example, but map might be
%                             % read from s3 output or some other place
%
% See also cor2cr, crnum2crpos, crnum2knum, crpos2crnum, cr2map, crpos2knum, filtcr,
%          mminj2crmminj
function konrod=map2cr(map,mminj)
irmx=size(map,1);
[crmminj, n_cr]=mminj2crmminj(mminj,irmx);
konrod=zeros(1,n_cr);
icount=0;
iacrmax=length(crmminj);
for i=1:iacrmax,
    for j=crmminj(i):(iacrmax-crmminj(i)+1),
        icount=icount+1;
        konrod(icount)=map(i,j);
    end
end