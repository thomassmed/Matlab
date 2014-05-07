function plot_sub_mesh
% plot_sub_mesh is used by cmsplot (with simulate 5 res file input) and     
% plots a part of the core with submesh data.
%
% See also get_positions_for_submeshplot PlotSubMeshData

% Mikael Andersson 2012-01-05

%% get data from cmsplot and set some default data
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
coreinfo = cmsplot_prop.coreinfo;
submeshplot_prop.coreinfo = coreinfo;
submeshplot_prop.hcmsplot = hfig;
submeshplot_prop.autoscale = 'yes';
submeshplot_prop.geoms = cmsplot_prop.subgeom;
submeshplot_prop.st_pt = cmsplot_prop.state_point;
submeshplot_prop.dispval = 0;
submeshplot_prop.hz = cmsplot_prop.hz;
submeshplot_prop.axlabels = cmsplot_prop.axlabels;
submeshplot_prop.axstyle = cmsplot_prop.coordinates;
lib = ReadCore(coreinfo,'Library',submeshplot_prop.st_pt);
cdfile = lib.cd_file;
try
    cdinfo = ReadCdfile(cdfile);
    submeshplot_prop.cdinfo = cdinfo;
catch err
    if strcmpi(coreinfo.core.lwr,'BWR');
        submeshplot_prop.xmesh = [0.6 4.0600 5.8400 4.0600 0.715];
        submeshplot_prop.ymesh = [0.6 4.0600 5.8400 4.0600 0.715];
    else
        submeshplot_prop.xmesh = [3.0550 3.0550 3.0550 3.0550 3.0550];
        submeshplot_prop.ymesh = [3.0550 3.0550 3.0550 3.0550 3.0550];
    end
    submeshplot_prop.nsubs = 5;
    submeshplot_prop.cdinfo = 'nocdfile';
end

submeshplot_prop.lib = lib;
submeshplot_prop.axstyle = 'ij';
if ~isempty(regexpi(cmsplot_prop.dist_name,'BURNUP','match'))
    submeshplot_prop.dataplot = 'EXPR';
elseif ~isempty(regexpi(cmsplot_prop.dist_name,'U235','match'))
    submeshplot_prop.dataplot = 'U235';
elseif ~isempty(regexpi(cmsplot_prop.dist_name,'U238','match'))
    submeshplot_prop.dataplot = 'U238';
elseif ~isempty(regexpi(cmsplot_prop.dist_name,'PU239','match'))
    submeshplot_prop.dataplot = 'PU239';
elseif ~isempty(regexpi(cmsplot_prop.dist_name,'PU240','match'))
    submeshplot_prop.dataplot = 'PU240';
elseif ~isempty(regexpi(cmsplot_prop.dist_name,'PU241','match'))
    submeshplot_prop.dataplot = 'PU241';
else
    submeshplot_prop.dataplot = 'POW';
end

if max(strcmp(cmsplot_prop.operator,{'mean','min','max'}))
    submeshplot_prop.datacalc = cmsplot_prop.operator;% 'mean'; 
else
    submeshplot_prop.datacalc = 'mean';
end
submeshplot_prop.nod_plane = [1 coreinfo.core.kmax];

%% TODO: fixa en vettig colormap...
defcolormap = [1 1 1;jet];
%% set up the new window
scrsz = get(0,'ScreenSize');
dM=scrsz(3)*0.2;
sidy=scrsz(4)/1.7;
sidx=1.2*sidy;
submeshfig = figure('Position',[scrsz(3)/20 sidy-dM sidx sidy]);
nameofplot = ['Submesh plot - ' cmsplot_prop.filename];
set(submeshfig,'Name',nameofplot); 


str = cell(1,coreinfo.data.statepoints);
for i=1:coreinfo.data.statepoints,
    str{i} = sprintf('%i :%6.2f',i,coreinfo.Xpo(i));
end

%% set up the menus
set(submeshfig,'menubar','none');
h(1,1)=uimenu('label','File');
h(1,2)=uimenu(h(1,1),'label','New Plot Area','callback','get_positions_for_submeshplot;');
h(1,3)=uimenu(h(1,1),'label','Save','callback','[FileName,PathName] = uiputfile({''*.jpg;*.tif;*.png;*.gif'',''All Image Files'';''*.*'',''All Files'' },''Save Image'',''submeshplot.jpg''); saveas(gcf,[PathName FileName]); '); 
% 
h(2,1)=uimenu('label','Data');
% % h(2,2)=uimenu(h(2,1),'label','MATLAB','callback',@set_matvar);
if max(strcmp('SUBMESH DATA        ',coreinfo.data.Label))
    h(2,3)=uimenu(h(2,1),'label','POW','callback','set_cmsplot_prop dataplot POW ; set_cmsplot_prop autoscale yes; get_submesh_data');
    h(2,4)=uimenu(h(2,1),'label','EXP (abs)','callback','set_cmsplot_prop dataplot EXPA ; set_cmsplot_prop autoscale yes; get_submesh_data');
    h(2,4)=uimenu(h(2,1),'label','EXP (rel)','callback','set_cmsplot_prop dataplot EXPR ; set_cmsplot_prop autoscale yes; get_submesh_data');
