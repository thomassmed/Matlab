function nofilesloaded(hObject,handles)

set(handles.Plot_menu,'Enable','off');
set(handles.Filelist,'Enable','off');
set(handles.Closefile,'Enable','off');
set(handles.filelist,'Enable','off');
set(handles.signallist,'Enable','off');
set(handles.Statistics,'Enable','off');
set(handles.Save_project,'Enable','off');
set(handles.Saved_expressions,'Enable','off');

guidata(hObject,handles);
