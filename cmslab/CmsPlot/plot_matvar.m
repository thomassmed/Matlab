function plot_matvar(matvar_for_plot,plotta)
% plots a matlab variable in a cms_plot window 
%
% plot_matvar(varname)
%
% input 
%    varname - variable name
%
% Example:
%  cmsplot sim-tip.cms
%  cmsinfo=read_cms('sim-tip.cms');
%  rpf3=read_cms_dist(cmsinfo,'3RPF');
%  plot_matvar(rpf3{1})


if nargin<2, plotta=true;end

if nargin==0,   % This is the case if plot_matvar is called from get_matvar
    windata=get(gcf,'userdata'); % Get the handles that are set in get_matvar
    hfig=windata(1);
    matvar_for_plot=get(windata(2),'string');
    cmsplot_prop=get(hfig,'userdata');  % This is to preserve the string the next time the window is opened
    set(cmsplot_prop.handles(6),'userdata',matvar_for_plot);
    delete(gcf);
    figure(hfig);
else
    hfig=gcf;
    cmsplot_prop=get(hfig,'userdata');
end

if ischar(matvar_for_plot),
    cmsplot_prop.dist_name=matvar_for_plot;
    cmsplot_prop.matvar_plot=1;
    evalin('base',['matvar_for_plot=',matvar_for_plot,';save matvar_for_plot matvar_for_plot']);
    load matvar_for_plot
    delete matvar_for_plot.mat
else
    cmsplot_prop.dist_name=inputname(1);
end
cmsplot_prop.rescale='auto';
cmsplot_prop.data=matvar_for_plot;
cmsplot_prop.kan=size(matvar_for_plot,2);
kan=cmsplot_prop.core.kan;
switch cmsplot_prop.core.sym
    case 'FULL'
        if cmsplot_prop.core.if2x2==2&&cmsplot_prop.kan==4*kan,
            cmsplot_prop.mminj=cmsplot_prop.core.mminj2x2;
            cmsplot_prop.knum=cmsplot_prop.core.knum2x2;
            cmsplot_prop.irmx=cmsplot_prop.core.irmx;
        else
            cmsplot_prop.mminj=cmsplot_prop.core.mminj;
            cmsplot_prop.knum=cmsplot_prop.core.knum;
            cmsplot_prop.irmx=cmsplot_prop.core.irmx;
        end
    case 'SE'
        %To be implemented
end
filt_length=cmsplot_prop.kan;
cmsplot_prop.filter.filt_nhyd=ones(1,filt_length);
cmsplot_prop.filter.filt_nfta=ones(1,filt_length);
cmsplot_prop.filter.filt_crods=ones(1,filt_length);
cmsplot_prop.filter.filt_bat=ones(1,filt_length);
cmsplot_prop.filter.filt_matvar=ones(1,filt_length);
cmsplot_prop.filter.filt_matvar_string={''};
cmsplot_prop.filter.filt_handles=[];
cmsplot_prop.filter.filter_type=[];
set(hfig,'userdata',cmsplot_prop);  
cmsplot_prop.rescale='auto';
cmsplot_prop.matvar_plot=1;
set(gcf,'userdata',cmsplot_prop);
if plotta,
    cmsplot_now;
end
