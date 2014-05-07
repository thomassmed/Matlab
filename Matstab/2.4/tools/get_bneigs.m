function k = get_bneigs
% k = get_bneigs
%
% Returns bypass neighbours for all channel nodes



global geom
ncc=geom.ncc;

j = get_bnodes;j(1)=[];
k = ones(ncc,1)*j;
k = k(:)';
