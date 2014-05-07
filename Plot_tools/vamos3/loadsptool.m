function loadsptool(hObject,handles)

selfile = get(handles.filelist,'Value');
selsignal = get(handles.signallist,'Value');

for i=1:size(selsignal,2)
	signal = sptool('create','Signal',handles.FILES(selfile).signal(selsignal(i)).data,getfs(handles.FILES(selfile),selsignal(i)),...
					['FILE' num2str(selfile) '_' strtrim(handles.FILES(selfile).signal(selsignal(i)).label)]);
	sptool('load',signal);
end
guidata(hObject,handles);
