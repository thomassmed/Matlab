function paint_crd(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
axes(HotBirdProp.handles.crd1);
reset(gca);
set(gca,'XTick',[],'YTick',[]);
HotBirdProp.button=1;
hold on
rectangle('Position',[0,0,1,1], 'LineWidth',20);


axes(HotBirdProp.handles.crd2);
reset(gca);
set(gca,'XTick',[],'YTick',[]);
HotBirdProp.button=1;
hold on
rectangle('Position',[0,0,1,1], 'LineWidth',20);



end

