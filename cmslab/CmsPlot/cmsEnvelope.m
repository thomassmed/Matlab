function dut=cmsEnvelope(fcn,din)
% Creates an envelope from a cell array of distributions
%
% distut=cmsEnvelope(fcn,distin)
%
% Input
%   fcn     - handle of envelop function, eg @max, @min
%   distin  - cell array of input distributions
%
% Output
%   distout  - cell array of output distributions
%
% Example:
%  cmsinfo=read_cms('sim-dep.cms');
%  rpf2=read_cms_dist(cmsinfo,'2RPF');
%  rpfmaxenv=cmsEnvelope(@max,rpf2)
%
% See also cmsplot

% This line will not be echoed
if nargout==0
    hfig=gcf;
    if nargin<1, fcn=@max;end
    cmsplot_prop=get(hfig,'userdata');
    dist = ReadCore(cmsplot_prop.coreinfo,cmsplot_prop.dist_name,1:cmsplot_prop.state_point);
    if iscell(dist)
        if iscell(dist{1})
            tempdist = cell(length(dist),1);
            for i = 1:length(dist)
                tempdist{i} = cell2mat(cellfun(fcn,dist{i},'uniformoutput',0));
            end
        else
            tempdist = cellfun(fcn,dist,'uniformoutput',0)';
        end
        distut = fcn(cell2mat(tempdist));
    else
        distut = fcn(dist);
    end
else
    dist=din;
    distut=dist;

    for i=2:length(dist),
        distut{i}=fcn(dist{i},distut{i-1});
    end
end

%%


if nargout==0
    cmsplot_prop.data=distut;
%     cmsplot_prop.dists=distut;
    cmsplot_prop.Envelope='Env ';
    cmsplot_prop.rescale='auto';
    set(hfig,'userdata',cmsplot_prop);
    cmsplot_now;
else
    dut=distut;
end