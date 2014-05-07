function dis3=cor3D2vec3D(cor3D,mminj)
% Convert true 3D distribution cor3D(i,j,k) from HDF5 to dis3(kmax,kan)
%
% dis3=cor2vec(cor3D,mminj)
%
% Input
%   cor3D - 3D distribution from HDF5
%   mminj - core contour
%
% Output
%   dis3   - matrix of values in 'classical' 3D-format
%
% Example
%   dis3=cor3D2vec3D(cor3D,mminj);
%   cmsplot s3-1.res dis3
%
%
% See also cmsplot, cor2vec, cpos2knum, ij2mminj, knum2cpos, sym_full, vec2cor
%          Control rods: mminj2crmminj

%%
n3D=size(cor3D,1);
if length(mminj)<n3D,
    cor3D(n3D,:,:)=[];
    cor3D(:,n3D,:)=[];
    kmax_2=size(cor3D,3);
    cor3D(:,:,kmax_2)=[];
    cor3D(1,:,:)=[];
    cor3D(:,1,:)=[];
    cor3D(:,:,1)=[];
end
%%
kan=sum((length(mminj)-2*(mminj-1)));
ij=knum2cpos(1:kan,mminj);
kmax=size(cor3D,3);
dis3=nan(kmax,kan);
for i=1:kan,
    dis3(:,i)=cor3D(ij(i,1),ij(i,2),:);
end