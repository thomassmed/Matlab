function paint_btf(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
axes(HotBirdProp.handles.patron);
reset(gca);

cn= HotBirdProp.cn;
nr=HotBirdProp.cs.s(cn).point_nr;
bur= HotBirdProp.cs.s(cn).burnup(HotBirdProp.cs.s(cn).point_nr);
burnr= HotBirdProp.cs.s(cn).point_nr;
fint=HotBirdProp.cs.s(cn).fint(burnr);
kinf=HotBirdProp.cs.s(cn).kinf(burnr);

if(HotBirdProp.handles.selection_textbox == 0)
    HotBirdProp.handles.selection_textbox = annotation(hfig,'textbox',[.785 .81 .20 .04], ...
        'string','ENR                     BTF','fontweight','bold','LineStyle','none');
    set(HotBirdProp.handles.selection_textbox, 'FontSize', 10);
    set(HotBirdProp.handles.selection_textbox, 'FontUnits', 'normalized');
else
    set(HotBirdProp.handles.selection_textbox,'string','ENR                     BTF');
end
HotBirdProp.button=4;

if (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 0)
    HotBirdProp.cs.calc_u235();
    HotBirdProp.cs.calc_btfax();
    cmax = HotBirdProp.cs.maxbtfax(nr,1);
    cmin = 0.95*cmax;
    ncol = 10;
    plmat=ncol*HotBirdProp.cs.btfax(:,:,nr)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    
    for i=1:HotBirdProp.cs.s(cn).npst
        for j=1:HotBirdProp.cs.s(cn).npst
            if(plmat(i,j) > ncol)
                plmat(i,j) = ncol;
            end
        end
    end
    
    image(plmat,'ButtonDownFcn',{@mickey_patron,hfig});
    set(gca,'XTick',[],'YTick',[]);
    
    hold on;
    
    cmax = HotBirdProp.cs.s(cn).nr_fue;
    cmin = min(min(HotBirdProp.cs.s(cn).lfu));
    ncol = HotBirdProp.cs.s(cn).nr_fue;
    enrmat=ncol*HotBirdProp.cs.s(cn).lfu/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    
    
    
    if(strcmp(HotBirdProp.cs.s(cn).type, 'Atrium10'))
        rectangle('Position',[4.5, 4.5, 3, 3], 'LineWidth',2,'FaceColor',[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'GE14')||strcmp(HotBirdProp.cs.s(cn).type, 'GNF2'))
        t = 0 : 0.1 : 2*pi;
        x = 1.0*cos(t) + 4.5;
        y = 1.0*sin(t) + 6.5;
        fill(x, y,[0.8,0.9,1])
        y = 1.0*cos(t) + 4.5;
        x = 1.0*sin(t) + 6.5;
        axis('square');
        fill(x, y,[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'Svea96Optima2'))
        
        x =[5.7,5.7,4.5,0.0,0.0,4.5,5.7, 5.7, 6.3, 6.3, 7.5,11.5,11.5, 7.5, 6.3, 6.3];
        y =[0.0,4.5,5.7,5.7,6.3,6.3,7.5,11.5,11.5, 7.5, 6.3, 6.3, 5.7, 5.7, 4.5, 0.0];
        fill(x,y,[0.8,0.9,1],'LineWidth',2);
    end
    
    t = 0 : 0.05 : 2*pi;
    for i = 1 : HotBirdProp.cs.s(cn).npst
        for j = 1 : HotBirdProp.cs.s(cn).npst
            x = 0.38*cos(t) + i;
            y = 0.38*sin(t) + j;
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
                fill(x, y,HotBirdProp.clmap(enrmat(i,j),:), 'ButtonDownFcn',{@mickey_patron,hfig});
                rectangle('Position',[i-0.5, j-0.5, 1, 1], 'LineWidth',1);
            end
        end
    end
    
    for i=1:HotBirdProp.cs.s(cn).npst
        for j=1:HotBirdProp.cs.s(cn).npst
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
                if(HotBirdProp.cs.s(cn).ba(i,j) > 0);
                    ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 9,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'VerticalAlignment', 'bottom',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                    ce=sprintf('BA');
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 9,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'VerticalAlignment', 'top',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                else
                    ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 10,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                end
            end
        end
    end
    
    cc=sprintf('<U235>=%5.3f', HotBirdProp.cs.u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);
    btf=HotBirdProp.cs.maxbtfax(nr,1);
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);
    set(HotBirdProp.handles.bottom_textbox,'string',cc);
    
