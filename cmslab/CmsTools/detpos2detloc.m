function detloc=detpos2detloc(detpos,mminj)
% detloc2detpos - translates detector position by fuel channel number to DET.LOC map
%
% detloc=detpos2detloc(detpos,mminj)
%
% Input:
%   detpos - detpos - chnumber for NW channel close to detector
%   mminj  - Core contour
%   Alternate input: fue_new (which contains fue_new.detloc and fue_new.mminj)
%
% Output:
%   detloc - detector location map
%
% Example:
%   detloc=detlpos2detloc(detpos,mminj);
%
% See also read_restart_bin, cor2vec, cpos2knum, ij2mminj, knum2cpos, vec2cor

% Written: Thomas Smed 2009-05-04
ll=length(mminj);
kan=sum(ll-2*(mminj-1));
if length(detpos)==kan,
    detpos1=detpos;
    detpos=zeros(max(detpos1),1);
    for i=1:max(detpos1),
        detpos(i)=find(detpos1==i,1);
    end
end
        
%%
detloc=zeros(ll/2-1);
ij=knum2cpos(detpos,mminj);
for i=1:length(detpos),
    idet=ij(i,1)/2;jdet=ij(i,2)/2;
    detloc(idet,jdet)=i;
end