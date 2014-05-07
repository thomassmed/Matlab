function alignmove(ax,type)


pos = get(ax,'CurrentPoint');
lineh = gco;
uds = get(lineh,'UserData');
xdata = get(lineh,'XData');
ydata = get(lineh,'YData');


ud = get(ax,'UserData');
handles = guidata(ud.mainhandle);

switch type
case 'x'
	if ~isfield(uds,'xalign') 
		uds.xalign = 0;
		oldxalign = 0;
	else
		oldxalign = uds.xalign;
	end
	uds.xalign = uds.xalign + (pos(1,1)-xdata(1));
	
	xdata = xdata + (pos(1,1)-xdata(1));
	set(lineh,'XData',xdata);

case 'y'
	if ~isfield(uds,'yalign')
		uds.yalign = 0;
		oldyalign = 0;
	else
		oldyalign = uds.yalign;
	end
	uds.yalign = (pos(1,2)-ydata(1)) - oldyalign;
	
	ydata = ydata + (pos(1,2)-ydata(1));
	set(lineh,'YData',ydata);
	
case 'xy'
	if ~isfield(uds,'xalign')
		uds.xalign = 0; 
		oldxalign = 0;
	else
		oldxalign = uds.xalign;
	end
	if ~isfield(uds,'yalign')
		uds.yalign = 0;
		oldyalign = 0;
	else
		oldyalign = uds.yalign;
	end
	
	uds.xalign = uds.xalign + (pos(1,1)-xdata(1));
	uds.yalign = (pos(1,2)-ydata(1)) - oldyalign;
	
	xdata = xdata + (pos(1,1)-xdata(1));
	set(lineh,'XData',xdata);
	ydata = ydata + (pos(1,2)-ydata(1));
	set(lineh,'YData',ydata);
end



set(lineh,'UserData',uds);
set(ax,'XLimMode','manual');
set(ax,'YLimMode','manual');