elseif (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
    HotBirdProp.cs.calc_u235();
    HotBirdProp.cs.calc_btfax_env();
    cmax = HotBirdProp.cs.maxbtfax_env;
    cmin = 0.95*cmax;
    ncol = 10;
    plmat=ncol*HotBirdProp.cs.btfax_env(:,:)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    
    for i=1:HotBirdProp.cs.s(cn).npst
        for j=1:HotBirdProp.cs.s(cn).npst
            if(plmat(i,j) > ncol)
                plmat(i,j) = ncol;
            end
        end
    end
    
    image(plmat, 'ButtonDownFcn',{@mickey_patron,hfig});
    set(gca,'XTick',[],'YTick',[]);
    
    hold on;
    cmax = HotBirdProp.cs.s(cn).nr_fue;
    cmin = min(min(HotBirdProp.cs.s(cn).lfu));
    ncol = HotBirdProp.cs.s(cn).nr_fue;
    enrmat=ncol*HotBirdProp.cs.s(cn).lfu/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    
    if(strcmp(HotBirdProp.cs.s(cn).type, 'Atrium10'))
        rectangle('Position',[4.5, 4.5, 3, 3], 'LineWidth',2,'FaceColor',[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'GE14')||strcmp(HotBirdProp.cs.s(cn).type, 'GNF2'))
        t = 0 : 0.1 : 2*pi;
        x = 1.0*cos(t) + 4.5;
        y = 1.0*sin(t) + 6.5;
        fill(x, y,[0.8,0.9,1])
        y = 1.0*cos(t) + 4.5;
        x = 1.0*sin(t) + 6.5;
        axis('square');
        fill(x, y,[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'Svea96Optima2'))
        
        x =[5.7,5.7,4.5,0.0,0.0,4.5,5.7, 5.7, 6.3, 6.3, 7.5,11.5,11.5, 7.5, 6.3, 6.3];
        y =[0.0,4.5,5.7,5.7,6.3,6.3,7.5,11.5,11.5, 7.5, 6.3, 6.3, 5.7, 5.7, 4.5, 0.0];
        fill(x,y,[0.8,0.9,1],'LineWidth',2);
    end
    
    t = 0 : 0.05 : 2*pi;
    for i = 1 : HotBirdProp.cs.s(cn).npst
        for j = 1 : HotBirdProp.cs.s(cn).npst
            x = 0.38*cos(t) + i;
            y = 0.38*sin(t) + j;
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
                fill(x, y,HotBirdProp.clmap(enrmat(i,j),:), 'ButtonDownFcn',{@mickey_patron,hfig});
                rectangle('Position',[i-0.5, j-0.5, 1, 1], 'LineWidth',1);
            end
        end
    end
    
    for i=1:HotBirdProp.cs.s(cn).npst
        for j=1:HotBirdProp.cs.s(cn).npst
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
                if(HotBirdProp.cs.s(cn).ba(i,j) > 0);
                    ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 9,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'VerticalAlignment', 'bottom',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                    ce=sprintf('BA');
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 9,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'VerticalAlignment', 'top',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                else
                    ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 10,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                end
            end
        end
    end
    
    cc=sprintf('<U235>=%5.3f', HotBirdProp.cs.u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);
    btf=HotBirdProp.cs.maxbtfax_env;
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);
    set(HotBirdProp.handles.bottom_textbox,'string',cc);
    
