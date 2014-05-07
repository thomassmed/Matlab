function filename=get_cmsplotfile
hfig=gcf;
cmsplot_prop_old=get(hfig,'userdata');
[filename,pathname]=uigetfile({'*.res;*.mat;*.hms;*.h5;*.hdf5;*.out;*.sum;*.dat;*.cms','CMS-files (*.cms,*.res,*.mat,*.hms,*.h5,*.hdf5,*.out,*.sum,*.dat)';...
'*.cms','cms-files (*.cms)';...
'*.res','Restart-files (*.res)';...
'*.out','Output-files (*.out)';...
'*.sum','Output-files (*.sum)';...
'*.mat','Files saved by Matstab (*.mat)';...
'*.hms','Hermes Files (*.hms)';...
'*.h5;*.hdf5','Database files {*.h5, *.hdf5)';...
'*.dat','Polca Distribution files (*.dat)';...
'*.*', 'All files (*.*)'},...
'Pick a file',cmsplot_prop_old.filename);
cmsplot_prop.handles=cmsplot_prop_old.handles;
cmsplot_prop.data_handles=cmsplot_prop_old.data_handles;
cmsplot_prop.case_handles=cmsplot_prop_old.case_handles;
if filename~=0,
    filename=[pathname,filename];
    [PATHSTR,NAME,EXT] = fileparts(filename);
    cmsplot_prop.filename=filename;
    cmsplot_prop.filetype=EXT;
    cmsplot_prop=init_cmsplot_prop(cmsplot_prop);
    cmsplot_prop.handles=cmsplot_window(cmsplot_prop.filetype,cmsplot_prop.handles);
    set(hfig,'userdata',cmsplot_prop);
    cmsplot_init;
    if strcmp(EXT,'.mat'), get_cmsplot_data; end
    cmsplot_now;
end

%{
[PATHSTR,NAME,EXT] = fileparts(filename);
    HDF5_old=strcmp(cmsplot_prop.filetype, '.h5') || strcmp(cmsplot_prop.filetype, '.hdf5');
    HDF5_new=strcmp(EXT, '.h5') || strcmp(EXT, '.hdf5');
    cmsplot_prop.filename=filename;
    cmsplot_prop.filetype=EXT;
    if ~HDF5_new && ~HDF5_old,
        set(hfig,'userdata',cmsplot_prop);
        cmsplot_init;
        if strcmp(EXT,'.mat'), get_cmsplot_data; end
        cmsplot_now;
    elseif HDF5_new && ~HDF5_old
        h=cmsplot_prop.handles;
        delete(h(10,3));delete(h(10,1));
        h(10,3)=axes('position',[0.95 0.05 0.05 0.87]);
        h(10,4)=plot([0.1 0.1],'visible','off');
        h(10,1)=axes('position',[0.28 0.05 0.62 0.87]);
        cmsplot_prop.handles=h;
        set(hfig,'userdata',cmsplot_prop);
        h5filetree(filename);
        cmsplot_init;
    elseif HDF5_new && HDF5_old
        set(hfig,'userdata',cmsplot_prop);
        h5filetree(filename);
        cmsplot_init;
    elseif ~HDF5_new && HDF5_old
        h=cmsplot_prop.handles;
        delete(h(10,3));delete(h(10,1));
        delete(cmsplot_prop.scrollPanel);
        h(10,1)=axes('position',[0.03 0.05 0.79 0.87]);
        h(10,3)=axes('position',[0.90 0.05 0.09 0.87]);
        h(10,4)=plot([0.1 0.1],'visible','off');
        cmsplot_prop.handles=h;
        set(hfig,'userdata',cmsplot_prop);
        cmsplot_init;
        if strcmp(EXT,'.mat'), get_cmsplot_data; end
        cmsplot_now;
    end
end
%}