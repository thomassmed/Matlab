function detmat=detmap2detmat(detdis,detloc,mminj)
% detmap2detmat - translates output from read_detmap
%
%  detmat=detmap2detmat(detdis,detloc,mminj)
% Input
%   detdis - Tip or detector distribution read from summary file with read_detmap
%   detloc - Detector location map fue_new.detloc
%   mminj  - Core Contour
%   
% Output
%   detmat - nax by ndet detector string values
%
% Example
%   lprmrat=read_detmap('tip.sum','LPRMRAT');
%   lprmratmat=detmap2detmat(lprmrat,fue_new.detloc,fue_new.mminj);
%
% See also read_detmap, detpos2detloc, detpos2detpos, read_restart_bin





%%
if nargin==2,
    detpos=detloc;
else
    detpos=detloc2detpos(detloc,mminj);
end
%%
detmat=nan(length(detdis),length(detpos));
for i=1:length(detdis),
    temp=cor2vec(detdis{i},mminj);
    detmat(i,:)=temp(detpos);
end