end
if max(strcmp('SUBMESH ISOTOPICS   ',coreinfo.data.Label))
    h(2,6)=uimenu(h(2,1),'label','U-235','callback','set_cmsplot_prop dataplot U235 ; set_cmsplot_prop autoscale yes; get_submesh_data');
    h(2,7)=uimenu(h(2,1),'label','U-238','callback','set_cmsplot_prop dataplot U238 ; set_cmsplot_prop autoscale yes; get_submesh_data');
    h(2,8)=uimenu(h(2,1),'label','Pu-239','callback','set_cmsplot_prop dataplot PU239 ; set_cmsplot_prop autoscale yes; get_submesh_data');
    h(2,9)=uimenu(h(2,1),'label','Pu-240','callback','set_cmsplot_prop dataplot PU240 ; set_cmsplot_prop autoscale yes; get_submesh_data');
    h(2,10)=uimenu(h(2,1),'label','Pu-241','callback','set_cmsplot_prop dataplot PU241 ; set_cmsplot_prop autoscale yes; get_submesh_data');
end
h(3,1)=uimenu('label','Option');
h(3,10)=uimenu(h(3,1),'label','Refresh','callback','PlotSubMeshData;');
h(3,2)=uimenu(h(3,1),'label','max','callback','set_cmsplot_prop datacalc max;PlotSubMeshData');
h(3,3)=uimenu(h(3,1),'label','average','callback','set_cmsplot_prop datacalc mean ;PlotSubMeshData');
h(3,4)=uimenu(h(3,1),'label','min','callback','set_cmsplot_prop datacalc min;PlotSubMeshData');
h(3,5)=uimenu(h(3,1),'label','Autoscale','callback','set_cmsplot_prop autoscale yes;PlotSubMeshData');
h(3,6)=uimenu(h(3,1),'label','Fix Scale','callback','set_pin_scale');
h(3,7)=uimenu(h(3,1),'label','Nodplane','callback','set_node_plane;');
h(3,7)=uimenu(h(3,1),'label','Scale on all state point','callback','set_pin_scale(0)');

h(4,1) = uimenu('label','Layout');
h(4,2)=uimenu(h(4,1),'label','axis');
h(4,3)=uimenu(h(4,2),'label','Length','callback','set_cmsplot_prop axstyle leng; PlotSubMeshData');
h(4,4)=uimenu(h(4,2),'label','ij','callback','set_cmsplot_prop axstyle ij; PlotSubMeshData');
h(4,18) = uimenu(h(4,2),'label','Plant Specific','callback','set_cmsplot_prop axstyle plntspc; PlotSubMeshData');

h(4,5)=uimenu(h(4,1),'label','Value plot');
h(4,6)=uimenu(h(4,5),'label','No Values','callback','set_cmsplot_prop(''dispval'',0); PlotSubMeshData');
h(4,7)=uimenu(h(4,5),'label','Values','callback','set_cmsplot_prop(''dispval'',1); PlotSubMeshData');
% h(4,9)= uimenu(h(4,5),'label','Nr of digits','callback','
h(4,8)=uimenu(h(4,1),'label','Colormap');
h(4,11)=uimenu(h(4,8),'label','Spring','callback','colormap(flipud(spring))');
h(4,12)=uimenu(h(4,8),'label','Summer','callback','colormap(flipud(summer));');
h(4,13)=uimenu(h(4,8),'label','Autumn','callback','colormap(flipud(autumn));');
h(4,14)=uimenu(h(4,8),'label','Winter','callback','colormap Winter');
h(4,15)=uimenu(h(4,8),'label','Jet','callback','colormap Jet');
h(4,17)=uimenu(h(4,8),'label','Hot','callback','colormap(flipud(hot));');
% 
% h(6,1)=uimenu('label','Specials');
% h(6,2)=uimenu(h(6,1),'label','Segment Plot','callback','Seg_Plot');
h(10,1)=uimenu('label','Export Data','callback','SavedataGUI(0);');

submeshplot_prop.handles = h;
nodtext(1) = annotation('textbox',[0.03 0.91 0.25 0.09],'EdgeColor','none');
nodtext(2) = annotation('textbox',[0.30 0.91 0.27 0.09],'EdgeColor','none','HorizontalAlignment','center');
nodtext(3) = annotation('textbox',[0.65 0.91 0.30 0.09],'EdgeColor','none');

listb = uicontrol('style','listbox','units','Normalized','position',[0 0 .1 .94],'string', str);

set(listb,'callback','st=get(gcbo,''Value'');set_cmsplot_prop(''st_pt'',st); get_submesh_data');

submeshplot_prop.listb = listb;
submeshplot_prop.nodtext = nodtext;
set(submeshfig,'userdata',submeshplot_prop);
colormap(defcolormap)
%% start to choose area and plot the data
uiwait(msgbox('Left button to select, right to quit'));
get_positions_for_submeshplot


