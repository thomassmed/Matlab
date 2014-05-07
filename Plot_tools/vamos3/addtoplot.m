function addtoplot(ax)

ud = get(ax,'UserData');
handles = guidata(ud.mainhandle);

selfile = get(handles.filelist,'Value');
selsignal = get(handles.signallist,'Value');

hold(ax,'on');

for i=1:size(selsignal,2)
	
	xdata = gettimevec(handles.FILES(selfile),selsignal(i));
	ydata = handles.FILES(selfile).signal(selsignal(i)).data;
	
	% Fixa ny färg att plotta med, roterande från colororder
	if (size(ud.ydatah,1)/7) >= 1
		colorn = size(ud.ydatah,1)+1 - floor((size(ud.ydatah,1)/7))*7;
	else 
		colorn = size(ud.ydatah,1)+1;
	end
	colororder = get(ax,'ColorOrder');
	
	
	newydata = plot(xdata,ydata,'Color',colororder(colorn,:));
	uds.file = selfile;
	uds.signal = selsignal(i);
	set(newydata,'UserData',uds);
	set(newydata,'UIContextMenu',signalcontextmenu(handles));
	ud.ydatah = [ud.ydatah; newydata];
end

set(ax,'UserData',ud);

updatelegend(ax);

