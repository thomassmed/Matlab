function [chan_num] = pos2chan_num(corpos, min_j, pos_type)
% pos2chan_num - calculates bundle channel numbers surrounding a cr or detector 
%
% chan_num = pos2chan_num(corpos, min_j, pos_type)
%
% Input:
% corpos         - array contining the core i,j indeces of the item
% min_j          - 1 x ncore array of bundle starting position in each core row
% pos_type       - 1 (CRDs) or 2 (DETs), default=1
% Output:
% chan_num       - array containing the bundle numbers of the four bundles surrounding the item

if nargin<3, pos_type=1;end
v = ones(size(corpos, 1), 1);                   % an array of ones for subtracting from the indeces

if (pos_type == 1)      % crds
    cpos_se = 2 * corpos;                           % southeast bundle number
    cpos_sw = [cpos_se(:,1) cpos_se(:,2) - v];      % southwest bundle number
    cpos_nw = [cpos_se(:,1) - v cpos_se(:,2) - v];  % northwest bundle number
    cpos_ne = [cpos_se(:,1) - v cpos_se(:,2)];      % northeast bundle number
elseif (pos_type == 2)  % dets
    cpos_se = 2 * corpos;                           % southeast bundle number
    cpos_sw = [cpos_se(:,1) cpos_se(:,2) - v];      % southwest bundle number
    cpos_nw = [cpos_se(:,1) - v cpos_se(:,2) - v];  % northwest bundle number
    cpos_ne = [cpos_se(:,1) - v cpos_se(:,2)];      % northeast bundle number
end

chan_num_nw = cpos2knum(cpos_nw, min_j);    % northwest channel number
chan_num_ne = cpos2knum(cpos_ne, min_j);    % northeast channel number
chan_num_sw = cpos2knum(cpos_sw, min_j);    % southwest channel number
chan_num_se = cpos2knum(cpos_se, min_j);    % southeast channel number
chan_num = [chan_num_nw chan_num_ne chan_num_sw chan_num_se];