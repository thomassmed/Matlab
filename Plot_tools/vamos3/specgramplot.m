function specgramplot(hObject,handles)

selfile = get(handles.filelist,'Value');
selsignal = get(handles.signallist,'Value');
fig = figure();
handles.WINDOWS = [handles.WINDOWS fig];
specgram(detrend(handles.FILES(selfile).signal(selsignal).data),[],getfs(handles.FILES(selfile),selsignal));
guidata(hObject,handles);
