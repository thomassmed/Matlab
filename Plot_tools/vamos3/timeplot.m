function timeplot(hObject,handles,type)

selfile = get(handles.filelist,'Value');
selsignal = get(handles.signallist,'Value');

switch type
	case 'single'
		fig = figure();
		handles.WINDOWS = [handles.WINDOWS fig];
		ax = axes();
		
		xdata = gettimevec(handles.FILES(selfile),selsignal);
		for i=1:size(selsignal,2)
			ydata(i,:) = handles.FILES(selfile).signal(selsignal(i)).data;
			legstring(i,:) = [num2str(selfile*ones(size(selsignal,1),1),'File:%02d ') handles.FILES(selfile).signal(selsignal(i)).label ...
				   			  handles.FILES(selfile).signal(selsignal(i)).unit];
		end
		ud.ydatah = plot(ax,xdata,ydata);
		
		h_leg=legend(ax,legstring);
        set(h_leg,'Interpreter','none');
		xlabel(ax,'Time [s]');
		grid(ax,'on');
		
		sighandles = flipud(get(ax,'Children'));
		for i=1:size(selsignal,2)
			uds.file = selfile;
			uds.signal = selsignal(i);
			set(sighandles(i),'UIContextMenu',signalcontextmenu(handles));
			set(sighandles(i),'UserData',uds);
		end
		
		ud.mainhandle = handles.VAMOS2;
		set(ax,'UIContextMenu',axescontextmenu(handles));
		set(ax,'UserData',ud);
		
		ruler_createbuttons(fig);
		timeplot_createmenu(fig);
		
		guidata(hObject,handles);
		
	case 'multi'
		for i=1:size(selsignal,2)
			fig = figure();
			handles.WINDOWS = [handles.WINDOWS fig];
			ax = axes();
			
			xdata = gettimevec(handles.FILES(selfile),selsignal(i));
			ydata = handles.FILES(selfile).signal(selsignal(i)).data;
			ud.ydatah = plot(ax,xdata,ydata);
			
			h_leg=legend(ax,[num2str(selfile*ones(size(selsignal,1),1),'File:%02d ') handles.FILES(selfile).signal(selsignal(i)).label ...
				   handles.FILES(selfile).signal(selsignal(i)).unit]);
            set(h_leg,'Interpreter','none');
            xlabel(ax,'Time [s]');
			grid(ax,'on');
			 
			uds.file = selfile;
			uds.signal = selsignal(i);
			set(ud.ydatah,'UIContextMenu',signalcontextmenu(handles));
			set(ud.ydatah,'UserData',uds);
			
			ruler_createbuttons(fig);
			timeplot_createmenu(fig);
			
			ud.mainhandle = handles.VAMOS2;
			set(ax,'UIContextMenu',axescontextmenu(handles));
			set(ax,'UserData',ud);
		end
		guidata(hObject,handles);
		
	case 'subplots'
		fig = figure();
		handles.WINDOWS = [handles.WINDOWS fig];
		
		n = ceil(sqrt(size(selsignal,2)));
		m = round(sqrt(size(selsignal,2)));
		subplot(n,m,1);
		for i=1:size(selsignal,2)
			ax = subplot(n,m,i);
			
			xdata = gettimevec(handles.FILES(selfile),selsignal(i));
			ydata = handles.FILES(selfile).signal(selsignal(i)).data;
			ud.ydatah = plot(ax,xdata,ydata);
			
			h_leg=legend(ax,[num2str(selfile*ones(size(selsignal,1),1),'File:%02d ') handles.FILES(selfile).signal(selsignal(i)).label ...
				   handles.FILES(selfile).signal(selsignal(i)).unit]);
			set(h_leg,'Interpreter','none');
            xlabel(ax,'Time [s]');
			grid(ax,'on');
			
			uds.file = selfile;
			uds.signal = selsignal(i);
			set(ud.ydatah,'UIContextMenu',signalcontextmenu(handles));
			set(ud.ydatah,'UserData',uds);
			
			ud.mainhandle = handles.VAMOS2;
			set(ax,'UIContextMenu',axescontextmenu(handles));
			set(ax,'UserData',ud);
		end
		
		ruler_createbuttons(fig);
		timeplot_createmenu(fig);
		
		guidata(hObject,handles);
end
