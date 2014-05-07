%% Get metadata from sim-dep.sum
suminfo=ReadCore('sim-dep.sum');
%% Read in FLC 2D MAP from sim-dep.sum
FLC=ReadCore(suminfo,'FLC 2D MAP');
%% convert FLC in state point 7 to a map
flcmap=vec2cor(FLC{7},suminfo.core.mminj)
%% Find flcmax
flmax=nan(length(FLC),1);
for i=1:length(FLC),
    flmax(i)=max(FLC{i});
end
plot(flmax)
%% 
burnup=ReadCore(suminfo,'EXP 2D MAP');
%% Read from cmsfile
cmsinfo=ReadCore('sim-dep.cms');
lhg3=ReadCore(cmsinfo,'3LHG');
exp3=ReadCore(cmsinfo,'3EXP');
flp3=ReadCore(cmsinfo,'3FLP');
nft=ReadCore(cmsinfo,'NFT');
%% limits for different fuel types
nftlist=unique(nft)

