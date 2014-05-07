% Translate from symmetric distribution to full core
%
% full_dist=sym_full(sym_dist,knum);
%
% Input
%   sym_dist - distribution in core symmetry (kmax by ncc)
%   knum     - matrix where first column are the (full core) channel numbers for the
%              symmetric distribution, the following columns contain the
%              channel numbers for the symmetric bundles
%
% Output 
%   full_dist - Full core distribution (kmax by kan)
%
% Example
%   ia and ja are vectors of i and j-index for the symmetry, sym_dist the
%   corresponding distribution, where each column contains the axial shape
%   for the channel
%   [mminj,sym,knum]=ij2mminj(ia,ja);
%   full_dist=sym_full(sym_dist,knum);
%
% Example 2:
%  matstab s3k-1.inp
%  load s3k-1.mat
%  Alfa=sym_full(steady.alfa);
%  cmsplot s3-1.res Alfa
%
% See also cor2vec, cpos2knum, ij2mminj, knum2cpos, sym_full, vec2cor
%          Control rods: mminj2crmminj

function full_dist=sym_full(dist,knum,harm)
if nargin <2,
    global geom
    knum=geom.knum;
end
if nargin<3,
    harm=0;
end

if ~iscell(dist)
    kan=max(knum(:));
    kmax=size(dist,1);
    full_dist=zeros(kmax,kan);
    for i=1:size(knum,2),
        full_dist(:,knum(:,i))=dist;
        if harm&&i==2,
            full_dist(:,knum(:,i))=-dist;
        end
    end
else
    [id,jd]=size(dist);
    if min(id,jd)==1,
        kan=max(knum(:));
        full_dist=cell(kan,1);
        for i=1:size(knum,2),
            full_dist(knum(:,i))=dist;
        end
    else
        full_dist=cell(id,jd);
        for i=1:id,
            for j=1:jd
                for i1=1:size(knum,2),
                    full_dist{i,j}(:,knum(:,i1))=dist{i,j};
                end
            end
        end
    end
end