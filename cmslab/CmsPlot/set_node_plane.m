function set_node_plane
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
kmax=cmsplot_prop.coreinfo.core.kmax;
if isfield(cmsplot_prop,'subnodedata') && length(cmsplot_prop.knums) == 1
    def_answr=length(cmsplot_prop.geoms{cmsplot_prop.knums});
else
    def_answr=cmsplot_prop.coreinfo.core.kmax;
end
nod=inputdlg('Enter node planes','Node plane',1,{['1:' num2str(def_answr)]});
if ~isempty(nod)
    if isfield(cmsplot_prop,'subnodedata')
        nods = regexp(nod{1},':','split');
        lenghttest = regexp(nod,':');
        if isempty(lenghttest{1})
            nod1 = str2double(nods{1});
            set_cmsplot_prop('nod_plane',[nod1 nod1]);
        else
            nod1 = str2double(nods{1});
            nod2 = str2double(nods{2});
            set_cmsplot_prop('nod_plane',[nod1 nod2]);
        end
        PlotSubMeshData;
    else
        set_cmsplot_prop('node_plane',nod{1});
        set_cmsplot_prop('rescale','auto')
        cmsplot_now;
    end
end
