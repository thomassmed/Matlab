function cmsplot_init

hfig=gcf;
set(hfig,'Pointer','watch');drawnow;
cmsplot_prop=get(hfig,'userdata');
handles=cmsplot_prop.handles;

filename=cmsplot_prop.filename;
set(hfig,'name',filename);
cmsplot_prop.new_axes=1;
cmsplot_prop.filetype=['.',identfile(filename)];
coreinfo=ReadCore(filename);
cmsplot_prop.coreinfo=coreinfo;
cmsplot_prop.core = coreinfo.core;
Xpo = coreinfo.Xpo;
cmsplot_prop.Xpo = Xpo;
cmsplot_prop.xpo = coreinfo.Xpo(1);
cmsplot_prop.distlist=get_distlist(cmsplot_prop);
cmsplot_prop.state_point=1;
if ~cmsplot_prop.matvar_plot,
    cmsplot_prop.dist_name=GetDistName(coreinfo,'POWER');
    if isempty(cmsplot_prop.dist_name),
        cmsplot_prop.dist_name=cmsplot_prop.coreinfo.distlist{1};
    end
end
cmsplot_prop.rescale='auto';
cmsplot_prop.axis=[1 coreinfo.core.iafull+1 1 coreinfo.core.iafull+1];
cmsplot_prop.restart=filename;
cmsplot_prop.titmat=cmsplot_prop.coreinfo.fileinfo.fullname;
if strcmp(coreinfo.core.lwr,'PWR'),
    cmsplot_prop.crods='no';
else
    cmsplot_prop.crods='black';
    if isfield(coreinfo.core,'detloc')
        [jdet,idet]=find(coreinfo.core.detloc);
        off_set=length(coreinfo.core.mminj)/2-coreinfo.core.irmx;
        idet=2*idet+1-off_set;
        jdet=2*jdet+1-off_set;
        cmsplot_prop.idet=idet;
        cmsplot_prop.jdet=jdet;
        detlocT=coreinfo.core.detloc';
        cmsplot_prop.ndet=detlocT(find(detlocT));
    end
end

switch cmsplot_prop.filetype
    case '.res'
        axislabels = ReadCore(coreinfo,'axis labels',1);
        if axislabels.asslabs || axislabels.sclabs
            if axislabels.asslabs
                cmsplot_prop.handles(3,19)=uimenu(cmsplot_prop.handles(5,17),'label','Plant Specific','callback','set_cmsplot_prop coordinates pltspc; cmsplot_now;');
                cmsplot_prop.axlabels.assemlabs.lab1 = axislabels.ax1;
                cmsplot_prop.axlabels.assemlabs.lab2 = axislabels.ax2;
            end
            if axislabels.sclabs
                cmsplot_prop.handles(3,20)=uimenu(cmsplot_prop.handles(5,17),'label','Plant Supercell','callback','set_cmsplot_prop coordinates pltsc; cmsplot_now;');
                cmsplot_prop.axlabels.sclabs.lab1 = axislabels.sc1;
                cmsplot_prop.axlabels.sclabs.lab2 = axislabels.sc2;
            end
        end
        Title = ReadRes(coreinfo,'Title',1);
        [ititle,xpo,acycle,versn,jobnam,iheadr]=unfold_restart_title(Title);
        cmsplot_prop.titcas=ititle;
        if coreinfo.fileinfo.Sim == 5
            cmsplot_prop.subgeom = ReadRes(coreinfo,'subnode geometry',1);
            if ~strcmpi(cmsplot_prop.core.sym,'full')
                if cmsplot_prop.core.if2x2 == 2
                    cmsplot_prop.subgeom=check_dist(cmsplot_prop.subgeom,coreinfo.core.mminj2x2,coreinfo.core.knum2x2,coreinfo.core.sym,5);
                else
                    cmsplot_prop.subgeom=check_dist(cmsplot_prop.subgeom,coreinfo.core.mminj,coreinfo.core.knum,coreinfo.core.sym,5);
                end
            end          
        end
        cmsplot_prop.hz = coreinfo.core.hz;
        cmsplot_prop.hcore = coreinfo.core.hcore;
   case  '.mat'
        cmsplot_prop.dist_name='evoid';
        cmsplot_prop.titmat=['Matstab for ',coreinfo.fileinfo.fullname];
