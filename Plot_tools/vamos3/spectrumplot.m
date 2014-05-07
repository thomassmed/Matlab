function spectrumplot(hObject,type)




switch type
case 'mainmenucall'
	handles = guidata(hObject);
	
	selfile = get(handles.filelist,'Value');
	selsignal = get(handles.signallist,'Value');
	
	fig = figure();
	handles.WINDOWS = [handles.WINDOWS fig];
	n = ceil(sqrt(size(selsignal,2)));
	m = round(sqrt(size(selsignal,2)));
	subplot(n,m,1);
	for i=1:size(selsignal,2)
		ax = subplot(n,m,i);
		pwelch(handles.FILES(selfile).signal(selsignal(i)).data,[],[],[],getfs(handles.FILES(selfile),selsignal(i)));
		legend(ax,['Spektrum:' handles.FILES(selfile).signal(selsignal(i)).label]);
	end

	guidata(hObject,handles);
	

case 'full'
	ud = get(hObject,'UserData');
	handles = guidata(ud.mainhandle);
	
	signals = get(hObject,'Children');
	
	fig = figure();
	handles.WINDOWS = [handles.WINDOWS fig];
	
	n = ceil(sqrt(length(signals)));
	m = round(sqrt(length(signals)));
	subplot(n,m,1);
	
	for i=1:length(signals)
		if strcmp(class(handle(signals(i))),'graph2d.lineseries')
			uds = get(signals(i),'UserData');
			
			ax = subplot(n,m,i);
			
			xdata = get(signals(i),'XData');
			ydata = get(signals(i),'YData');
			
			pwelch(ydata,[],[],[],getfs(handles.FILES(uds.file),uds.signal));
			legend(ax,['Spektrum:' handles.FILES(uds.file).signal(uds.signal).label]);
		end
	end
	guidata(ud.mainhandle,handles);
	

case 'marked'
	ud = get(hObject,'UserData');
	handles = guidata(ud.mainhandle);
	
	if isfield(ud,'ruler')
		if strcmp(ud.ruler(1).type,'horizontal')
			signals = get(hObject,'Children');
			
			fig = figure();
			handles.WINDOWS = [handles.WINDOWS fig];
		
			n = ceil(sqrt(length(signals)));
			m = round(sqrt(length(signals)));
			subplot(n,m,1);
			
			for i=1:length(signals)
				if strcmp(class(handle(signals(i))),'graph2d.lineseries')
					uds = get(signals(i),'UserData');
					
					xdata = get(signals(i),'XData');
			
					xstart = ud.ruler(1).pos;
					xstop = ud.ruler(2).pos;
					if (xstart > xstop)
						xtmp = xstop;
						xstop = xstart;
						xstart = xtmp;			
					end
			
					xstart = find(xstart <= xdata);
					xstart = xstart(1);
					xstop = find(xstop <= xdata);
					xstop = xstop(1);
					
					if ~isempty(xstart) && ~isempty(xstop)
						ax = subplot(n,m,i);
						ydata = get(signals(i),'YData');
						

						pwelch(ydata(xstart:xstop),[],[],[],getfs(handles.FILES(uds.file),uds.signal));
						
						legend(ax,['Spektrum:' handles.FILES(uds.file).signal(uds.signal).label]);
					end
				end
			end
			guidata(ud.mainhandle,handles);
		else
			errordlg('Mark section to analyze with vertical markers');
		end
	else
		errordlg('Mark section to analyze with vertical markers');
	end
	
	
	
end
