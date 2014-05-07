function acf_plot(ax,type)

ud = get(ax,'UserData');

handles = guidata(ud.mainhandle);

ydatah = ud.ydatah;

for i=1:length(ydatah)
	uds = get(ydatah(i),'UserData');
	liststr(i) = {handles.FILES(uds.file).signal(uds.signal).label};		
end

[selexpr,ok] = listdlg('ListString',liststr,'SelectionMode','single','Name','Select signal:');

if ok == 1
	uds = get(ydatah(selexpr(1)),'UserData');
	y = get(ydatah(selexpr),'YData');
	fs = getfs(handles.FILES(uds.file),uds.signal);
	
	if strcmp(type,'marked') && isfield(ud,'ruler')
		xdata = get(ydatah(selexpr),'XData');
	
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
				
		y = y(ystart:ystop);
	end
	
	px = xcorr(y);
	
	fig = figure;
	
	handles.WINDOWS = [handles.WINDOWS fig];
	
	fx = (0:(length(px)-1))./fs;
	
	plot(fx,abs(px));
	
	guidata(ud.mainhandle,handles);
end
