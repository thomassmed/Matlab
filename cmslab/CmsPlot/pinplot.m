function pinplot(mode)
% pinplot is used by cmsplot (with res file input) and plots pindata.
% (works for both S3 and S5)
%
% See also get_next_assembly_for_pindata

% Mikael Andersson 2011-12-15

%% get coreinfo from cmsplot
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
coreinfo = cmsplot_prop.coreinfo;
pinplot_prop.coreinfo = coreinfo;
if2x2 = coreinfo.core.if2x2;
    
if nargin == 1
    [filename,pathname]=uigetfile({'*.pinfile','pin-files (*.pinfile)';...
        '*.*', 'All files (*.*)'},...
        'Pick a file',coreinfo.fileinfo.fullname);
    pinplot_prop.pininfo = ReadCore([pathname filename],'pinfile');
    pinplot_prop.coordinates = 'ij';
    Sim = 3;
else
    pinplot_prop.axlabels = cmsplot_prop.axlabels;
    pinplot_prop.coordinates = cmsplot_prop.coordinates;
    Sim = coreinfo.fileinfo.Sim;
end
    

%% default data from cmsplot
pinplot_prop.hcmsplot = hfig;
pinplot_prop.st_pt = cmsplot_prop.state_point;
pinplot_prop.pinvar = {''};
if strcmpi(cmsplot_prop.dist_name,'burnup')
    pinplot_prop.dataplot = 'EXP';
else
    if Sim == 3
        pinplot_prop.dataplot = 'POW';
    else
        pinplot_prop.dataplot = 'EXP';
    end
end

pinplot_prop.matvar_string = {''};
if max(strcmp(cmsplot_prop.operator,{'mean','min','max'}))
    pinplot_prop.datacalc = cmsplot_prop.operator;
else
    pinplot_prop.datacalc = 'mean';
end

% get some default data
if nargin == 1
    fuel_data = ReadCore(pinplot_prop.pininfo,'fuel_data',1);
    pinplot_prop.nfta = fuel_data.IROT;
else
    pinplot_prop.nfta = ReadCore(coreinfo,'nfta',pinplot_prop.st_pt);
end
pinplot_prop.serials = coreinfo.serial;
if if2x2 == 2
    pinplot_prop.nfta = fill2x2(pinplot_prop.nfta,coreinfo.core.mminj,coreinfo.core.knum,'full');
end


pinplot_prop.numberplot = 'noval';
pinplot_prop.autoscale = 'yes'; 
coljet = jet; brjet = coljet(3:end-1,:);
defcolormap = brjet;
pinplot_prop.axkind = 1;
pinplot_prop.casmoori = 0;
%% create and place window
scrsz = get(0,'ScreenSize');
dM=scrsz(3)*0.2;
sidy=scrsz(4)/1.7;
sidx=1.2*sidy;
pinfig = figure('Position',[scrsz(3)/20 sidy-dM sidx sidy]);
nameofplot = ['PinPlot - ' cmsplot_prop.filename];
set(pinfig,'Name',nameofplot); 

%% create menubar
set(pinfig,'menubar','none');
pinplot_prop.hpinplot = pinfig;
h=zeros(10,20);


h(1,1)=uimenu('label','File');
h(1,2)=uimenu(h(1,1),'label','New assembly','callback','get_next_assembly_for_pindata;');
h(1,3)=uimenu(h(1,1),'label','Save','callback','[FileName,PathName] = uiputfile({''*.jpg;*.tif;*.png;*.gif'',''All Image Files'';''*.*'',''All Files'' },''Save Image'',''submeshplot.jpg''); saveas(gcf,[PathName FileName]); '); 
% TODO: add save in some way.. works strange... will not save colors..
% WHY!?!?!



h(2,1)=uimenu('label','Data');
h(2,2)=uimenu(h(2,1),'label','MATLAB','callback','set_pinvar');
% h(2,2)=uimenu(h(2,1),'label','MATLAB','callback',@set_matvar);
if Sim == 3
    h(2,3)=uimenu(h(2,1),'label','POW','callback','set_cmsplot_prop dataplot POW ; set_cmsplot_prop autoscale yes; PlotPinData');
end
h(2,4)=uimenu(h(2,1),'label','EXP','callback','set_cmsplot_prop dataplot EXP ; set_cmsplot_prop autoscale yes; PlotPinData');


h(3,1)=uimenu('label','Option');
h(3,10)=uimenu(h(3,1),'label','Refresh','callback','PlotPinData;');
h(3,2)=uimenu(h(3,1),'label','max','callback','set_cmsplot_prop datacalc max;PlotPinData');
h(3,3)=uimenu(h(3,1),'label','average','callback','set_cmsplot_prop datacalc mean ;PlotPinData');
h(3,4)=uimenu(h(3,1),'label','min','callback','set_cmsplot_prop datacalc min;PlotPinData');
h(3,5)=uimenu(h(3,1),'label','Autoscale','callback','set_cmsplot_prop autoscale yes;PlotPinData');
h(3,6)=uimenu(h(3,1),'label','Fix Scale','callback','set_pin_scale(1)');
h(3,7)=uimenu(h(3,1),'label','Scale on all state point','callback','set_pin_scale(0)');


