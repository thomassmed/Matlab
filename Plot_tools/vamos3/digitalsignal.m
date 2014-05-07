function digitalsignal(src,eventdata,ax)

ud = get(ax,'UserData');
handles = guidata(ud.mainhandle);

selfile = get(handles.filelist,'Value');
selsignal = get(handles.signallist,'Value');

if size(selsignal,2) == 1

	signal = handles.FILES(selfile).signal(selsignal).data;
	trig = find(signal ~= 0);
	if size(trig,2) >= 1
		t = gettimevec(handles.FILES(selfile),selsignal);
		trigtime = t(trig(1));
		
		ylim = get(ax,'YLim');
		
		lineh = line([trigtime trigtime],[ylim(1) ylim(2)]);
		set(lineh,'LineStyle','--');
		set(lineh,'Color',[1 0 0]);
		
		texth = text(trigtime,ylim(2)+ylim(2)*0.03,[strtrim(handles.FILES(selfile).signal(selsignal).label) ' = 1']);
		set(texth,'Color',[1 0 0]);
	end
end
