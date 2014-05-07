function get_submesh_data
% get_submesh_data is used by plot_sub_mesh to get data 
%
% See also plot_sub_mesh, PlotSubMeshData

% Mikael Andersson 2012-01-05
%% get data from cmsplot
submeshfig=gcf;
submeshplot_prop=get(submeshfig,'userdata');
coreinfo = submeshplot_prop.coreinfo;
st_pt = submeshplot_prop.st_pt;
dats = submeshplot_prop.dataplot;
kread = submeshplot_prop.knums;
if coreinfo.core.if2x2 == 2
    asspos = convert2x2('2asspos',coreinfo.core.knum,coreinfo.core.mminj,'full');
    for i = 1:length(kread)
        [~,pos(i)] = find(asspos == kread(i));
    end
    submeshplot_prop.rotpos = pos;
end
 
switch dats
    case 'POW'
        datasort = 'SUBMESH DATA POW';
        subnodedata = ReadCore(coreinfo,datasort,st_pt,kread');
        datastring{1} = ['Power - ' submeshplot_prop.datacalc  '   '];
    case {'EXPR', 'EXPA'}
        datasort = 'SUBMESH DATA EXP';
        data = ReadCore(coreinfo,datasort,st_pt,kread');
        if strcmp(dats,'EXPA')
            subnodeexp = ReadRes(coreinfo,'sub burnup',st_pt,kread');
            if coreinfo.core.if2x2 == 2
                for i = 1:length(data)
                	newdata{i} = (data{i}(:,2)~=0)*(subnodeexp{i})' + data{i};
                end
            else
                if iscell(data)
                    for i = 1:length(data)
                        newdata{i} = (data{i}(:,1)~=0)*(subnodeexp{i})' + data{i};
                    end
                else
                    newdata = (data(:,1)~=0)*(subnodeexp{1})' + data;
                end
            end
            datastring{1} = ['Exposure (Real) - ' submeshplot_prop.datacalc  '   '];
        else
            newdata = data;
            datastring{1} = ['Exposure (Relative) - ' submeshplot_prop.datacalc  '   '];
        end
        subnodedata = newdata;
    otherwise
        switch dats
            case 'U235'
                datasort = 'SUBMESH U235';
                datastring{1} = ['U-235 - ' submeshplot_prop.datacalc  '   '];
            case 'U238'
                datasort = 'SUBMESH U238';
                datastring{1} = ['U-238 - ' submeshplot_prop.datacalc  '   '];
            case 'PU239'
                datasort = 'SUBMESH PU239';
                datastring{1} = ['Pu-239 - ' submeshplot_prop.datacalc  '   '];
            case 'PU240'
                datasort = 'SUBMESH PU240';
                datastring{1} = ['Pu-240 - ' submeshplot_prop.datacalc  '   '];
            case 'PU241'
                datasort = 'SUBMESH PU241';
                datastring{1} = ['Pu-241 - ' submeshplot_prop.datacalc  '   '];
        end
                data = ReadCore(coreinfo,datasort,st_pt,kread');

        if coreinfo.core.if2x2 == 2
            subnodedata = data;
        else 
            refsizes = ReadRes(coreinfo,'SUBMESH DATA POW',st_pt,kread');
            if ~iscell(data)
                data = {data};
                refsizes = {refsizes};
            end
            newdata = refsizes;
            refsizestest = cell2mat(cellfun(@size,refsizes,'uniformoutput',0)');
            datasizestest = cell2mat(cellfun(@size,data,'uniformoutput',0)');
            datasz = sqrt(datasizestest(:,1));
            refsz = sqrt(refsizestest(:,1));
            % TODO: needs to be changed if there are other symetries than
            % in bwr case (water nodes around fuel)
            for i = 1:length(data)
                if datasz(i) == refsz(i)
                    newdata{i} = data{i};
                else
                    matnew =zeros(refsz(i));
                    matnew(2:4,2:4) = ones(datasz(i));
                    vecnew = reshape(matnew,refsz(i)^2,1);
                    newdata{i} = repmat(vecnew,1,refsizestest(i,2));
                    newdata{i}(newdata{i}~=0) = data{i};
                end
            end
            subnodedata = newdata;

        end
end
% if coreinfo.core.if2x2 == 2
%     newdata = cell(size(subnodedata));
%     if length(kread) == 1
%         logi1 = knm == kread;
%         newdata(logi1) = subnodedata(pos(logi1));
%     else
%         for i = 1:length(kread)
%             logi1 = knm == kread(i);
%             newdata(logi1) = subnodedata{i}(pos(logi1));
%         end
%     end
%     subnodedata = newdata;
%     submeshplot_prop.rotpos = pos;
% end

if length(kread) == 1
    if iscell(subnodedata)
        subnodedata = subnodedata{1};
    end
    submeshplot_prop.nod_plane = [1 length(subnodedata)];
    delete(submeshplot_prop.handles(10,1));
    submeshplot_prop.handles(10,1)=uimenu('label','Export Data','callback','SavedataGUI(1);');
    submeshplot_prop.data = subnodedata;
else 
    
    delete(submeshplot_prop.handles(10,1));
    submeshplot_prop.handles(10,1)=uimenu('label','Export Data','callback','SavedataGUI(0);');
end


%% text
set(submeshplot_prop.nodtext(1),'String',datastring{1},'FontSize',10); 
%% save new data
submeshplot_prop.subnodedata = subnodedata;
set(submeshfig,'userdata',submeshplot_prop);
%% Plot new data
PlotSubMeshData
end