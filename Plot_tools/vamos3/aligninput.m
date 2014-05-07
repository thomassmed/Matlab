function aligninput(ax,type)

lineh = gco;
uds = get(lineh,'UserData');

xdata = get(lineh,'XData');
ydata = get(lineh,'YData');

switch type
case 'x'
	if ~isfield(uds,'xalign') 
		uds.xalign = 0;
		oldxalign = 0;
	else
		oldxalign = uds.xalign;
	end
	x = inputdlg('X offset','X offset',1,{num2str(uds.xalign)});
	x = str2num(x{1});
	uds.xalign = x;
	
	xdata = xdata + (uds.xalign - oldxalign);
	set(lineh,'XData',xdata);
	
case 'y'
	if ~isfield(uds,'yalign')
		uds.yalign = 0;
		oldyalign = 0;
	else
		oldyalign = uds.yalign;
	end
	ud = get(ax,'UserData');
	handles = guidata(ud.mainhandle);
	y = inputdlg('Y offset','Y offset',1,{num2str(uds.yalign)});
	y = str2num(y{1});
	uds.yalign = y;
	
	ydata = ydata + (uds.yalign - oldyalign);
	set(lineh,'YData',ydata);
	
case 'xy'
	if ~isfield(uds,'xalign') 
		uds.xalign = 0;
		oldxalign = 0;
	else
		oldxalign = uds.yalign;
	end
	if ~isfield(uds,'yalign')
		uds.yalign = 0;
		oldyalign = 0;
	else
		oldyalign = uds.yalign;
	end
	x = inputdlg('X offset','X offset',1,{num2str(uds.xalign)});
	x = str2num(x{1});
	y = inputdlg('Y offset','Y offset',1,{num2str(uds.yalign)});
	y = str2num(y{1});
	uds.xalign = x;
	uds.yalign = y;
	
	xdata = xdata + (uds.xalign - oldxalign);
	set(lineh,'XData',xdata);
	ydata = ydata + (uds.yalign - oldyalign);
	set(lineh,'YData',ydata);
end

set(lineh,'UserData',uds);

window = get(ax,'Parent');
set(window,'KeyPressFcn','');
set(window,'WindowButtonMotionFcn','');
set(window,'WindowButtonUpFcn','');
set(window,'Pointer','arrow');


set(ax,'XLimMode','auto');
set(ax,'YLimMode','auto');
