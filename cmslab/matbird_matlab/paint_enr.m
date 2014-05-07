function paint_enr(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
axes(HotBirdProp.handles.enrlegend);
reset(gca);
cmax = HotBirdProp.cs.s(cn).nr_fue;
cmin = min(min(HotBirdProp.cs.s(cn).lfu));
ncol = HotBirdProp.cs.s(cn).nr_fue;

fue=nan(HotBirdProp.cs.s(cn).nr_fue,1);
for i=1:HotBirdProp.cs.s(cn).nr_fue;
    fue(i,1)=HotBirdProp.cs.s(cn).fue(i,1);
end
prmat=ncol*fue/(cmax-cmin)-ncol*cmin/(cmax-cmin)+1;
vitmat=ones(10,2);
image(vitmat,'ButtonDownFcn',{@mickey_enr,hfig});
set(gca,'XTick',[],'YTick',[]);

hold on;
t = 0 : 0.05 : 2*pi;
for i = 1 : 20
    if(i <= HotBirdProp.cs.s(cn).nr_fue)
        if (i<11)
            x = 0.4*cos(t)+1;
            y = 0.4*sin(t)+i;
        else
            x = 0.4*cos(t)+2;
            y = 0.4*sin(t)+i-10;
        end
        fill(x, y,HotBirdProp.clmap(prmat(i),:), 'ButtonDownFcn',{@mickey_enr,hfig})
    end
end

for i=1:HotBirdProp.cs.s(cn).nr_fue
    if (i<11)
        k=1;
    else
        k=2;
    end
    
    if(isnan(HotBirdProp.cs.s(cn).fue(i,4)))
        ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).fue(i,3));
        text(k, i-(k-1)*10, ce,...
            'Color', 'black',...
            'FontSize', 10,...
            'FontWeight', 'bold',...
            'FontUnits', 'normalized',...
            'ButtonDownFcn',{@mickey_enr,hfig},...
            'HorizontalAlignment', 'center');
    else
        ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).fue(i,3));
        text(k, i-(k-1)*10, ce,...
            'Color', 'black',...
            'FontSize', 10,...
            'FontWeight', 'bold',...
            'FontUnits', 'normalized',...
            'VerticalAlignment', 'bottom',...
            'ButtonDownFcn',{@mickey_enr,hfig},...
            'HorizontalAlignment', 'center');
        ce=sprintf('%4.2f',HotBirdProp.cs.s(cn).fue(i,5));
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

end
