function paint_channel(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
axes(HotBirdProp.handles.channel);
reset(gca);
set(gca,'XTick',[],'YTick',[]);
HotBirdProp.button=1;
hold on
rectangle('Position',[0,0,1,1], 'LineWidth',10);


% rectangle('Position',[0.4,0.4,0.1,0.1], 'LineWidth',5);

end

