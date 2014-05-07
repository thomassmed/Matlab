function [Adapt, AW] = adapt(mminj, detpos, W, tiprat, gardel_style)

%[Adapt, AW] = adapt(mminj, detpos, W, tiprat)

% Input:
% mminj     - 1 x n vector containing the bundle starting columns for each core row
% detpos    - 1 x n vector containing the channel numbers of the detectors
% W         - 5 x 5 array of weighting factors for the bundles surrounding the detectors
% tiprat    - num_axial_points x num_tips matrix containing ratio of measured-to-calculated values

% Output:
% Adapt     - num_axial_points x num_bundles array containing 
% AW        - num_axial_points x num_bundles array containing each bundle's total adaption weighting factor

%%
[maxdist,dummy]=size(W);
if nargin<5,
    if maxdist<6, 
        gardel_style=0; % assume simulate style
    else
        gardel_style=1;
    end
end
if gardel_style,maxdist=maxdist+.1;end
maxdist2=maxdist*maxdist;
ll = length(mminj);   % total number of core rows
knum = sum( ll - 2 * (mminj - 1) ); % total number of channels
no_meas_nod = size(tiprat, 1);  % number of axial tip measurements
Adapt = zeros(no_meas_nod, knum);   % make an empty array for the adapted values
AW = zeros(no_meas_nod, knum);  % make an empty array for the bundlewise weighting factors
Detpos = knum2cpos(detpos, mminj);  % convert the detector channel numbers to core positions
Detposi = Detpos(:, 1) + 0.5;   % make the detectors in the middle of the core positions for weighting
Detposj = Detpos(:, 2) + 0.5;   % make the detectors in the middle of the core positions for weighting
Cpos = knum2cpos(1 : knum, mminj);  % convert the bundle channel numbers to core positions

%%
% loop over the number of bundles
for i = 1 : knum
    dx = Cpos(i, 1) - Detposi;  % calculate the distance (in bundles) from the current bundle to each detector
    dy = Cpos(i, 2) - Detposj;  % calculate the distance (in bundles) from the current bundle to each detector
    if gardel_style,
        idet = find( (dx.*dx+dy.*dy) < maxdist2 ); % find the detectors that are in range from the current bundle
    else
        idet = find (abs(dx)<maxdist & abs(dy)<maxdist); % Simulate style
    end
    % loop over the detectors that are in range from the current bundle
    for j = 1 : length(idet)
        iw = round( abs( dx(idet(j)) ) + 0.5 ); % determine how many whole bundles away the current bundle is from the detector
        jw = round( abs( dy(idet(j)) ) + 0.5 ); % determine how many whole bundles away the current bundle is from the detector
        AW(:, i) = AW(:, i) + W(iw, jw);        % add the weights of the current detector to the bundle's total weighting array
        Adapt(:, i) = ( Adapt(:, i) + W(iw, jw) * tiprat(:, idet(j)) )';    % add the adaption factors from this detector to the bundle's total adaption array
    end
end
Adapt = Adapt ./ (AW + eps);    % this is [sum(tiprat*w) / sum(w)] or the total adaption factor applied to a bundle axially