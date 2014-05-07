function prep_new_data

hfig = gcf;
hobj = gcbo;

cmsplot_prop = get(hfig, 'userdata');

switch (cmsplot_prop.filetype)
    case {'.h5', '.hdf5'}
        dname = cmsplot_prop.dist_name;
    otherwise
        dname=get(hobj,'label');
end
cmsplot_prop.dist_name = dname;
cmsplot_prop.matvar_plot = 0;
get_cmsplot_data;

cmsplot_now;