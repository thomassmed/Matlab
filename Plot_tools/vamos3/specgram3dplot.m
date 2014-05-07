function specgram3dplot(hObject,handles)

selfile = get(handles.filelist,'Value');
selsignal = get(handles.signallist,'Value');
fig = figure();
handles.WINDOWS = [handles.WINDOWS fig];
data = detrend(handles.FILES(selfile).signal(selsignal).data);
fs = getfs(handles.FILES(selfile),selsignal);
[B,F,T]=specgram(data,[],fs);
surf(T,F,abs(B));
%axis([0 T(end) 0 F(end) 0 max(max(B))]);
xlabel('Time [s]');
ylabel('Frequenzy [Hz]');
guidata(hObject,handles);
