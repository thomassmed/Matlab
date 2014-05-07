function setfs(src,eventdata,ax)
sigh = gco;
uds = get(sigh,'UserData');
ud = get(ax,'UserData');
handles = guidata(ud.mainhandle);

xdata = get(sigh,'XData');

if isfield(uds,'fs')
	oldfs = uds.fs;
	fs = inputdlg('New samplefrequency','Set fs',1,{num2str(uds.fs)});
%	handles.FILES(uds.file).signal(uds.signal).t = gettimevec(handles.FILES(uds.file),uds.signal)/(fs/getfs(handles.FILES(uds.file),uds.signal));
%	handles.FILES(uds.file).signal(uds.signal).fs = fs;
else
	oldfs = getfs(handles.FILES(uds.file),uds.signal);
	fs = inputdlg('New samplefrequency','Set fs',1,{num2str(getfs(handles.FILES(uds.file),uds.signal))});
%	handles.FILES(uds.file).signal(uds.signal).t = gettimevec(handles.FILES(uds.file),uds.signal)/(fs/getfs(handles.FILES(uds.file),uds.signal));
%	handles.FILES(uds.file).signal(uds.signal).fs = fs;
end
if ~isempty(fs)
	fs = abs(str2num(fs{1}));

	uds.fs = fs;
	
	xdata = xdata ./ (fs/oldfs);
	
	set(sigh,'XData',xdata);

	set(sigh,'UserData',uds);
end
