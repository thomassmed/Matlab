function remove_filter
hfig=gcf;
cmsplot_prop=get(gcf,'userdata');
kan=cmsplot_prop.core.kan;
cmsplot_prop.filter.filt_nhyd=ones(size(cmsplot_prop.filter.filt_nhyd));
cmsplot_prop.filter.filt_nfta=ones(size(cmsplot_prop.filter.filt_nfta));
cmsplot_prop.filter.filt_bat=ones(size(cmsplot_prop.filter.filt_bat));
cmsplot_prop.filter.filt_matvar=ones(size(cmsplot_prop.filter.filt_matvar));
cmsplot_prop.filter.filt_crods=ones(size(cmsplot_prop.filter.filt_crods));

fig_numbers=get(0,'children');
for i=1:length(cmsplot_prop.filter.filt_handles),
    if ~isempty(find(fig_numbers==cmsplot_prop.filter.filt_handles(i), 1)), %Only delete window if it still exist!
        delete(cmsplot_prop.filter.filt_handles(i));
    end
end

cmsplot_prop.filter.filt_handles=[];
cmsplot_prop.rescale='auto';

set(gcf,'userdata',cmsplot_prop);

cmsplot_now;