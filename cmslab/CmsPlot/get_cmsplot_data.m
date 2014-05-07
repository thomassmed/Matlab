function get_cmsplot_data(hobj)
if nargin==0, hobj=0;end
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
if nargin>0,
    cmsplot_prop.dist_name = get(hobj,'label');
end
cmsplot_prop.matvar_plot = 0;
cmsplot_prop.Envelope='';
cmsplot_prop.dists=[];

old_filt_length=length(cmsplot_prop.filter.filt_matvar);
cmsplot_prop.if2x2=0;
distname=cmsplot_prop.dist_name;
cmsplot_prop.data = ReadCore(cmsplot_prop.coreinfo,distname,cmsplot_prop.state_point);
if iscell(cmsplot_prop.data), cmsplot_prop.data=cmsplot_prop.data{1};end

if ~strcmpi(cmsplot_prop.crods,'no')
    cmsplot_prop.konrod=ReadCore(cmsplot_prop.coreinfo,'CRD.POS',cmsplot_prop.state_point);
    if length(cmsplot_prop.konrod)==length(cmsplot_prop.coreinfo.core.crmminj),
        cmsplot_prop.konrod=cor2vec(cmsplot_prop.konrod,cmsplot_prop.coreinfo.core.crmminj);
    end
    cmsplot_prop.konrod_max=max(cmsplot_prop.konrod);
end

switch cmsplot_prop.filetype
    case  '.mat'     
        cmsplot_prop.eigvec=cmsplot_prop.data;
        cmsplot_prop.data = abs(cmsplot_prop.data);
end

if strcmp(cmsplot_prop.rescale,'newstpt')
    cmsplot_prop.rescale='hold all';
else
    cmsplot_prop.rescale='auto';
end

kmax=size(cmsplot_prop.data,1);
cmsplot_prop.node_plane=['1:',num2str(kmax)];
cmsplot_prop.kan=size(cmsplot_prop.data,2);
kan=cmsplot_prop.core.kan;
sym=cmsplot_prop.core.sym;

switch sym
    case 'FULL'
        if cmsplot_prop.core.if2x2==2&&cmsplot_prop.kan==4*kan,
            cmsplot_prop.mminj=cmsplot_prop.coreinfo.core.mminj2x2;
            cmsplot_prop.knum=cmsplot_prop.coreinfo.core.knum2x2;
            cmsplot_prop.irmx=cmsplot_prop.coreinfo.core.irmx;
            cmsplot_prop.if2x2=2;
        else
            cmsplot_prop.mminj=cmsplot_prop.coreinfo.core.mminj;
            cmsplot_prop.knum=cmsplot_prop.coreinfo.core.knum;
            cmsplot_prop.irmx=cmsplot_prop.coreinfo.core.irmx;
            cmsplot_prop.if2x2=0;
        end
    case 'SE'
        if cmsplot_prop.core.if2x2==2&&cmsplot_prop.kan==4*kan,
            cmsplot_prop.mminj=cmsplot_prop.coreinfo.core.mminj2x2;
            cmsplot_prop.knum=cmsplot_prop.coreinfo.core.knum2x2;
            cmsplot_prop.irmx=cmsplot_prop.coreinfo.core.irmx;
            cmsplot_prop.if2x2=2;
        else
            cmsplot_prop.kan=4*cmsplot_prop.kan;
            cmsplot_prop.mminj=cmsplot_prop.coreinfo.core.mminj;
            cmsplot_prop.knum=cmsplot_prop.coreinfo.core.knum;
            cmsplot_prop.irmx=cmsplot_prop.coreinfo.core.irmx;
            cmsplot_prop.if2x2=0;
        end
end

filt_length=cmsplot_prop.kan;
if filt_length~=old_filt_length,
    cmsplot_prop.filter.filt_nhyd=ones(1,filt_length);
    cmsplot_prop.filter.filt_nfta=ones(1,filt_length);
    cmsplot_prop.filter.filt_crods=ones(1,filt_length);
    cmsplot_prop.filter.filt_bat=ones(1,filt_length);
    cmsplot_prop.filter.filt_matvar=ones(1,filt_length);
    cmsplot_prop.filter.filt_matvar_string={''};
    cmsplot_prop.filter.filt_handles=[];
    cmsplot_prop.filter.filter_type=[];
end
set(hfig,'userdata',cmsplot_prop);
