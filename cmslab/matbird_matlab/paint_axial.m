function paint_axial(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

if(isfield(HotBirdProp.handles,'axial_axes') && ishandle(HotBirdProp.handles.axial_axes(1)))
    
    
else
    
    
    
    [~,cnmax] = size(HotBirdProp.cs.s);
    
    
    scrsz=HotBirdProp.scrsz;
    sidy=scrsz(4)/1.7;
    sidx=0.70*sidy;
    hfig2=figure('position',[scrsz(4)/1.0 scrsz(3)/12 sidx sidy]);
    set(hfig2,'Name','Axial zones');
    set(hfig2,'color',[.99 .99 .99]);
    set(hfig2,'Menubar','none');
    set(hfig2,'numbertitle','off');
    set(hfig2,'userdata',HotBirdProp);
    
    ax=zeros(25,1);
    axsum=0;
    for i=1:cnmax
        ax(i)=HotBirdProp.cs.s(i).axial_zone(i);
        axsum=axsum+ax(i);
    end
    
    sum=0;
    for i=1:cnmax
        HotBirdProp.handles.axial_axes(i)=axes('position',[0.20 0.11+sum 0.11 0.82*ax(i)]);
        HotBirdProp.clmap = colormap(jett);
        image(i+1);
        hold 'on';
        set(gca,'XTick',[],'YTick',[]);
        
        ce = sprintf('%5.3f', HotBirdProp.cs.s(i).u235);
        HotBirdProp.handles.axial_text_u235(i)=annotation(hfig2,'textbox',[0.20  0.10+sum  0.115 0.04], ...
            'String',ce,'HorizontalAlignment','center');
        set(HotBirdProp.handles.axial_text_u235(i),'FontWeight','bold');
        set(HotBirdProp.handles.axial_text_u235(i),'FontSize',11);
        set(HotBirdProp.handles.axial_text_u235(i),'FontUnits', 'normalized');
        set(HotBirdProp.handles.axial_text_u235(i),'LineStyle','none');
        
        ce=sprintf('%d', round(ax(i)*100));
        HotBirdProp.handles.axial_edit(i)=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
            'position',[.33  0.11+sum .07 .03] ,'string',ce,'callback',{@axial_edit_callback,hfig});
        set(HotBirdProp.handles.axial_edit(i),'FontWeight','bold');
        set(HotBirdProp.handles.axial_edit(i),'FontSize',11);
        set(HotBirdProp.handles.axial_edit(i),'FontUnits', 'normalized');
        set(HotBirdProp.handles.axial_edit(i),'BackgroundColor', [0.99,0.99,0.99]);
        
        HotBirdProp.handles.axial_slider(i)= uicontrol(hfig2,'Style','slider',...
            'Max',100, 'Min',0, 'Value',ax(i)*100, 'SliderStep',[0.01 0.01], 'Units','normalized',...
            'Position',[.42 0.11+sum  .10 .030],'Callback', {@axial_slider_callback,hfig});
        set(HotBirdProp.handles.axial_slider(i),'FontSize',11);
        set(HotBirdProp.handles.axial_slider(i),'FontUnits', 'normalized');
        set(HotBirdProp.handles.axial_slider(i),'BackgroundColor', [0.99,0.99,0.99]);

        HotBirdProp.handles.axial_checkbox(i)=uicontrol('Style','checkbox','Units','Normalized', ...
            'position',[0.02  0.11+sum .16 .03] ,'string','Change', 'FontWeight','bold', ...
            'callback',{@axial_change_callback,hfig});
        
        set(HotBirdProp.handles.axial_checkbox(i),'FontSize',11);
        set(HotBirdProp.handles.axial_checkbox(i),'FontUnits', 'normalized');
        set(HotBirdProp.handles.axial_checkbox(i),'BackgroundColor', [0.59,0.99,0.99]);
        set(HotBirdProp.handles.axial_checkbox(i),'value',HotBirdProp.axial_checkbox(i));
        
        ce=strrep(HotBirdProp.cs.s(i).sim,'SIM','');
        ce=strrep(ce,'''','');
        HotBirdProp.handles.axial_text_segmentname(i)=annotation(hfig2,'textbox',[0.54  0.11+sum .34 .03], ...
            'String',ce,'HorizontalAlignment','left');
        set(HotBirdProp.handles.axial_text_segmentname(i),'LineStyle','none');
        set(HotBirdProp.handles.axial_text_segmentname(i),'FontWeight','bold');
        set(HotBirdProp.handles.axial_text_segmentname(i),'FontSize',10);
        set(HotBirdProp.handles.axial_text_segmentname(i),'FontUnits', 'normalized');
        set(HotBirdProp.handles.axial_text_segmentname(i),'BackgroundColor', [0.99,0.99,0.99]);

        sum = 0.82*ax(i) + sum;
    end
    

    ce=sprintf('Total  %d  ', round(axsum*100));
    HotBirdProp.handles.axial_text_procsum1=annotation(hfig2,'textbox',[.35  0.02  .22 .04], ...
        'String',ce,'HorizontalAlignment','center');
    set(HotBirdProp.handles.axial_text_procsum1,'LineStyle','none');
    set(HotBirdProp.handles.axial_text_procsum1,'FontWeight','bold');
    set(HotBirdProp.handles.axial_text_procsum1,'FontSize',11);
    set(HotBirdProp.handles.axial_text_procsum1,'FontUnits', 'normalized');
    set(HotBirdProp.handles.axial_text_procsum1,'BackgroundColor', [0.99,0.99,0.99]);
    
    HotBirdProp.handles.axial_text_procsum2=annotation(hfig2,'textbox',[.57  0.02  .07 .04], ...
        'String','%','HorizontalAlignment','center');
    set(HotBirdProp.handles.axial_text_procsum2,'LineStyle','none');
    set(HotBirdProp.handles.axial_text_procsum2,'FontWeight','bold');
    set(HotBirdProp.handles.axial_text_procsum2,'FontSize',11);
    set(HotBirdProp.handles.axial_text_procsum2,'FontUnits', 'normalized');
    set(HotBirdProp.handles.axial_text_procsum2,'BackgroundColor', [0.99,0.99,0.99]);
    
    
    HotBirdProp.handles.axial_crd_slider= uicontrol(hfig2,'Style','slider',...
        'Max',100, 'Min',0, 'Value',HotBirdProp.cs.crd, 'SliderStep',[0.01 0.01], 'Units','normalized',...
        'Position',[.87 0.07  .12 .025],'Callback', {@axial_crd_slider_callback,hfig});
    set(HotBirdProp.handles.axial_crd_slider,'FontWeight','bold');
    set(HotBirdProp.handles.axial_crd_slider,'FontSize',11);
    set(HotBirdProp.handles.axial_crd_slider,'FontUnits', 'normalized');
    set(HotBirdProp.handles.axial_crd_slider,'BackgroundColor', [0.99,0.99,0.99]);
    
    
    
    slider_value=get(HotBirdProp.handles.axial_crd_slider,'value');
    
    if(slider_value==100)
        slider_value=99.99;
    end
    
    HotBirdProp.handles.axial_crd_axes=axes('position',[0.90 0.11 0.05 0.82*(100-slider_value)/100]);
    image(17);
    set(gca,'XTick',[],'YTick',[]);
    hold 'on';
    
    ce=sprintf('%d', HotBirdProp.cs.crd);
    HotBirdProp.handles.axial_crd_edit=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'position',[.875  0.02 .07 .03] ,'string',ce,'callback',{@axial_crd_edit_callback,hfig});
    set(HotBirdProp.handles.axial_crd_edit,'FontWeight','bold');
    set(HotBirdProp.handles.axial_crd_edit,'FontSize',11);
    set(HotBirdProp.handles.axial_crd_edit,'FontUnits', 'normalized');
    set(HotBirdProp.handles.axial_crd_edit,'BackgroundColor', [0.99,0.99,0.99]);
    
    HotBirdProp.handles.axial_crd_text1=annotation(hfig2,'textbox',[.885  0.82*(100-slider_value)/100+0.12  .09 .035], ...
        'String','CRD','HorizontalAlignment','left');
    set(HotBirdProp.handles.axial_crd_text1,'LineStyle','none');
    set(HotBirdProp.handles.axial_crd_text1,'FontWeight','bold');
    set(HotBirdProp.handles.axial_crd_text1,'FontSize',10);
    set(HotBirdProp.handles.axial_crd_text1,'FontUnits', 'normalized');
    set(HotBirdProp.handles.axial_crd_text1,'BackgroundColor', [0.99,0.99,0.99]);
    
    HotBirdProp.handles.axial_crd_text2=annotation(hfig2,'textbox',[.955  0.02  .04 .03], ...
        'String','%','HorizontalAlignment','center');
    set(HotBirdProp.handles.axial_crd_text2,'LineStyle','none');
    set(HotBirdProp.handles.axial_crd_text2,'FontWeight','bold');
    set(HotBirdProp.handles.axial_crd_text2,'FontSize',10);
    set(HotBirdProp.handles.axial_crd_text2,'FontUnits', 'normalized');
    set(HotBirdProp.handles.axial_crd_text2,'BackgroundColor', [0.99,0.99,0.99]);
    
    
    set(hfig,'userdata',HotBirdProp);
    
end
end


%%

function  axial_crd_slider_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
slider_value=get(HotBirdProp.handles.axial_crd_slider,'value');
HotBirdProp.cs.crd=slider_value;

if(slider_value==100)
    slider_value=99.99;
end

set(HotBirdProp.handles.axial_crd_axes,  'position',[0.90 0.11 0.05 0.82*(100-slider_value)/100]);
ce=sprintf('%3.0f',slider_value);
set(HotBirdProp.handles.axial_crd_edit,'string',ce);
set(HotBirdProp.handles.axial_crd_text1,'position',[0.885 0.82*(100-slider_value)/100+0.12 .09 .035]);

HotBirdProp=get(hfig,'userdata');
% paint_btf([],[],hfig);


set(hfig,'userdata',HotBirdProp);
end


function  axial_crd_edit_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');

Str=get(HotBirdProp.handles.axial_crd_edit,'string');
Val=sscanf(Str,'%f');
HotBirdProp.cs.crd=Val;

if(Val==100)
    Val=99.99;
end

set(HotBirdProp.handles.axial_crd_axes,  'position',[0.90 0.11 0.05 0.82*(100-Val)/100]);
set(HotBirdProp.handles.axial_crd_text1,'position',[0.885 0.82*(100-Val)/100+0.12 .09 .035]);


HotBirdProp=get(hfig,'userdata');
paint_btf([],[],hfig);


set(hfig,'userdata',HotBirdProp);
end



function  axial_slider_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
[~,cnmax] = size(HotBirdProp.cs.s);

% Selected axial zone
for i=1:cnmax
    if (src==HotBirdProp.handles.axial_slider(i))
        zone=i;
    end
end

slider_value = round(get(src,'Value'));

HotBirdProp.cs.s(zone).axial_zone(zone)=slider_value/100;

axsum=0;
for i=1:cnmax
    axsum=axsum+round((HotBirdProp.cs.s(i).axial_zone(i))*100);
end

edit_str = sprintf('%d', slider_value);
set(HotBirdProp.handles.axial_edit(zone),'String',edit_str);
set( HotBirdProp.handles.axial_edit(zone),'Value',slider_value);


ax=zeros(25,1);
for i=1:cnmax
    ax(i)=HotBirdProp.cs.s(i).axial_zone(i);
end
sum=0;

for i=1:cnmax
    set(HotBirdProp.handles.axial_axes(i),     'position',[0.20 0.11+sum 0.11 0.82*ax(i)]);
    set(HotBirdProp.handles.axial_text_u235(i),'position',[0.20  0.10+sum  0.115 0.04]);
    set(HotBirdProp.handles.axial_edit(i),     'position',[.33  0.11+sum .07 .03]);
    set(HotBirdProp.handles.axial_slider(i),   'position',[.42 0.11+sum  .10 .030]);
    set(HotBirdProp.handles.axial_checkbox(i), 'position',[0.02  0.11+sum .16 .03]);
    set(HotBirdProp.handles.axial_text_segmentname(i),'position', [0.54  0.11+sum .34 .03]);
    sum = 0.82*ax(i) + sum;   
end

ce=sprintf('Total  %d ', axsum);
set(HotBirdProp.handles.axial_text_procsum1,'String',ce);

set(hfig,'userdata',HotBirdProp);

end

%%
function  axial_edit_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
[~,cnmax] = size(HotBirdProp.cs.s);

% Selected axial zone
for i=1:cnmax
    if (src==HotBirdProp.handles.axial_edit(i))
        zone=i;
    end
end

AxStr = get(src,'String');
AxVal=sscanf(AxStr,'%f');
HotBirdProp.cs.s(zone).axial_zone(zone)=AxVal/100;

axsum=0;
for i=1:cnmax
    axsum=axsum+(HotBirdProp.cs.s(i).axial_zone(i))*100;
end

set( HotBirdProp.handles.axial_slider(zone) ,'Value',AxVal);

ax=zeros(25,1);
for i=1:cnmax
    ax(i)=HotBirdProp.cs.s(i).axial_zone(i);
end
sum=0;
for i=1:cnmax
    set(HotBirdProp.handles.axial_axes(i),     'position',[0.26 0.11+sum 0.13 0.82*ax(i)]);
    set(HotBirdProp.handles.axial_text_u235(i),'position',[0.27 0.11+sum 0.115  0.04]);
    set(HotBirdProp.handles.axial_edit(i),     'position',[0.42 0.11+sum 0.07  0.03]);
    set(HotBirdProp.handles.axial_slider(i),   'position',[0.50 0.11+sum 0.10  0.030]);
    set(HotBirdProp.handles.axial_checkbox(i), 'position',[0.02 0.11+sum 0.22  0.030]);
    set(HotBirdProp.handles.axial_text_segmentname(i),'position', [0.61 0.11+sum 0.38 0.03]);
    sum = 0.82*ax(i) + sum;
end
ce=sprintf('Total  %d ', axsum);
set(HotBirdProp.handles.axial_text_procsum1,'String',ce);

set(hfig,'userdata',HotBirdProp);

end
%%

