%% 
    case '.cms'
        cmsplot_prop.handles(3,19)=uimenu(cmsplot_prop.handles(5,17),'label','Plant Specific','callback','set_cmsplot_prop coordinates pltspc; cmsplot_now;');
        cmsplot_prop.axlabels.assemlabs.lab1 = coreinfo.constants.Values{11};
        cmsplot_prop.axlabels.assemlabs.lab2 = coreinfo.constants.Values{10};
        cmsplot_prop.handles(3,20)=uimenu(cmsplot_prop.handles(5,17),'label','Plant Supercell','callback','set_cmsplot_prop coordinates pltsc; cmsplot_now;');
        cmsplot_prop.axlabels.sclabs.lab1 = coreinfo.constants.Values{17};
        cmsplot_prop.axlabels.sclabs.lab2 = coreinfo.constants.Values{16};
end
% add filters available on file
cmsplot_prop.filter.filters='';
cmsplot_prop.filter.nfta_name=GetDistName(coreinfo,'NFT');
if ~isempty(cmsplot_prop.filter.nfta_name)
    cmsplot_prop.filter.filters={'nfta'};
    cmsplot_prop.filter.nfta=ReadCore(coreinfo,cmsplot_prop.filter.nfta_name,1);    
end
cmsplot_prop.filter.nhyd_name=GetDistName(coreinfo,'NHYD');
if ~isempty(cmsplot_prop.filter.nhyd_name)
    cmsplot_prop.filter.filters=[cmsplot_prop.filter.filters;{'nhyd'}];
    cmsplot_prop.filter.nhyd=ReadCore(coreinfo,cmsplot_prop.filter.nhyd_name,1);
end
cmsplot_prop.filter.bat_name=GetDistName(coreinfo,'BAT');
if ~isempty(cmsplot_prop.filter.bat_name)
    cmsplot_prop.filter.filters=[cmsplot_prop.filter.filters;{'bat'}];
    cmsplot_prop.filter.bat=ReadCore(coreinfo,cmsplot_prop.filter.bat_name,1);
end


if ~isempty(cmsplot_prop.filter.filters)
    set(cmsplot_prop.handles(4,4),'enable','off'); 
    set(cmsplot_prop.handles(4,3),'enable','off'); 
    set(cmsplot_prop.handles(4,5),'enable','off'); 
    for i = 1:length(cmsplot_prop.filter.filters)
        switch cmsplot_prop.filter.filters{i}
            case 'nfta'
                set(cmsplot_prop.handles(4,4),'enable','on');
            case 'nhyd'
                set(cmsplot_prop.handles(4,3),'enable','on');
            case 'bat'
                set(cmsplot_prop.handles(4,5),'enable','on');
        end
    end
end    



delete(cmsplot_prop.data_handles(cmsplot_prop.data_handles~=0));

h1=handles(2,1);
data_handles(1,1)=uimenu(h1,'label','MATLAB','callback',@set_matvar);


distlist=cmsplot_prop.distlist;
for i=1:length(distlist)
    if iscell(distlist{i}),
        data_handles(1,i+1)=uimenu(h1,'label',distlist{i}{1});        
        for j=2:length(distlist{i}),
            uimenu(data_handles(1,i+1),'label',distlist{i}{j},'callback','get_cmsplot_data(gcbo);cmsplot_now;');
        end
    else
        data_handles(1,i+1)=uimenu(h1,'label',cmsplot_prop.distlist{i},...
        'callback','get_cmsplot_data(gcbo);cmsplot_now');
    end
end
if ~isempty(cmsplot_prop.case_handles)
    delete(cell2mat(cmsplot_prop.case_handles(~cellfun(@isempty,cmsplot_prop.case_handles))));
end

