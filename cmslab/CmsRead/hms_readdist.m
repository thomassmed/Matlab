function [dist,mminj,konrod,sym]=hms_readdist(hermes_file,distname)
% hms_readdist reads distributions from hermes data base into matlab
% 
% [dist,mminj,konrod,sym]=hms_readdist(hermes_file,distname);
%
% Input:
%   hermes_file - name of hermes_file
%   distname    - name of distribution
%
% Output:
%   dist        - distribution (dimension: kmax by kan)
%   mminj       - core contour
%   konrod      - Control rod position
%   sym         - sym ['FULL', halfcore: 'N', 'S', 'E' 'W'
%                      or quarter-core 'NE', 'NW', 'SE', 'SW']
% Examples:
% [burnup,mminj]=hms_readdist('onldist.hms','3EXP');
% hmsfile='onldist.hms';bur=readdist(hmsfile,'3EXP');
%
% See also hms_pp2_read, hms_distlist

% 
dist=hms_pp2_read(hermes_file,distname);
icor=hms_pp2_read(hermes_file,'_ICOOR');
jcor=hms_pp2_read(hermes_file,'_JCOOR');
[mminj,sym]=ij2mminj(icor,jcor);
if length(dist)>length(icor),
    kmax=hms_pp2_read(hermes_file,'MZ_KMAX','get_var');
    dist=reshape(dist,kmax,length(dist)/kmax);
end
if nargout>2,
    konrod=hms_pp2_read(hermes_file,'_CRWD2');
end
