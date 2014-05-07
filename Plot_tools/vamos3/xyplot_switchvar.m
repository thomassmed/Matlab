function xyplot_switchvar(ax)

ud = get(ax,'UserData');
handles = guidata(ud.mainhandle);
xu = ud.y;
yu = ud.x;

x = handles.FILES(xu.file).signal(xu.signal).data;
y = handles.FILES(yu.file).signal(yu.signal).data;
plot(ax,x,y);
xlabel([strtrim(handles.FILES(xu.file).signal(xu.signal).label) '  ' ...
		strtrim(char(handles.FILES(xu.file).signal(xu.signal).desc))]);
ylabel([strtrim(handles.FILES(yu.file).signal(yu.signal).label) '  ' ...
		strtrim(char(handles.FILES(yu.file).signal(yu.signal).desc))]);

ud.x = xu;
ud.y = yu;

set(ax,'UserData',ud);
