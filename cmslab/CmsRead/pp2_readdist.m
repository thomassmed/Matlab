function [dist,mminj]=pp2_readdist(sock,dnam,mminj)
% Reads distributions from hermes file
%
% [dist,mminj]=pp2_readdist(sock,dnam,mminj)
%
% Input
%   sock  - socket handle
%   dname - distribution name
%   mminj - core contour shape (not neccesary, but faster)
%
% Output
%   dist  - distribution
%   mminj - Core shape
%   sym   - symmetry
%
% Examples:
%  sock=pp2_server_start('onldist.hms');
%  power=pp2_readdist(sock,'3rpf');
%
% See also cmsplot, pp2_command, pp2_server_start 

%%
dnam=upper(dnam);
dist=pp2_command(sock,['do get_dist ',dnam]);
%% Core shape
if nargin<3,
    mmax_minj=pp2_command(sock,'DO GET_HARRAY CSHAPE');
    mminj=mmax_minj(1:2:end);
end
kan=sum(length(mminj)-2*(mminj-1));
%% if dist is 3d, reshape
if length(dist)>kan,
    kmax=pp2_command(sock,'do get_var2 MZ_KMAX');
    dist=reshape(dist,kmax,length(dist)/kmax);
end


