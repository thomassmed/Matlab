function cor3D=cordis23D(dis3,mminj,opt)
% Convert  dis3(kmax,kan) true 3D distribution cor3D(i,j,k)
%
% cor3D=cor3D2dis3(dis3,mminj)
%
% Input
%   dis3   - matrix of values in 'classical 3D-format' (kmax by kan)
%   mminj  - core contour
%   opt    - 'ijk'|'kij'|'kji' 
%
% Output
%   cor3D - 3D distribution from HDF5
%
% Example
%   cor3D=cordis23D(dis,mminj);
%
%
% See also cmsplot, cor2vec, cpos2knum, ij2mminj, knum2cpos, sym_full, vec2cor, cor3D2dis3
%          Control rods: mminj2crmminj

if nargin<3, opt='ijk';end
[kmax,kan]=size(dis3);
iafull=length(mminj);
%%
ij=knum2cpos(1:kan,mminj);
switch lower(opt)
    case 'ijk'
        cor3D=zeros(iafull,iafull,kmax);
        for i=1:kan,
            cor3D(ij(i,1),ij(i,2),:)=dis3(:,i);
        end
    case 'kij'
        cor3D=zeros(kmax,iafull,iafull);
        for i=1:kan,
            for k=1:kmax
                cor3D(k,ij(i,1),ij(i,2))=dis3(k,i);
            end
        end
    case 'kji'
        cor3D=zeros(kmax,iafull,iafull);
        for i=1:kan,
            for k=1:kmax      
                cor3D(k,ij(i,2),ij(i,1))=dis3(k,i);
            end
        end        
end