elseif (HotBirdProp.axial_btf == 0 && HotBirdProp.kinf_env == 1)
    HotBirdProp.cs.s(cn).calcbtf();

    if(get(HotBirdProp.handles.crd_checkbox,'value') && ~isempty(HotBirdProp.cs.s(cn).pow_crd))
        cmax = HotBirdProp.cs.s(cn).maxbtf_env_crd;
        cmin = 0.95*cmax;
        ncol = 10;
        plmat=ncol*HotBirdProp.cs.s(cn).btf_env_crd(:,:)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    else
        cmax = HotBirdProp.cs.s(cn).maxbtf_env;
        cmin = 0.95*cmax;
        ncol = 10;
        plmat=ncol*HotBirdProp.cs.s(cn).btf_env(:,:)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    end
    
    %     cmax = HotBirdProp.cs.s(cn).maxbtf_env;
    %     cmin = 0.95*cmax;
    %     ncol = 10;
    %     plmat=ncol*HotBirdProp.cs.s(cn).btf_env(:,:)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;

    for i=1:HotBirdProp.cs.s(cn).npst
        for j=1:HotBirdProp.cs.s(cn).npst
            if(plmat(i,j) > ncol)
                plmat(i,j) = ncol;
            end
        end
    end
    
    image(plmat, 'ButtonDownFcn',{@mickey_patron,hfig});
    set(gca,'XTick',[],'YTick',[]);
    
    hold on;
    cmax = HotBirdProp.cs.s(cn).nr_fue;
    cmin = min(min(HotBirdProp.cs.s(cn).lfu));
    ncol = HotBirdProp.cs.s(cn).nr_fue;
    enrmat=ncol*HotBirdProp.cs.s(cn).lfu/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    
    if(strcmp(HotBirdProp.cs.s(cn).type, 'Atrium10'))
        rectangle('Position',[4.5, 4.5, 3, 3], 'LineWidth',2,'FaceColor',[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'GE14')||strcmp(HotBirdProp.cs.s(cn).type, 'GNF2'))
        t = 0 : 0.1 : 2*pi;
        x = 1.0*cos(t) + 4.5;
        y = 1.0*sin(t) + 6.5;
        fill(x, y,[0.8,0.9,1])
        y = 1.0*cos(t) + 4.5;
        x = 1.0*sin(t) + 6.5;
        axis('square');
        fill(x, y,[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'Svea96Optima2'))
        
        x =[5.7,5.7,4.5,0.0,0.0,4.5,5.7, 5.7, 6.3, 6.3, 7.5,11.5,11.5, 7.5, 6.3, 6.3];
        y =[0.0,4.5,5.7,5.7,6.3,6.3,7.5,11.5,11.5, 7.5, 6.3, 6.3, 5.7, 5.7, 4.5, 0.0];
        fill(x,y,[0.8,0.9,1],'LineWidth',2);
    end
    
    t = 0 : 0.05 : 2*pi;
    for i = 1 : HotBirdProp.cs.s(cn).npst
        for j = 1 : HotBirdProp.cs.s(cn).npst
            x = 0.38*cos(t) + i;
            y = 0.38*sin(t) + j;
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
                fill(x, y,HotBirdProp.clmap(enrmat(i,j),:), 'ButtonDownFcn',{@mickey_patron,hfig});
                rectangle('Position',[i-0.5, j-0.5, 1, 1], 'LineWidth',1);
            end
        end
    end
    
    for i=1:HotBirdProp.cs.s(cn).npst
        for j=1:HotBirdProp.cs.s(cn).npst
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
                if(HotBirdProp.cs.s(cn).ba(i,j) > 0);
                    ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 9,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'VerticalAlignment', 'bottom',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                    ce=sprintf('BA');
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 9,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'VerticalAlignment', 'top',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                else
                    ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 10,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                end
            end
        end
    end
    
    
    HotBirdProp.cs.s(cn).calc_u235;
    cc=sprintf('U235=%5.3f', HotBirdProp.cs.s(cn).u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);
    btf=HotBirdProp.cs.s(cn).maxbtf_env;
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);
    set(HotBirdProp.handles.bottom_textbox,'string',cc);
    
else
    HotBirdProp.cs.s(cn).calcbtf();
    
    
    if(get(HotBirdProp.handles.crd_checkbox,'value') && ~isempty(HotBirdProp.cs.s(cn).pow_crd))
        cmax = HotBirdProp.cs.s(cn).maxbtf_crd(nr,1);
        cmin = 0.95*cmax;
        ncol = 10;
        plmat=ncol*HotBirdProp.cs.s(cn).btf_crd(:,:,nr)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    else
        
        cmax = HotBirdProp.cs.s(cn).maxbtf(nr,1);
        cmin = 0.95*cmax;
        ncol = 10;
        plmat=ncol*HotBirdProp.cs.s(cn).btf(:,:,nr)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    end
    
