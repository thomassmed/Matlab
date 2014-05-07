function set_matvar(hobj,eventdata)
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
matvar=inputdlg('Matlab variable','',1,cmsplot_prop.matvar_string);
cmsplot_prop.dists=[];

if ~isempty(matvar),
    cmsplot_prop.matvar_string=matvar;
    cmsplot_prop.Envelope=[];
    set(hfig,'userdata',cmsplot_prop);
    plot_matvar(matvar{1});
end
% TODO: make <CR> = OK