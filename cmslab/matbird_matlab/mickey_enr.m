function mickey_enr(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

cn=HotBirdProp.cn;
pt=get(HotBirdProp.handles.enrlegend,'Currentpoint');
i=round(pt(1,2));
j=round(pt(1,1));

if (HotBirdProp.button ~= 6)
    U235BA.i=(j-1)*10+i;
    U235BA.j=j;
    HotBirdProp.U235BA.i=(j-1)*10+i;
    HotBirdProp.U235BA.j=j;
    u235=HotBirdProp.cs.s(cn).fue((j-1)*10+i,3);
    u235Str=sprintf('%4.2f',u235);
    ba=HotBirdProp.cs.s(cn).fue((j-1)*10+i,5);
    baStr=sprintf('%4.2f',ba);
    
    if HotBirdProp.FirstEnrCall,
        NewFigure1=1;
    else
        if ishandle(HotBirdProp.U235BA.hfig1),
            NewFigure1=0;
        else
            NewFigure1=1;
        end
    end
    
    if NewFigure1,
        scrsz=HotBirdProp.scrsz;
        sidy=scrsz(4)/4.6;
        sidx=1.2*sidy;
        hfig1=figure('position',[scrsz(4)/1.0 scrsz(3)/12 sidx sidy]);
        set(hfig1,'Name','U235 and BA');
        set(hfig1,'color',[.99 .99 .99]);
        set(hfig1,'Menubar','none');
        set(hfig1,'numbertitle','off');
        % U235 textbox
        h.u235text=annotation(hfig1,'textbox',[0.05 0.85 0.12 0.08],'String','U235','HorizontalAlignment','center');
        set(h.u235text,'LineStyle','none');
        set(h.u235text,'FontWeight','bold');
        set(h.u235text,'FontSize', 11);
        set(h.u235text,'FontUnits', 'normalized');
        %U235 edit
        h.u235=uicontrol('Style','edit','Units','Normalized','position',[0.20 .85 0.15 .08], ...
            'string',u235Str,'callback',{@u235_edit_callback,hfig});
        set(h.u235,'BackgroundColor', [0.97,0.97,0.97]);
        set(h.u235, 'FontSize', 11);
        set(h.u235, 'FontUnits', 'normalized');
        set(h.u235,'FontWeight','bold');
        %U235 slider
        h.u235slider = uicontrol(hfig1,'Style','slider',...
            'Max',1000, 'Min',0, 'Value',1, 'SliderStep',[0.001 0.01], 'Units','normalized',...
            'Position',[.40 .87 .50 .06],'Callback', {@u235_slider_callback,hfig});
        set(h.u235slider,'BackgroundColor', [0.97,0.97,0.97]);
        
        
        
        % BA textbox
        h.batext=annotation(hfig1,'textbox',[.05 .70 .12 .08],'String','BA  ','HorizontalAlignment','center');
        set(h.batext,'LineStyle','none');
        set(h.batext,'FontWeight','bold');
        set(h.batext,'FontSize', 11);
        set(h.batext,'FontUnits', 'normalized');
        %BA edit
        h.ba=uicontrol('Style','edit','Units','Normalized','position',[0.20 0.70 0.15 .08], ...
            'string',baStr,'callback',{@ba_edit_callback,hfig});
        set(h.ba,'BackgroundColor', [0.97,0.97,0.97]);
        set(h.ba, 'FontSize', 11);
        set(h.ba, 'FontUnits', 'normalized');
        set(h.ba,'FontWeight','bold');
        %BA slider
        h.baslider = uicontrol(hfig1,'Style','slider',...
            'Max',1000, 'Min',0, 'Value',1, 'SliderStep',[0.001 0.01], 'Units','normalized',...
            'Position',[.40 .71 .50 .06],'Callback', {@ba_slider_callback,hfig});
        set(h.baslider,'BackgroundColor', [0.97,0.97,0.97]);
        
        
        % Add Rod pushbutton
        h.addrod_button=uicontrol (hfig1, 'style', 'pushbutton', 'string', 'Add Rod', 'FontWeight','bold', ...
            'units','Normalized','position', [0.05 0.50 0.27 0.10], 'callback', {@addrod,hfig});
        set(h.addrod_button,'BackgroundColor', [0.97,0.97,0.97]);
        set(h.addrod_button, 'FontSize', 11);
        set(h.addrod_button, 'FontUnits', 'normalized');
        set(h.addrod_button,'FontWeight','bold');
        
        
        % Del Rod pushbutton
        h.delrod_button=uicontrol (hfig1, 'style', 'pushbutton', 'string', 'Del Rod', 'FontWeight','bold', ...
            'units','Normalized','position', [0.34 0.50 0.27 0.10], 'callback', {@delrod,hfig});
        set(h.delrod_button,'BackgroundColor', [0.97,0.97,0.97]);
        set(h.delrod_button, 'FontSize', 11);
        set(h.delrod_button, 'FontUnits', 'normalized');
        set(h.delrod_button,'FontWeight','bold');
        
        
        
        % Sort Rod pushbutton
        h.sortrods_button=uicontrol (hfig1, 'style', 'pushbutton', 'string', 'Sort Rods', 'FontWeight','bold', ...
            'units','Normalized','position', [0.63 0.50 0.27 .10], 'callback', {@sortrods,hfig});
        
        set(h.sortrods_button,'BackgroundColor', [0.97,0.97,0.97]);
        set(h.sortrods_button, 'FontSize', 11);
        set(h.sortrods_button, 'FontUnits', 'normalized');
        set(h.sortrods_button,'FontWeight','bold');
        
        %%   Fuel vendor checkbox
        h.fuel_vendor=uicontrol('Style','checkbox','Units','Normalized', ...
            'position',[0.05 0.30 0.95 0.10] ,'string','Standard fuel vendor enrichments', 'FontWeight','bold');
        set(h.fuel_vendor, 'FontSize', 11);
        set(h.fuel_vendor, 'FontUnits', 'normalized');
        set(h.fuel_vendor,'BackgroundColor', [1,1,1]);
        set(h.fuel_vendor,'BackgroundColor', [0.99,0.99,0.99]);
        set(h.fuel_vendor,'value',1);
        %%
        HotBirdProp.FirstEnrCall=0;
        U235BA.handles=h;
        U235BA.hfig=hfig;
        U235BA.hfig1=hfig1;
    else
        U235BA=HotBirdProp.U235BA;
        hfig1=U235BA.hfig1;
        set(HotBirdProp.U235BA.handles.u235,'string',u235Str);
        set(HotBirdProp.U235BA.handles.ba,'string',baStr);
        set(hfig,'userdata',HotBirdProp);
    end
    
    u235_slider_value=round(u235*100);
    set(U235BA.handles.u235slider,'Value',u235_slider_value);
    U235BA.u235=u235;
    U235BA.u235Str=u235Str;
    ba_slider_value=round(ba*100);
    set(U235BA.handles.baslider,'Value',ba_slider_value);
    U235BA.ba=ba;
    U235BA.baStr=baStr;
    HotBirdProp.U235BA=U235BA;
    set(hfig1,'userdata',U235BA);
    set(hfig,'userdata',HotBirdProp);
else
    HotBirdProp.Rod.i=i;
    HotBirdProp.Rod.j=j;
    
    if HotBirdProp.FirstRodCall,
        NewFigure4=1;
    else
        if (ishandle(HotBirdProp.Rod.hfig4))
            NewFigure4=0;
        else
            NewFigure4=1;
        end
    end
    
    if NewFigure4,
        scrsz=HotBirdProp.scrsz;
        sidy=scrsz(4)/1.7;
        sidx=0.5*sidy;
        hfig4=figure('position',[scrsz(4)/1.2 scrsz(3)/12 sidx sidy]);
        set(hfig4,'Name','Axial Rod');
        set(hfig4,'color',[.99 .99 .99]);
        set(hfig4,'Menubar','none');
        set(hfig4,'numbertitle','off');
        set(hfig4,'userdata',HotBirdProp);
        
        cnmax=HotBirdProp.cs.cnmax;
        ax=zeros(25,1);
        axsum=0;
        for i=1:cnmax
            ax(i)=HotBirdProp.cs.s(i).axial_zone(i);
            axsum=axsum+ax(i);
        end
        
        sum=0;
        for i=1:cnmax
            HotBirdProp.Rod.handles.axialrod_axes(i)=axes('position',[0.10 0.11+sum 0.20 0.75*ax(i)]);
            HotBirdProp.clmap = colormap(jett);
            
            if(HotBirdProp.cs.rod(HotBirdProp.cs.nr_rod+HotBirdProp.Rod.i+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.j-HotBirdProp.Rod.j,i) == 0)
                image(1);
            else
                image(i+1);
            end
            
            set(gca,'XTick',[],'YTick',[]);
            
            if (HotBirdProp.cs.rod(HotBirdProp.cs.nr_rod+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.i,i) == 0)
                
                ce = sprintf('empty');
            else
                ce = sprintf('%4.2f U235', HotBirdProp.cs.rod(HotBirdProp.cs.nr_rod+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.i,i));
            end
            text(1, 1, ce,...
                'Color', 'black',...
                'FontSize', 10,...
                'FontUnits', 'normalized',...
                'FontWeight', 'bold',...
                'VerticalAlignment', 'top',...
                'HorizontalAlignment', 'center',...
                'ButtonDownFcn',{@mickey_patron,hfig});
            
            
            if (HotBirdProp.cs.rod(2*HotBirdProp.cs.nr_rod+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.i,i) == 0)
                ce = sprintf(' ');
            else
                ce = sprintf('%4.2f Gd  ', HotBirdProp.cs.rod(HotBirdProp.cs.nr_rod*2+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.i,i));
            end
            text(1, 1, ce,...
                'Color', 'black',...
                'FontSize', 10,...
                'FontUnits', 'normalized',...
                'FontWeight', 'bold',...
                'VerticalAlignment', 'bottom',...
                'HorizontalAlignment', 'center',...
                'ButtonDownFcn',{@mickey_patron,hfig});
            
            sum = 0.75*ax(i) + sum;
            
        end
        
        ce = sprintf('Mean Rod U235 %5.3f w/o', HotBirdProp.cs.rod((HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.i,2));
        HotBirdProp.Rod.handles.axialrod_text_rodu235=annotation(hfig4,'textbox',[0.03  0.90  .50 .04], ...
            'String',ce,'HorizontalAlignment','center');
        set(HotBirdProp.Rod.handles.axialrod_text_rodu235,'LineStyle','none');
        set(HotBirdProp.Rod.handles.axialrod_text_rodu235,'FontWeight','bold');
        set(HotBirdProp.Rod.handles.axialrod_text_rodu235,'FontSize', 10);
        set(HotBirdProp.Rod.handles.axialrod_text_rodu235,'FontUnits', 'normalized');
        %         set(HotBirdProp.Rod.handles.axialrod_text_rodu235,'BackgroundColor', [0.95,0.95,0.95]);
        
        HotBirdProp.FirstRodCall=0;
        HotBirdProp.Rod.hfig4=hfig4;
    else
        cnmax=HotBirdProp.cs.cnmax;
        ce = sprintf('Rod U235 %5.3f w/o', HotBirdProp.cs.rod(HotBirdProp.Rod.i,2));
        set(HotBirdProp.Rod.handles.axialrod_text_rodu235,'string',ce);
        sum=0;
        axsum=0;
        for i=1:cnmax
            ax(i)=HotBirdProp.cs.s(i).axial_zone(i);
            axsum=axsum+ax(i);
        end
        for i=1:cnmax
            axes(HotBirdProp.Rod.handles.axialrod_axes(i));
            reset(gca);
            %             hold 'on';
            sum = 0.75*ax(i) + sum;
            if(HotBirdProp.cs.rod(HotBirdProp.cs.nr_rod+HotBirdProp.Rod.i+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.j-HotBirdProp.Rod.j,i) == 0)
                image(1);
            else
                image(i+1);
            end
            set(gca,'XTick',[],'YTick',[]);
            
            if (HotBirdProp.cs.rod(HotBirdProp.cs.nr_rod+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.i,i) == 0)
                ce = sprintf('empty');
            else
                ce = sprintf('%4.2f U235', HotBirdProp.cs.rod(HotBirdProp.cs.nr_rod+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.i,i));
            end
            text(1, 1, ce,...
                'Color', 'black',...
                'FontSize', 10,...
                'FontUnits', 'normalized',...
                'FontWeight', 'bold',...
                'VerticalAlignment', 'top',...
                'HorizontalAlignment', 'center',...
                'ButtonDownFcn',{@mickey_patron,hfig});
            
            if (HotBirdProp.cs.rod(2*HotBirdProp.cs.nr_rod+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.i,i) == 0)
                ce = sprintf(' ');
            else
                ce = sprintf('%4.2f Gd  ', HotBirdProp.cs.rod(HotBirdProp.cs.nr_rod*2+(HotBirdProp.Rod.j-1)*10+HotBirdProp.Rod.i,i));
            end
            text(1, 1, ce,...
                'Color', 'black',...
                'FontSize', 10,...
                'FontUnits', 'normalized',...
                'FontWeight', 'bold',...
                'VerticalAlignment', 'bottom',...
                'HorizontalAlignment', 'center',...
                'ButtonDownFcn',{@mickey_patron,hfig});
            
            
        end
        
    end
    
    set(hfig,'userdata',HotBirdProp);
end


end


function  ba_edit_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
HotBirdProp.U235BA.baStr = get(src,'String');
HotBirdProp.U235BA.ba=sscanf(HotBirdProp.U235BA.baStr,'%f');
set(HotBirdProp.U235BA.handles.ba,'Value', HotBirdProp.U235BA.ba);
set(HotBirdProp.U235BA.handles.baslider,'String',HotBirdProp.U235BA.baStr);
set(HotBirdProp.U235BA.handles.baslider,'Value',HotBirdProp.U235BA.ba*100);

for m=1:HotBirdProp.cs.cnmax
    if(HotBirdProp.axial_change(m)==1)
        HotBirdProp.cs.s(m).fue(HotBirdProp.U235BA.i,5)=HotBirdProp.U235BA.ba;
        k=0;
        HotBirdProp.cs.s(m).nr_ba = 0;
        for i=1:HotBirdProp.cs.s(m).nr_fue
            if (HotBirdProp.cs.s(m).fue(i,5) > 0)
                k=k+1;
                HotBirdProp.cs.s(m).nr_ba = HotBirdProp.cs.s(m).nr_ba + 1;
                HotBirdProp.cs.s(m).fue(i,4)=7299+k;
            end
        end
        if (HotBirdProp.cs.s(m).fue(HotBirdProp.U235BA.i,5) == 0)
            HotBirdProp.cs.s(m).fue(HotBirdProp.U235BA.i,4) = nan;
            HotBirdProp.cs.s(m).fue(HotBirdProp.U235BA.i,5) = nan;
            set(HotBirdProp.U235BA.handles.ba,'String','NaN');
        end
        HotBirdProp.cs.s(m).update_enr_ba();
    end
end

set(hfig,'userdata',HotBirdProp);
paint_enr([],[],hfig);

if (HotBirdProp.button == 1)
    paint_patron([],[],hfig);
elseif (HotBirdProp.button == 2)
    paint_pow([],[],hfig);
elseif (HotBirdProp.button == 3)
    paint_exp([],[],hfig);
elseif (HotBirdProp.button == 4)
    paint_btf([],[],hfig);
end

end


function  u235_edit_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
HotBirdProp.U235BA.u235Str = get(src,'String');
HotBirdProp.U235BA.u235=sscanf(HotBirdProp.U235BA.u235Str,'%f');

for k=1:HotBirdProp.cs.cnmax
    if(HotBirdProp.axial_change(k) ==1)
        HotBirdProp.cs.s(k).fue(HotBirdProp.U235BA.i,3)=HotBirdProp.U235BA.u235;
        HotBirdProp.cs.s(k).update_enr_ba();
    end
end

set(HotBirdProp.U235BA.handles.u235,'Value', HotBirdProp.U235BA.u235);

set(HotBirdProp.U235BA.handles.u235slider,'String',HotBirdProp.U235BA.u235Str);
set(HotBirdProp.U235BA.handles.u235slider,'Value',HotBirdProp.U235BA.u235*100);

set(hfig,'userdata',HotBirdProp);
paint_enr([],[],hfig);

if (HotBirdProp.button == 1)
    paint_patron([],[],hfig);
elseif (HotBirdProp.button == 2)
    paint_pow([],[],hfig);
elseif (HotBirdProp.button == 3)
    paint_exp([],[],hfig);
elseif (HotBirdProp.button == 4)
    paint_btf([],[],hfig);
end

end


function  u235_slider_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
slider_value = get(src,'Value');

cn = HotBirdProp.cn;

if (get(HotBirdProp.U235BA.handles.fuel_vendor,'value'))
    [mz,~] = size(HotBirdProp.cs.s(cn).standard_u235);
    m=1;
    u235_diff = slider_value/100 - HotBirdProp.cs.s(cn).fue(HotBirdProp.U235BA.i,3);
    if (u235_diff > 0.011)
        slider_value = slider_value - 1;
    elseif (u235_diff < -0.011)
        slider_value = slider_value + 1;
    end
    if (slider_value/100 <= HotBirdProp.cs.s(cn).standard_u235(m))
        slider_value = HotBirdProp.cs.s(cn).standard_u235(m)*100;
    elseif (slider_value/100 >= HotBirdProp.cs.s(cn).standard_u235(mz))
        slider_value = HotBirdProp.cs.s(cn).standard_u235(mz)*100;
    else
        u235_old = HotBirdProp.cs.s(cn).fue(HotBirdProp.U235BA.i,3);
        while( m < mz && HotBirdProp.cs.s(cn).standard_u235(m) < slider_value/100)
            m=m+1;
        end
        if(slider_value/100 > u235_old)
            slider_value = round(HotBirdProp.cs.s(cn).standard_u235(m)*100);
        else
            slider_value = round(HotBirdProp.cs.s(cn).standard_u235(m-1)*100);
        end
    end
end

for k=1:HotBirdProp.cs.cnmax
    if(HotBirdProp.axial_change(k) ==1)
        HotBirdProp.cs.s(k).fue(HotBirdProp.U235BA.i,3)=slider_value/100;
        HotBirdProp.cs.s(k).update_enr_ba();
    end
end

set(src,'value',slider_value);

u235 = slider_value/100;
HotBirdProp.U235BA.u235Str = sprintf('%4.2f', u235);
set(HotBirdProp.U235BA.handles.u235,'String',HotBirdProp.U235BA.u235Str);
set(hfig,'userdata',HotBirdProp);
paint_enr([],[],hfig);


if (HotBirdProp.button == 1)
    paint_patron([],[],hfig);
elseif (HotBirdProp.button == 2)
    paint_pow([],[],hfig);
elseif (HotBirdProp.button == 3)
    paint_exp([],[],hfig);
elseif (HotBirdProp.button == 4)
    paint_btf([],[],hfig);
end

end


function  ba_slider_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
slider_value = get(src,'Value');

cn = HotBirdProp.cn;

if (get(HotBirdProp.U235BA.handles.fuel_vendor,'value'))
    [mz,~] = size(HotBirdProp.cs.s(cn).standard_ba);
    m=1;
    ba_diff = slider_value/100 - HotBirdProp.cs.s(cn).fue(HotBirdProp.U235BA.i,5);
    if (ba_diff > 0.011)
        slider_value = slider_value - 1;
    elseif (ba_diff < -0.011)
        slider_value = slider_value + 1;
    end
    if (slider_value/100 <= HotBirdProp.cs.s(cn).standard_ba(m))
        slider_value = HotBirdProp.cs.s(cn).standard_ba(m)*100;
    elseif (slider_value/100 >= HotBirdProp.cs.s(cn).standard_ba(mz))
        slider_value = HotBirdProp.cs.s(cn).standard_ba(mz)*100;
    else
        ba_old = HotBirdProp.cs.s(cn).fue(HotBirdProp.U235BA.i,5);
        while( m < mz && HotBirdProp.cs.s(cn).standard_ba(m) < slider_value/100)
            m=m+1;
        end
        if(slider_value/100 > ba_old)
            slider_value = round(HotBirdProp.cs.s(cn).standard_ba(m)*100);
        else
            slider_value = round(HotBirdProp.cs.s(cn).standard_ba(m-1)*100);
        end
    end
end

ba=slider_value/100;
HotBirdProp.U235BA.baStr = sprintf('%4.2f', ba);
set(HotBirdProp.U235BA.handles.ba,'String',HotBirdProp.U235BA.baStr);

for m=1:HotBirdProp.cs.cnmax
    if(HotBirdProp.axial_change(m) ==1)
        HotBirdProp.cs.s(m).fue(HotBirdProp.U235BA.i,5)=slider_value/100;
        k=0;
        HotBirdProp.cs.s(m).nr_ba = 0;
        for i=1:HotBirdProp.cs.s(m).nr_fue
            if (HotBirdProp.cs.s(m).fue(i,5) > 0)
                k=k+1;
                HotBirdProp.cs.s(m).nr_ba = HotBirdProp.cs.s(m).nr_ba + 1;
                HotBirdProp.cs.s(m).fue(i,4)=7299+k;
            end
        end
        if (HotBirdProp.cs.s(m).fue(HotBirdProp.U235BA.i,5) == 0)
            HotBirdProp.cs.s(m).fue(HotBirdProp.U235BA.i,4) = nan;
            HotBirdProp.cs.s(m).fue(HotBirdProp.U235BA.i,5) = nan;
            set(HotBirdProp.U235BA.handles.ba,'String','NaN');
        end
        HotBirdProp.cs.s(m).update_enr_ba();
    end
end

set(src,'value',slider_value);
set(hfig,'userdata',HotBirdProp);
paint_enr([],[],hfig);

if (HotBirdProp.button == 1)
    paint_patron([],[],hfig);
elseif (HotBirdProp.button == 2)
    paint_pow([],[],hfig);
elseif (HotBirdProp.button == 3)
    paint_exp([],[],hfig);
elseif (HotBirdProp.button == 4)
    paint_btf([],[],hfig);
end

end


function  addrod(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
i=HotBirdProp.U235BA.i;


for m=1:HotBirdProp.cs.cnmax
    if(HotBirdProp.axial_change(m) ==1)
        HotBirdProp.cs.s(m).addrod(i);
    end
end

sortrods([],[],hfig);
set(hfig,'userdata',HotBirdProp);
paint_enr([],[],hfig);
end


function  delrod(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
i=HotBirdProp.U235BA.i;

for m=1:HotBirdProp.cs.cnmax
    if(HotBirdProp.axial_change(m) ==1)
        HotBirdProp.cs.s(m).delrod(i);
    end
end

sortrods([],[],hfig);
set(hfig,'userdata',HotBirdProp);
paint_enr([],[],hfig);
end


function  sortrods(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

for k=1:HotBirdProp.cs.cnmax
    if(HotBirdProp.axial_change(k) ==1)
        HotBirdProp.cs.s(k).sortrods();
    end
end

paint_enr([],[],hfig);
paint_patron([],[],hfig);
set(hfig,'userdata',HotBirdProp);

end

