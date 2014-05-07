function doalign(src,eventdata,ax,type)

win = get(ax,'Parent');

set(win,'Pointer','crosshair');
set(win,'WindowButtonMotionFcn',['alignmove(gca,''' type ''')']);
set(win,'KeyPressFcn',['aligninput(gca,''' type ''')']);

str='set(gcf,''KeyPressFcn'',''''),set(gcf,''WindowButtonMotionFcn'','''')';
str=[str ',set(gcf,''WindowButtonUpFcn'',''''),set(gcf,''Pointer'',''arrow''),'];
%str=[str 'set(gca,''XLimMode'',''auto''),set(gca,''YLimMode'',''auto'')'];
set(win,'WindowButtonUpFcn',str);




%set(gca,'XLimMode','auto');
%set(gca,'YLimMode','auto');
