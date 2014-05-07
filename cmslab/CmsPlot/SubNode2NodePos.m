function datpos = SubNode2NodePos(geom,hz,kmax)
% function datpos = SubNode2NodePos(geom,hz,kmax)
%
% Input:
%   geom    - vector or cell array with axial length of subnodes
%   hz      - the height of a node
%   kmax    - number of axial nodes
%
% Output:
%   datpos  - cell array with index of which subnodes belongs to each node
%
% Example: 
%   resinfo = ReadRes('S5.res');
%   subgeoms = ReadRes(resinfo,'Subnode geometry');
%   datpos = SubNode2NodePos(subgeoms,hz,kmax);
%
% See also ReadRes

% Mikael Andersson 2011-12-10
if ~iscell(geom)
    geom = {geom};
end
datpos = cell(size(geom));
for l = 1:length(geom)
    pos = 1;
    for i = 1:kmax
        cs = cumsum(geom{l}(pos:end));
        nodpos = find((cs-hz)<=1e-6);
        datpos{l}(pos+nodpos-1) = i;
        pos = pos + max(nodpos);
    end
end