%     cmax = HotBirdProp.cs.s(cn).maxbtf(nr,1);
%     cmin = 0.95*cmax;
%     ncol = 10;
%     plmat=ncol*HotBirdProp.cs.s(cn).btf(:,:,nr)/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    
    for i=1:HotBirdProp.cs.s(cn).npst
        for j=1:HotBirdProp.cs.s(cn).npst
            if(plmat(i,j) > ncol)
                plmat(i,j) = ncol;
            end
        end
    end
    
    image(plmat, 'ButtonDownFcn',{@mickey_patron,hfig});
    set(gca,'XTick',[],'YTick',[]);
    
    
    hold on;
    cmax = HotBirdProp.cs.s(cn).nr_fue;
    cmin = min(min(HotBirdProp.cs.s(cn).lfu));
    ncol = HotBirdProp.cs.s(cn).nr_fue;
    enrmat=ncol*HotBirdProp.cs.s(cn).lfu/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
    
    if(strcmp(HotBirdProp.cs.s(cn).type, 'Atrium10'))
        rectangle('Position',[4.5, 4.5, 3, 3], 'LineWidth',2,'FaceColor',[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'GE14')||strcmp(HotBirdProp.cs.s(cn).type, 'GNF2'))
        t = 0 : 0.1 : 2*pi;
        x = 1.0*cos(t) + 4.5;
        y = 1.0*sin(t) + 6.5;
        fill(x, y,[0.8,0.9,1])
        y = 1.0*cos(t) + 4.5;
        x = 1.0*sin(t) + 6.5;
        axis('square');
        fill(x, y,[0.8,0.9,1]);
    elseif  (strcmp(HotBirdProp.cs.s(cn).type, 'Svea96Optima2'))
        
        x =[5.7,5.7,4.5,0.0,0.0,4.5,5.7, 5.7, 6.3, 6.3, 7.5,11.5,11.5, 7.5, 6.3, 6.3];
        y =[0.0,4.5,5.7,5.7,6.3,6.3,7.5,11.5,11.5, 7.5, 6.3, 6.3, 5.7, 5.7, 4.5, 0.0];
        fill(x,y,[0.8,0.9,1],'LineWidth',2);
    end
    
    t = 0 : 0.05 : 2*pi;
    for i = 1 : HotBirdProp.cs.s(cn).npst
        for j = 1 : HotBirdProp.cs.s(cn).npst
            x = 0.38*cos(t) + i;
            y = 0.38*sin(t) + j;
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
                fill(x, y,HotBirdProp.clmap(enrmat(i,j),:), 'ButtonDownFcn',{@mickey_patron,hfig});
                rectangle('Position',[i-0.5, j-0.5, 1, 1], 'LineWidth',1);
            end
        end
    end
    
    
    for i=1:HotBirdProp.cs.s(cn).npst
        for j=1:HotBirdProp.cs.s(cn).npst
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
                if(HotBirdProp.cs.s(cn).ba(i,j) > 0);
                    ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 9,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'VerticalAlignment', 'bottom',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                    ce=sprintf('BA');
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 9,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'VerticalAlignment', 'top',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                else
                    ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 10,...
                        'FontWeight', 'bold',...
                        'FontUnits', 'normalized',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_patron,hfig});
                end
            end
        end
    end
    
    
    
    
    HotBirdProp.cs.s(cn).calc_u235;
    cc=sprintf('U235=%5.3f', HotBirdProp.cs.s(cn).u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);
    btf=HotBirdProp.cs.s(cn).maxbtf(nr);
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  btf=%5.3f',bur,kinf,fint,btf);
    set(HotBirdProp.handles.bottom_textbox,'string',cc);
end
paint_enr([],[],hfig);
HotBirdProp=data_slider(HotBirdProp);
set(hfig,'userdata',HotBirdProp);

end
