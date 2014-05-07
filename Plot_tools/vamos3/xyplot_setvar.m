function xyplot_setvar(ax,dim)

ud = get(ax,'UserData');
handles = guidata(ud.mainhandle);

selfile = get(handles.filelist,'Value');
selsignal = get(handles.signallist,'Value');

if size(selsignal,2) == 1
	switch dim
	case 'x'
		x = handles.FILES(selfile).signal(selsignal(1)).data;
		y = handles.FILES(ud.y.file).signal(ud.y.signal).data;
		
	case 'y'
		x = handles.FILES(ud.x.file).signal(ud.x.signal).data;
		y = handles.FILES(selfile).signal(selsignal(1)).data;
	end
	if size(x,2) == size(y,2)
		ud.(dim).file = selfile;
		ud.(dim).signal = selsignal;
		plot(ax,x,y);
		xlabel([strtrim(handles.FILES(ud.x.file).signal(ud.x.signal).label) '  ' ...
				strtrim(char(handles.FILES(ud.x.file).signal(ud.x.signal).desc))]);
		ylabel([strtrim(handles.FILES(ud.y.file).signal(ud.y.signal).label) '  ' ...
				strtrim(char(handles.FILES(ud.y.file).signal(ud.y.signal).desc))]);
		set(ax,'UserData',ud);
	else
		errordlg('Signal must have data-vectors of equal length!');
	end
else
	errordlg('Select only one signal');
end
