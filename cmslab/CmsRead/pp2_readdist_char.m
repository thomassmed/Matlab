function dist=pp2_readdist_char(sock,dnam)
% Reads character distributions from hermes file
%
% dist=pp2_readdist(sock,dnam)
%
% Input
%   sock  - socket handle
%   dname - distribution name
%
% Output
%   dist  - distribution
%
% Examples:
%  sock=pp2_server_start('onldist.hms');
%  serial=pp2_readdist_char(sock,'ASYID');
%
% See also cmsplot, pp2_command, pp2_readdist, pp2_server_start 

%%
dnam=upper(dnam);
pp2_command(sock,['do get_dist ',dnam]);
%%
fid=fopen('pp2out.txt','r');
dist=fgetl(fid);
for i=1:1000,
   dd=fgetl(fid);
   if dd==-1, break; end
   dist=str2mat(dist,dd);
end


