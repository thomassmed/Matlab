%
%	OBSOLETE
% 
function updatetimeplot(ax)

ud = get(ax,'UserData');
handles = guidata(ud.mainhandle);
sighandles = ud.ydatah;

hold(ax,'on');

for i=1:size(sighandles,1)
	uds = get(sighandles(i),'UserData');
	file = uds.file;
	signal = uds.signal;
%	if isfield(uds,'fs')
%		xdata = handles.FILES(file).t * (handles.FILES(file).fs/uds.fs);
%	else
%		xdata = handles.FILES(file).t;
%	end
	xdata = gettimevec(handles.FILES(file),signal);
	if isfield(uds,'xalign')
		xdata = xdata + uds.xalign;
	end
	set(sighandles(i),'XData',xdata);
	
%	ydata = handles.FILES(file).signal(signal).data;
	ydata = get(sighandles(i),'YData');
	if isfield(uds,'yalign')
		ydata = ydata + uds.yalign;
	end
	if isfield(uds,'factor')
		ydata = ydata .* uds.factor;
	end
	if isfield(uds,'bias')
		ydata = ydata + uds.bias;
	end
	set(sighandles(i),'YData',ydata);
	
end
