% Reduce full core map  to control rod value vector 
%
% crvec=cor2cr(core,mminj,irmx)
%
% Input
%   core  - core map bundle by bundle (iamax by iamax)
%   mminj - core contour vector
%   irmx   - max number of control rods (irmx by irmx) (default = iamax/2)
%
% Output
%   crvec - Control rod value for average bundle value in each supercell
% 
% Example: 
%   crvec=cr2vec(ones(30,30),mminj);
%   Note if you need to caluculate the average value in each supercell,
%   you should use: 
%   
%
% See also cr2map, crnum2crpos, crnum2knum, crpos2crnum, crpos2knum, filtcr, map2cr,
%          mminj2crmminj
function crvec=cor2cr(core,mminj,irmx)
corvec=cor2vec(core,mminj);  %dis2d
crmminj = mminj2crmminj(mminj,irmx);
ncr=sum(length(crmminj)-2*(crmminj-1));
crvec=ones(1,ncr);
kan=filtcr(crvec,mminj,irmx);
for i=1:ncr,
    crvec(i)=mean(corvec(kan(i,:)));
end
