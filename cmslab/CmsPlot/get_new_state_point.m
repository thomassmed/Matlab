function get_new_state_point(i)
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
cmsplot_prop.state_point=i;
cmsplot_prop.xpo=cmsplot_prop.Xpo(i);
if ~strncmp(cmsplot_prop.crods,'no',2),
    cmsplot_prop.konrod = ReadCore(cmsplot_prop.coreinfo,'CRD.POS',i);
    if length(cmsplot_prop.konrod)==length(cmsplot_prop.coreinfo.core.crmminj),
        cmsplot_prop.konrod=cor2vec(cmsplot_prop.konrod,cmsplot_prop.coreinfo.core.crmminj);
    end
end

if cmsplot_prop.matvar_plot,
    warning('Changing state point not applicable for matlab variable, Only control rod pattern updated')
    set(hfig,'userdata',cmsplot_prop);
    cmsplot_now;
    return;
end
   

cmsplot_prop.data=ReadCore(cmsplot_prop.coreinfo,cmsplot_prop.dist_name,i);
if iscell(cmsplot_prop.data), cmsplot_prop.data=cmsplot_prop.data{1};end

if strcmp(cmsplot_prop.rescale,'hold all')||strcmpi(cmsplot_prop.rescale,'newstpt')
    cmsplot_prop.rescale='newstpt';
else
    cmsplot_prop.rescale='auto';
end

set(hfig,'userdata',cmsplot_prop);

% if ~cmsplot_prop.matvar_plot&&~strcmpi(cmsplot_prop.filetype,'.out')
%     get_cmsplot_data;
% end
cmsplot_now(hfig);