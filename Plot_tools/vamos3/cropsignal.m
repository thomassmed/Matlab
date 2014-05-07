function cropsignal(src,eventdata,ax)

sigh = gco;
ud = get(ax,'UserData');

if isfield(ud,'ruler')
	uds = get(sigh,'UserData');
	ydata = get(sigh,'YData');
	xdata = get(sigh,'XData');
	pos(1) = ud.ruler(1).pos;
	pos(2) = ud.ruler(2).pos;
	
	switch ud.ruler(1).type
	case 'horizontal'
		findpos = find(pos(1) < xdata);
		npos(1) = findpos(1);
		findpos = find(pos(2) < xdata);
		npos(2) = findpos(1);
		npos = sort(npos);
		
		xdata = xdata(npos(1):npos(2));
		ydata = ydata(npos(1):npos(2));
		
		set(sigh,'XData',xdata);
		set(sigh,'YData',ydata);
		
		if isfield(uds,'xalign');
			uds.xalign = 0;
		end
		
		drawnow;
		
	case 'vertical'
		sort(pos);
		ind = find((ydata > pos(1)) & (ydata < pos(2)));
		xdata = xdata(ind);
		ydata = ydata(ind);
		
		set(sigh,'XData',xdata);
		set(sigh,'YData',ydata);
		
		if isfield(uds,'yalign');
			uds.yalign = 0;
		end
		
		drawnow;
	end
	set(sigh,'UserData',uds);
else
	errordlg('Select section to crop with markers');
end



set(ax,'UserData',ud);

