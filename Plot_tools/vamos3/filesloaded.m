function filesloaded(hObject,handles)

set(handles.Plot_menu,'Enable','on');
set(handles.Closefile,'Enable','on');
set(handles.Filelist,'Enable','on');
set(handles.filelist,'Enable','on');
set(handles.signallist,'Enable','on');
set(handles.Statistics,'Enable','on');
set(handles.Save_project,'Enable','on');
set(handles.Saved_expressions,'Enable','on');

guidata(hObject,handles);
