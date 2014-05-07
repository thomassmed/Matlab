function [mminj,kan,kmax,knum,sym]=cor3D2mminj(cor3D,iafull)
% cor3D2mminj - calulates mminj, kan, kmax, knum and sym from 3D distr 
%
% [mminj,kan,kmax,knum,sym]=cor3D2mminj(cor3D,iafull)
%
% Input
%   cor3D   - True 3d distriburion
%   iafull  - span of core (typically 30 for a BWR, 15 for a PWR)
%
% Example
% [mminj,kan,kmax,knum,sym]=cor3D2mminj(cor3D,30);
%
% See also cor3D2dis3, cordis23D
%%
ijk=size(cor3D);
if length(ijk)==3,
    cor2D=mean(cor3D,3);
    kmax=ijk(3);
else
    cor2D=cor3D;
    kmax=1;
end



[ic,jc]=size(cor2D);

mminj=nan(ic,1);

%%
for i=1:ic,
    mminj(i)=jc+1-find(cor2D(i,:), 1, 'last' );
end

sym='FULL';

%%
if mminj(1)==1,
    if (ic*2)==iafull,
        mminj=[mminj(ic:-1:1);mminj];
    else
        mminj=[mminj(ic:-1:2);mminj];
    end
    sym='SE';
end

if ic>jc,
    sym='E';
end

%%
kan=sum(iafull-2*(mminj-1));
ij=knum2cpos(1:kan,mminj);
%%
switch sym
    case 'SE'
        i_ind=find( (ij(:,1)>iafull/2) & (ij(:,2)>iafull/2));
        [dum,dum,knum]=ij2mminj(ij(i_ind,1),ij(i_ind,2));
    case 'E'
        i_ind=find(ij(:,2)>iafull/2);
        [dum,dum,knum]=ij2mminj(ij(i_ind,1),ij(i_ind,2));
    case 'FULL'
        knum=(1:kan)';
end