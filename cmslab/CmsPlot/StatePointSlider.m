function StatePointSlider
hfig=gcf;
cmsplot_prop=get(hfig,'userdata')';
Xpo=cmsplot_prop.Xpo;
str=cell(length(Xpo),1);
for i=1:length(Xpo),
    str{i}=sprintf('%i :%6.2f',i,Xpo(i));
end

pos=get(hfig,'position');
pos(1)=pos(1)+pos(3);
pos(3)=200;

figsz=get(hfig,'pos'); 
winheight=figsz(4);
winwidth= max(0.09*figsz(3),70);

h=cmsplot_prop.handles;
h(10,8)=uicontrol (hfig,'style', 'listbox','string', str,'units','Normalized','position',[0 0 .1 .9]);
set(h(10,8),'callback','i=get(gcbo,''Value'');get_new_state_point(i);');
cmsplot_prop.handles=h;
set(hfig,'userdata',cmsplot_prop);