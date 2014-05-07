function paint_powp(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
axes(HotBirdProp.handles.patron);
cla;
HotBirdProp.cs.calc_powp();

for k=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(k).bigcalc();
end
HotBirdProp.cs.calc_powp();

ncol = 9;
if (HotBirdProp.axial_btf == 1)
    cmax = max(max(HotBirdProp.cs.powp));
    cmin = min(min(HotBirdProp.cs.powp));
    plmat=ncol*HotBirdProp.cs.powp/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
else
    cmax = max(max(HotBirdProp.cs.s(cn).powp));
    cmin = min(min(HotBirdProp.cs.s(cn).powp));
    plmat=ncol*HotBirdProp.cs.s(cn).powp/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
end

image(plmat,'ButtonDownFcn',{@mickey_patron,hfig});
set(gca,'XTick',[],'YTick',[]);
HotBirdProp.button=7;

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
            % rectangle('Position',[i-0.5, j-0.5, 1, 1], 'LineWidth',1);
        end
    end
end


if (HotBirdProp.axial_btf == 1)
    for i=1:HotBirdProp.cs.npst
        for j=1:HotBirdProp.cs.npst
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0 && HotBirdProp.cs.powp(i,j) > 0)
                ce=sprintf('%4.2f',HotBirdProp.cs.powp(i,j));
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
else
    for i=1:HotBirdProp.cs.npst
        for j=1:HotBirdProp.cs.npst
            if (HotBirdProp.cs.s(cn).enr(i,j) > 0 && HotBirdProp.cs.s(cn).powp(i,j) > 0)
                ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).powp(i,j));
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


if (HotBirdProp.axial_btf == 1)
    HotBirdProp.cs.calc_u235();
    cc=sprintf('<U235>=%5.3f', HotBirdProp.cs.u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);   
else
    HotBirdProp.cs.s(cn).calc_u235;
    cc=sprintf('U235= %5.3f', HotBirdProp.cs.s(cn).u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);
end
paint_enr([],[],hfig);
set(hfig,'userdata',HotBirdProp);

end

