function paint_rod(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
axes(HotBirdProp.handles.patron);
reset(gca);
if(HotBirdProp.handles.selection_textbox == 0)
    HotBirdProp.handles.selection_textbox = annotation(hfig,'textbox',[.785 .81 .20 .04], ...
        'string','ROD            ','fontweight','bold','LineStyle','none');
    set(HotBirdProp.handles.selection_textbox, 'FontSize', 10);
    set(HotBirdProp.handles.selection_textbox, 'FontUnits', 'normalized');
else
    set(HotBirdProp.handles.selection_textbox,'string','ROD         ');
end
vitmat=ones(HotBirdProp.cs.s(cn).npst)*1;
image(vitmat,'ButtonDownFcn',{@mickey_patron,hfig});

set(gca,'XTick',[],'YTick',[]);

HotBirdProp.button=6;
HotBirdProp.cs.calc_rod();
A=unique(HotBirdProp.cs.rodtype);
color = zeros(HotBirdProp.cs.s(cn).npst);

for k=1:HotBirdProp.cs.nr_rod
    for i = 1 : HotBirdProp.cs.s(cn).npst
        for j = 1 : HotBirdProp.cs.s(cn).npst
            if(HotBirdProp.cs.rodtype(i,j) == HotBirdProp.cs.rodtype2(k,1))
                color(i,j) = k+1;
            end
        end
    end
end

hold on;

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
        if (HotBirdProp.cs.rodenr(i,j) > 0)
            fill(x, y,HotBirdProp.clmap(color(i,j),:), 'ButtonDownFcn',{@mickey_patron,hfig});
            % rectangle('Position',[i-0.5, j-0.5, 1, 1], 'LineWidth',1);
        end
    end
end


for i=1:HotBirdProp.cs.npst
    for j=1:HotBirdProp.cs.npst
        if (HotBirdProp.cs.rodenr(i,j) > 0)
            if(HotBirdProp.cs.s(cn).ba(i,j) > 0);
                ce=sprintf('BA');
                text(j, i, ce,...   
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontWeight', 'bold',...
                    'FontUnits', 'normalized',...
                    'VerticalAlignment', 'middle',...
                    'HorizontalAlignment', 'center',...
                    'ButtonDownFcn',{@mickey_patron,hfig});      
            else
                ce=sprintf('%4.2f',HotBirdProp.cs.rodenr(i,j));
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


axes(HotBirdProp.handles.enrlegend);
reset(gca);

A=unique(color);

vitmat=ones(10,2);
image(vitmat,'ButtonDownFcn',{@mickey_enr,hfig});
set(gca,'XTick',[],'YTick',[]);

hold on;
t = 0 : 0.05 : 2*pi;
for i = 1 : 20
    if(i <= HotBirdProp.cs.nr_rod)
        if (i<11)
            x = 0.4*cos(t)+1;
            y = 0.4*10/HotBirdProp.cs.s(cn).npst*sin(t)+i;
        else
            x = 0.4*cos(t)+2;
            y = 0.4*10/HotBirdProp.cs.s(cn).npst*sin(t)+i-10;     
        end
        fill(x, y,HotBirdProp.clmap(A(i+1),:), 'ButtonDownFcn',{@mickey_enr,hfig})
    end
end


for i=1:HotBirdProp.cs.nr_rod
    if (i<11)
        k=1;
    else
        k=2;
    end
    
    if(HotBirdProp.cs.rod(i,3) == 0)
        ce=sprintf('%4.2f',HotBirdProp.cs.rod(i,2));
        text(k, i-(k-1)*10, ce,...
            'Color', 'black',...
            'FontSize', 10,...
            'FontWeight', 'bold',...
            'FontUnits', 'normalized',...
            'ButtonDownFcn',{@mickey_enr,hfig},...
            'HorizontalAlignment', 'center');
    else
        ce=sprintf('%4.2f',HotBirdProp.cs.rod(i,2));
        text(k, i-(k-1)*10, ce,...
            'Color', 'black',...
            'FontSize', 10,...
            'FontWeight', 'bold',...
            'FontUnits', 'normalized',...
            'VerticalAlignment', 'bottom',...
            'ButtonDownFcn',{@mickey_enr,hfig},...
            'HorizontalAlignment', 'center');
        ce=sprintf('%4.2f',HotBirdProp.cs.rod(i,3));
        text(k, i-(k-1)*10, ce,...
            'Color', 'black',...
            'FontSize', 10,...
            'FontWeight', 'bold',...
            'FontUnits', 'normalized',...
            'VerticalAlignment', 'top',...
            'ButtonDownFcn',{@mickey_enr,hfig},...
            'HorizontalAlignment', 'center');
    end
end


if (HotBirdProp.axial_btf == 1)
    HotBirdProp.cs.calc_u235();
    cc=sprintf('<U235>=%5.3f', HotBirdProp.cs.u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);   
else
    HotBirdProp.cs.s(cn).calc_u235;
    cc=sprintf('U235= %5.3f', HotBirdProp.cs.s(cn).u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);
end
set(hfig,'userdata',HotBirdProp);

end

