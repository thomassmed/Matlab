function xyplot(hObject,handles)

selfile = get(handles.filelist,'Value');
selsignal = get(handles.signallist,'Value');
if size(selsignal,2) == 2
	x = handles.FILES(selfile).signal(selsignal(1)).data;
	y = handles.FILES(selfile).signal(selsignal(2)).data;
	fig = figure();
	handles.WINDOWS = [handles.WINDOWS fig];
	plot(x,y);
	xlabel([strtrim(handles.FILES(selfile).signal(selsignal(1)).label) '  ' ...
			strtrim(char(handles.FILES(selfile).signal(selsignal(1)).desc))])
	ylabel([strtrim(handles.FILES(selfile).signal(selsignal(2)).label) '  ' ...
			strtrim(char(handles.FILES(selfile).signal(selsignal(2)).desc))])
	
	ud.x.file = selfile;
	ud.x.signal = selsignal(1);
	ud.y.file = selfile;
	ud.y.signal = selsignal(2);
	ud.mainhandle = handles.VAMOS2;
	set(gca,'UserData',ud);
	
	set(gca,'UIContextMenu',xyplotcontextmenu());
	
	guidata(hObject,handles);
else
	errordlg('Select 2 variables for xy-plot!');
end




function [menu]=xyplotcontextmenu()

menu = uicontextmenu();
uimenu(menu,'Label','Switch X-Y variables','Callback','xyplot_switchvar(gca)');
uimenu(menu,'Label','Set X-var to selected','Callback','xyplot_setvar(gca,''x'')');
uimenu(menu,'Label','Set Y-var to selected','Callback','xyplot_setvar(gca,''y'')');
uimenu(menu(1),'Label','Axes properties','Callback','scribeaxesdlg(gca)');