spechand = handles(6,1);
env_flag=true; %For most filetypes, you may want to do envelopes
switch cmsplot_prop.filetype
    case {'.cms','.out','.sum'}
            case_handles{2}=uimenu(spechand,'label','Plot scalars','callback',...
            'x=get(gcf,''userdata'');PlotS3k(x.filename)');
            case_handles{4}=uimenu(spechand,'label','Dynamic','callback','cmsProfile(2)');
            case_handles{6}=uimenu(spechand,'label','Profiles','callback','cmsProfile(1)');
            case_handles{7}=uimenu(spechand,'label','Envelope');
            case_handles{8}=uimenu(case_handles{7},'label','Max','callback','cmsEnvelope(@max)');
            case_handles{9}=uimenu(case_handles{7},'label','Min','callback','cmsEnvelope(@min)');
            case_handles{11}=uimenu(spechand,'label','Attach Pinfile','callback','pinplot(1)');
            if ~max(strncmpi('BAT',cmsplot_prop.coreinfo.distlist,3))
                set(cmsplot_prop.handles(3,24),'enable','off');
            end
            set(cmsplot_prop.handles(3,27),'enable','off');
            set(cmsplot_prop.handles(5,9),'enable','off');
            set(cmsplot_prop.handles(6,7),'enable','off');
            set(cmsplot_prop.handles(6,8),'enable','off');
    case '.res'
        case_handles{1,2}=uimenu(spechand,'label','Pinplot','callback','pinplot');
        if max(strncmp('PINEXP',coreinfo.distlist,6))==0,
            set(case_handles{1,2},'enable','off');
        end
        case_handles{1,4}=uimenu(spechand,'label','Dynamic','callback','cmsProfile(2)');
        case_handles{1,6}=uimenu(spechand,'label','Profiles','callback','cmsProfile(1)');
        case_handles{1,7}=uimenu(spechand,'label','Envelope');
        case_handles{1,8}=uimenu(case_handles{7},'label','Max','callback','cmsEnvelope(@max)');
        case_handles{1,9}=uimenu(case_handles{7},'label','Min','callback','cmsEnvelope(@min)');
        if coreinfo.fileinfo.Sim == 5
            case_handles{2,1} = uimenu(spechand,'label','Submesh Plot','callback','plot_sub_mesh');
            case_handles{3,1} = uimenu(h1,'label','S5 data');
            case_handles{3,2} = uimenu(case_handles{3,1},'label','Subnode Histories');
            case_handles{3,3} = uimenu(case_handles{3,1},'label','Micro Depletions 1','enable','off');
            case_handles{3,4} = uimenu(case_handles{3,1},'label','Micro Depletions 2','enable','off');
            
            subdists = coreinfo.distlist(strncmp('SUB ',coreinfo.distlist,4));
            for j=1:length(subdists),
                data_handles(2,j) = uimenu(case_handles{3,2},'label',subdists{j},'callback','get_cmsplot_data(gcbo);cmsplot_now;');
            end
            
            if max(strcmp('ASSEMBLY ISOTOPICS',coreinfo.misclist))
                set(case_handles{3,3},'enable','on');
                set(case_handles{3,4},'enable','on');
                microdists = coreinfo.distlist(strncmp('MICRO ',coreinfo.distlist,6));
                nummicrodist = ReadRes(coreinfo,'NUM MICRO DEP',1);
                microdists = microdists(1:nummicrodist);
                m1 = length(microdists)/2;
                for j=1:m1,
                    data_handles(3,j) = uimenu(case_handles{3,3},'label',microdists{j},'callback','get_cmsplot_data(gcbo);cmsplot_now;');
                end
                for j=(m1+1):length(microdists),
                    data_handles(4,j) = uimenu(case_handles{3,4},'label',microdists{j},'callback','get_cmsplot_data(gcbo);cmsplot_now;');
                end
            end
        else
            if ~strcmpi('FULL',cmsplot_prop.core.sym)
                set(case_handles{2},'enable','off');
            end
            
        end
    case '.mat'
        case_handles{1} = uimenu(spechand,'label','Eigenvector','callback','eigenvec');
        env_flag=false;
    case {'.p7','.dat','.pre','.p4'}
        case_handles{1}=[];
        env_flag=false;
end


if length(cmsplot_prop.Xpo) == 1 && env_flag
    set(case_handles{1,4},'enable','off');
    set(case_handles{1,6},'enable','off');
    set(case_handles{1,7},'enable','off');
end


cmsplot_prop.data_handles=data_handles;
cmsplot_prop.case_handles=case_handles;

if max(abs(sort(cmsplot_prop.Xpo)-cmsplot_prop.Xpo))>1e-4, cmsplot_prop.Xpo=cumsum(cmsplot_prop.Xpo);end
cmsplot_prop.filter.filt_matvar=1; % Initialize

cmsplot_prop.if2x2=0;

if cmsplot_prop.matvar_plot
    if ~strcmp(cmsplot_prop.crods','no')
        cmsplot_prop.konrod=ReadCore(cmsplot_prop.coreinfo,'CRD.POS',1);
        if length(cmsplot_prop.konrod)==length(cmsplot_prop.coreinfo.core.crmminj),
            cmsplot_prop.konrod=cor2vec(cmsplot_prop.konrod,cmsplot_prop.coreinfo.core.crmminj);
        end
        cmsplot_prop.konrod_max=max(cmsplot_prop.konrod);
    end
    set(hfig,'userdata',cmsplot_prop);
    plot_matvar(cmsplot_prop.matvar_string{1},0);
else
    set(hfig,'userdata',cmsplot_prop);
    get_cmsplot_data;
end


set(hfig,'Pointer','arrow');
if isfield(cmsplot_prop,'core') && env_flag
    StatePointSlider;
end