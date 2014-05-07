function paint_patron(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
axes(HotBirdProp.handles.patron);
reset(gca);
cmax = HotBirdProp.cs.s(cn).nr_fue;
cmin = min(min(HotBirdProp.cs.s(cn).lfu));
ncol = HotBirdProp.cs.s(cn).nr_fue;
plmat=ncol*HotBirdProp.cs.s(cn).lfu/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
vitmat=ones(HotBirdProp.cs.s(cn).npst)*1;
image(vitmat,'ButtonDownFcn',{@mickey_patron,hfig});
set(gca,'XTick',[],'YTick',[]);
HotBirdProp.button=1;



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
        x = 0.39*cos(t) + i;
        y = 0.39*sin(t) + j;
        if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
            fill(x, y,HotBirdProp.clmap(plmat(i,j),:), 'ButtonDownFcn',{@mickey_patron,hfig})
        end
    end
end



for i=1:HotBirdProp.cs.s(cn).npst
    for j=1:HotBirdProp.cs.s(cn).npst
        if (HotBirdProp.cs.s(cn).enr(i,j) > 0)
            if(HotBirdProp.cs.s(cn).ba(i,j) > 0);
%                 ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
%                 text(j, i, ce,...
%                     'Color', 'black',...
%                     'FontSize', 9,...
%                     'FontUnits', 'normalized',...
%                     'FontWeight', 'bold',...
%                     'VerticalAlignment', 'topp',...
%                     'HorizontalAlignment', 'center',...
%                     'ButtonDownFcn',{@mickey_patron,hfig});
                ce=sprintf('BA');
                text(j, i, ce,...   
                    'Color', 'black',...
                    'FontSize', 13,...
                    'FontUnits', 'normalized',...
                    'FontWeight', 'bold',...
                    'VerticalAlignment', 'middle',...
                    'HorizontalAlignment', 'center',...
                    'ButtonDownFcn',{@mickey_patron,hfig});
            else
                ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).enr(i,j));
                text(j, i, ce,...   
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontUnits', 'normalized',...
                    'FontWeight', 'bold',...
                    'HorizontalAlignment', 'center',...
                    'ButtonDownFcn',{@mickey_patron,hfig});
            end
        end
    end
end


% rectangle('Position',[0.55,0.55,HotBirdProp.cs.s(cn).npst-0.09,HotBirdProp.cs.s(cn).npst-0.09], 'LineWidth',4);



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
paint_enr([],[],hfig);
end

