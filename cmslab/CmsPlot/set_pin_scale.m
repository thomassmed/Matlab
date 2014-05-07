function set_pin_scale(mode)
% set_pin_scale is used by pinplot and sub_mesh_plot to change scale of legend

% mode 1 for pinplot and zero for sub_mesh_plot

%% get data from figure
hfig=gcf;
pinplot_prop=get(hfig,'userdata');
def_max=pinplot_prop.scale_max;
def_min=pinplot_prop.scale_min;

if mode
%% create input dialog to get new scale
    nod=inputdlg({'Max','Min'},'Enter new scale',1,{num2str(def_max), num2str(def_min)} );
    %% set new scale and replot
    if ~isempty(nod)
        set_cmsplot_prop('scale_max',str2double(nod(1)));
        set_cmsplot_prop('scale_min',str2double(nod(2)));
        set_cmsplot_prop('autoscale','no');
        if max(strcmp('pindata',fieldnames(pinplot_prop)))
            PlotPinData;
        else
            PlotSubMeshData;
        end
    end
else
    if max(strcmp('pindata',fieldnames(pinplot_prop)))
        if isfield(pinplot_prop,'pininfo')
            if strcmpi(pinplot_prop.dataplot,'EXP')
                dists = ReadCore(pinplot_prop.pininfo,'PINEXP3','ends',pinplot_prop.coreinfo.serial(pinplot_prop.knumuse));
            else
                dists = ReadCore(pinplot_prop.pininfo,'PINPOW3','all',pinplot_prop.coreinfo.serial(pinplot_prop.knumuse));
            end
        else
            if strcmpi(pinplot_prop.dataplot,'EXP')
                dists = ReadCore(pinplot_prop.coreinfo,'PINEXP','ends',pinplot_prop.knumuse);
            else
                dists = ReadCore(pinplot_prop.coreinfo,'PINPOW','all',pinplot_prop.knumuse);
            end
        end
        eval(['dist = ' pinplot_prop.datacalc '(dists{1},3);'])
        dist_max=max(dist(:));
        dist_min=min(dist(dist~=0));
        if isempty(dist_min)
            dist_min = 10^5;
        end
        for i = 2:length(dists)
            eval(['dist = ' pinplot_prop.datacalc '(dists{i},3);'])
            dist_max=max(dist_max,max(dist(:)));
            dist_min=min(dist_min,min(dist(dist~=0)));        
        end
        set_cmsplot_prop('autoscale','no');
        set_cmsplot_prop('scale_min',min(dist_min(:)));
        set_cmsplot_prop('scale_max',max(dist_max(:)));
        PlotPinData;
        
    else
        if max(strcmpi(pinplot_prop.dataplot,{'EXPR','EXPA'}))
            dists = ReadCore(pinplot_prop.coreinfo,'SUBMESH DATA EXP','ENDS',pinplot_prop.knums);
            if strcmp('EXPA',pinplot_prop.dataplot)
                subnodeexp = ReadCore(pinplot_prop.coreinfo,'SUB BURNUP','ENDS',pinplot_prop.knums);
                for j = 1:length(dists)
                    if iscell(dists)
                        for i = 1:length(dists)
                            newdata{i} = (dists{i}(:,1)~=0)*(subnodeexp{i})' + dists{i};
                        end
                    else
                        newdata = (data(:,1)~=0)*(subnodeexp{1})' + data;
                    end
                end
                dists = newdata;
            end
            
            
        elseif strcmpi('POW',pinplot_prop.dataplot)
            dists = ReadCore(pinplot_prop.coreinfo,'SUBMESH DATA POW','all',pinplot_prop.knums);
        else
            distlab = ['SUBMESH ' pinplot_prop.dataplot];
            if strncmpi(pinplot_prop.dataplot,'U',1)
                xps = 'ENDS'; 
            else
                xps = 'ALL';
            end
            dists = ReadCore(pinplot_prop.coreinfo,distlab,xps,pinplot_prop.knums);
        end
        if length(pinplot_prop.knums) == 1
            transdist = cellfun(@transpose,dists,'uniformoutput',0);
        else
            transdist = cellfun(@transpose,dists{1},'uniformoutput',0);
        end
        eval(['opdist = cellfun(@' pinplot_prop.datacalc ',transdist,''uniformoutput'',0);'])
        dist_max = max(cellfun(@max,opdist));
        nonzdist = cellfun(@nonzeros,opdist,'uniformoutput',0);
        dzlen = cellfun(@length,nonzdist);
        if sum(dzlen)/length(dzlen) == dzlen(1)
            dist_min = min(cellfun(@min,nonzdist));
        else
            dist_min = min(cell2mat(cellfun(@min,nonzdist(dzlen ~= 0),'uniformoutput',0)));
        end
        if length(pinplot_prop.knums) ~= 1
            for i = 2:length(dists)
                transdist = cellfun(@transpose,dists{i},'uniformoutput',0);
                eval(['opdist = cellfun(@' pinplot_prop.datacalc ',transdist,''uniformoutput'',0);'])

                dist_max = max([(cellfun(@max,opdist)) dist_max]);
                dist_min = min([(cellfun(@min,cellfun(@nonzeros,opdist,'uniformoutput',0))) dist_min]);
            end
        end
        set_cmsplot_prop('autoscale','no');
        set_cmsplot_prop('scale_min',min(dist_min(:))*0.9);
        set_cmsplot_prop('scale_max',max(dist_max(:))*1.1);
        PlotSubMeshData;
    end
    end
end
    