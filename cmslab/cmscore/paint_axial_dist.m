function paint_axial_dist(~,~,hfig)


CmsCoreProp=get(hfig,'userdata');

scrsz=CmsCoreProp.scrsz;
sidy=scrsz(4)/2;
sidx=0.8*sidy;
hfig1=figure('position',[scrsz(4)/1.0 scrsz(3)/12 sidx sidy]);
set(hfig1,'Name','Axial Plot');
set(hfig1,'color',[.99 .99 .99]);
set(hfig1,'Menubar','none');
set(hfig1,'numbertitle','off');
set(hfig1,'userdata',CmsCoreProp);

h(2,1)=uimenu('label','power', 'callback',{@plot_power,hfig1});
h(3,1)=uimenu('label','kinf', 'callback',{@plot_power,hfig1});
h(4,1)=uimenu('label','old/new fint', 'callback',{@plot_power,hfig1});
h(5,1)=uimenu('label','old/new BTF', 'callback',{@plot_power,hfig1});

CmsCoreProp.handles.axial_plot_axes=gca;



%% Axial option
CmsCoreProp.handles.axial_option_group = uibuttongroup('Parent',hfig1, 'units','Normalized','position',[0.50 0.94 0.35 0.08],...
    'BackgroundColor',[1, 1 ,1],'BorderType','none');
CmsCoreProp.handles.axial_average = uicontrol('Style','Radio','String','Average',...
    'units','Normalized',  'position',[0.00 0.00 0.50 0.50],'parent',CmsCoreProp.handles.axial_option_group,'HandleVisibility','off',...
    'BackgroundColor',[1, 1 ,1],'FontWeight', 'bold', 'FontSize', 11);
CmsCoreProp.handles.axial_channel = uicontrol('Style','Radio','String',' Channel',...
    'units','Normalized',  'position',[0.50 0.00 0.50 0.50],'parent',CmsCoreProp.handles.axial_option_group,'HandleVisibility','off',...
    'BackgroundColor',[1, 1 ,1],'FontWeight', 'bold', 'FontSize', 11);

set(CmsCoreProp.handles.axial_average,'value',1);
set(hfig1,'userdata',CmsCoreProp);


CmsCoreProp.hfig1=hfig1;
set(hfig1,'userdata',CmsCoreProp);
set(hfig,'userdata',CmsCoreProp);
plot_power([],[],hfig1);

end