h(4,1) = uimenu('label','Layout');
h(4,5)=uimenu(h(4,1),'label','Value plot');
h(4,6)=uimenu(h(4,5),'label','No Values','callback','set_cmsplot_prop numberplot noval; PlotPinData');
h(4,7)=uimenu(h(4,5),'label','Values','callback','set_cmsplot_prop numberplot val; PlotPinData');
h(4,8)=uimenu(h(4,1),'label','Colormap');
h(4,11)=uimenu(h(4,8),'label','Spring','callback','colormap(flipud(spring))');
h(4,12)=uimenu(h(4,8),'label','Summer','callback','colormap(flipud(summer));');
h(4,13)=uimenu(h(4,8),'label','Autumn','callback','colormap(flipud(autumn));');
h(4,14)=uimenu(h(4,8),'label','Winter','callback','colormap Winter');
h(4,15)=uimenu(h(4,8),'label','Jet','callback','colormap Jet');
h(4,17)=uimenu(h(4,8),'label','Hot','callback','colormap(flipud(hot));');
h(4,18)=uimenu(h(4,1),'label','Orientation');
if if2x2 == 2
    h(4,19)=uimenu(h(4,18),'label','Casmo','callback','set_cmsplot_prop(''casmoori'',1); PlotPinData');
    h(4,20)=uimenu(h(4,18),'label','Core','callback','set_cmsplot_prop(''casmoori'',0); PlotPinData');
else
    h(4,19)=uimenu(h(4,18),'label','Casmo','callback','set_cmsplot_prop(''casmoori'',1); DrawCtrrod; PlotPinData');
    h(4,20)=uimenu(h(4,18),'label','Core','callback','set_cmsplot_prop(''casmoori'',0); DrawCtrrod; PlotPinData');
end
h(4,21)=uimenu(h(4,1),'label','Axis');
h(4,22)=uimenu(h(4,21),'label','Type 1','callback','set_cmsplot_prop(''axkind'',1); PlotPinData');
h(4,23)=uimenu(h(4,21),'label','Type 2','callback','set_cmsplot_prop(''axkind'',2); PlotPinData');

h(6,1)=uimenu('label','Special Functions');
h(6,2)=uimenu(h(6,1),'label','Segment Plot','callback','Seg_Plot');
if ~strcmpi(coreinfo.fileinfo.type,'res')
    set(h(6,2),'Enable','off');
end
h(6,5)=uimenu(h(6,1),'label','Profile Plot','callback','Pin_Prof_Plot');
h(6,6)=uimenu(h(6,1),'label','Dynamic Plot','callback','Pin_Dynam_Plot');
h(6,11)=uimenu(h(6,1),'label','Compare2','callback','prep_compare2');
h(6,3)=uimenu(h(6,1),'label','Ind. Pins','callback','ind_pins');
h(6,9)=uimenu(h(6,1),'label','Nodplane','callback','pin_node_plane;');

if length(coreinfo.Xpo) == 1
    set(h(6,5),'enable','off');
    set(h(6,6),'enable','off');
end
h(10,1) = uimenu('label','Export Data','callback','SavedataGUI(1);');
pinplot_prop.h = h;
%% set some figure parameters and create controls
axes1 = axes('Visible','on');
hold(axes1,'all');
axis([-1.3 13 -1.3 13])
set(axes1,'position',[0.17 0.11 0.75 0.8]);

str = cell(1,length(coreinfo.Xpo));
for i=1:length(coreinfo.Xpo),
    str{i} = sprintf('%i :%6.2f',i,coreinfo.Xpo(i));
end

listb = uicontrol('style','listbox','units','Normalized','position',[0 0 .1 .94],'string', str);

set(listb,'callback','st=get(gcbo,''Value'');setpinstpt(st);');

set(listb,'Value',pinplot_prop.st_pt);

nodtext(1) = annotation('textbox',[0.03 0.91 0.25 0.09],'EdgeColor','none');
nodtext(2) = annotation('textbox',[0.30 0.91 0.27 0.09],'EdgeColor','none','HorizontalAlignment','center');
nodtext(3) = annotation('textbox',[0.65 0.91 0.30 0.09],'EdgeColor','none');

pinplot_prop.listb = listb;
pinplot_prop.nodtext = nodtext;
set(pinfig,'userdata',pinplot_prop);
colormap(defcolormap)
%% start to choose data
uiwait(msgbox('Left button to select, right to quit'));
get_next_assembly_for_pindata


