function updatelegend(ax)

ud = get(ax,'UserData');
handles = guidata(ud.mainhandle);

sighandles = ud.ydatah;

legstring = [];
for i2 = 1:size(sighandles,1)
	uds = get(sighandles(i2),'UserData');
	file = uds.file;
	signal = uds.signal;
	
	legstring = [legstring; cellstr([num2str(file,'File:%02d ') handles.FILES(file).signal(signal).label ...
							handles.FILES(file).signal(signal).unit])];
end
h_leg=legend(ax,legstring);
set(h_leg,'Interpreter','none');

