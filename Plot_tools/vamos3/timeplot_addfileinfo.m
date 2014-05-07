function timeplot_addfileinfo()


fig = gcf;

% Find only children of figure that is an axis-object
ax = get(fig,'Children');
axfind = strmatch('axes',get(ax,'type'));
ax = ax(axfind);
axfind = strmatch('legend',get(ax,'Tag'));
ax(axfind) = 0;
ax = ax(ax ~= 0);

for i=1:size(ax,1)
	ud = get(ax(i),'UserData');
	
	handles = guidata(ud.mainhandle);
	
	ydatah = ud.ydatah;
	file = [];
	for n=1:size(ydatah)
		uds = get(ydatah(n),'UserData');
		if sum(uds.file == file) == 0
			file = [file; uds.file];
		end
	end
	file=sort(file);
	for n=1:size(file)
		if n == 1
			str = {[num2str(file(n),'File %02d:') ' ' handles.FILES(file(n)).file]};
		else
			str = [str; {[num2str(file(n),'File %02d:') ' ' handles.FILES(file(n)).file]}];
		end
	end
	title(ax(i),str);
end
