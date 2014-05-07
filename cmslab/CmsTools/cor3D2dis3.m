function dis3=cor3D2dis3(cor3D,mminj,knum,sym)
% Convert true 3D distribution cor3D(i,j,k) from HDF5 to dis3(kmax,kan)
%
% dis3=cor3D2dis3(cor3D,mminj)
%
% Input
%   cor3D - 3D distribution from HDF5
%   mminj - core contour
%
% Output
%   dis3   - matrix of values in 'classical 3D-format' (kmax by kan)
%
% Example
%   dis3=cor3D2dis3(cor3D,mminj);
%   cmsplot s3-1.res dis3
%
%
% See also cmsplot, cor2vec, cpos2knum, ij2mminj, knum2cpos, sym_full, vec2cor
%          Control rods: mminj2crmminj

if length(mminj)==1,
    iafull=mminj;
    [mminj,kan,kmax,knum,sym]=cor3D2mminj(cor3D,iafull);
end


kan=sum((length(mminj)-2*(mminj-1)));

if size(cor3D,1)==kan,
    dis3=cor3D';
    return
elseif size(cor3D,2)==kan,
    dis3=cor3D;
    return
end

if exist('sym','var'),
    pad = zeros(size(cor3D));
    ijk=size(cor3D);
    switch (sym)
        case 'SE'
            if ijk(1)<length(mminj)
                cor3D=[pad pad; pad cor3D];
            end
            if size(cor3D,1)>length(mminj),
                cor3D(1,:,:)=[];
            end
            if size(cor3D,2)>length(mminj),
                cor3D(:,1,:)=[];
            end            
        case 'NE'
            cor3D=[pad cor3D; pad pad];
        case 'SW'
            cor3D=[pad pad; cor3D pad];
        case 'NW'
            cor3D=[cor3D pad; pad pad];
        case 'E'
            cor3D=[pad cor3D];
        case 'W'
            cor3D=[cor3D pad];
        case 'N'
            cor3D=[cor3D; pad];
        case 'S'
            cor3D=[pad; cor3D];
    end
end
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
ij=knum2cpos(1:kan,mminj);
if ~exist('kmax','var'),
    kmax=size(cor3D,3);
end

dis3=nan(kmax,kan);
for i=1:kan,
    dis3(:,i)=cor3D(ij(i,1),ij(i,2),:);
end

if exist('sym','var'),
    for i=2:size(knum,2),
        dis3(:,knum(:,i))=dis3(:,knum(:,1));
    end
end