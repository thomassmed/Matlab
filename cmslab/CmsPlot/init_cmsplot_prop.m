function cmsplot_prop=init_cmsplot_prop(cmsplot_prop)
% Initialize default properties
cmsplot_prop.operator='mean';
cmsplot_prop.coordinates='ij';
cmsplot_prop.axes=1;
cmsplot_prop.plot_type='image';
%cmsplot_prop.colormap='jet_mod';
cmsplot_prop.det_strings='off';
cmsplot_prop.scale_max=1;
cmsplot_prop.scale_min=0;
cmsplot_prop.rescale='auto';
cmsplot_prop.node_plane=[];
cmsplot_prop.axis=[1 31 1 31];
cmsplot_prop.superc='on';
cmsplot_prop.crods='black';
cmsplot_prop.axplot=[];
cmsplot_prop.detectors='off';
cmsplot_prop.plotsym='FULL';
cmsplot_prop.datalabels='no';
cmsplot_prop.label_text=[];
cmsplot_prop.Envelope=[];
if ~isfield(cmsplot_prop,'matvar_plot')
    cmsplot_prop.matvar_plot=0;
end