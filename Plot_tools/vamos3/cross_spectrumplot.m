function cross_spectrumplot(ax,type)

ud = get(ax,'UserData');

handles = guidata(ud.mainhandle);

ydatah = ud.ydatah;

for i=1:length(ydatah)
	uds = get(ydatah(i),'UserData');
	liststr(i) = {handles.FILES(uds.file).signal(uds.signal).label};		
end

[selexpr,ok] = listdlg('ListString',liststr,'SelectionMode','multi','Name','Select two signals:');

if length(selexpr) == 2 && ok == 1
	uds = get(ydatah(selexpr(1)),'UserData');
	x = get(ydatah(selexpr(1)),'YData');
	y = get(ydatah(selexpr(2)),'YData');
	fs = getfs(handles.FILES(uds.file),uds.signal);
	
	if strcmp(type,'marked') && isfield(ud,'ruler')
		for i=1:2
			xdata = get(ydatah(selexpr(i)),'XData');
		
			xstart = ud.ruler(1).pos;
			xstop = ud.ruler(2).pos;
			if (xstart > xstop)
				xtmp = xstop;
				xstop = xstart;
				xstart = xtmp;			
			end
			
			xstart = find(xstart <= xdata);
			ystart(i) = xstart(1);
			xstop = find(xstop <= xdata);
			ystop(i) = xstop(1);	
		end
		x = x(ystart(1):ystop(1));
		y = y(ystart(2):ystop(2));
	end
	
	pxy = cpsd(x,y,[],[],[],fs);
	
	fig = figure;
	
	handles.WINDOWS = [handles.WINDOWS fig];
	
	fx = 0:(fs/2)/(length(pxy)-1):fs/2;
	
	plot(fx,abs(pxy));
	
	xlabel('Frequency [Hz]');
	
	guidata(ud.mainhandle,handles);
end
