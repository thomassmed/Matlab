function timeplot_savedata(src,eventdata,ax)

sig = gco;

ud = get(ax,'UserData');
uds = get(sig,'UserData');

handles = guidata(ud.mainhandle);

label = inputdlg('Label of created data?','Labelname');

if ~isempty(label)

	xdata = get(sig,'XData');
	ydata = get(sig,'YData');
	
	if isfield(ud,'fs')
		fs = ud.fs;
	else
		fs = getfs(handles.FILES(uds.file),uds.signal);
	end
	
	sigdata.label = sprintf(' %-16s',char(label));;
	sigdata.t = xdata;
	sigdata.fs = fs;
	sigdata.data = ydata;
	sigdata.unit = handles.FILES(uds.file).signal(uds.signal).unit;
	sigdata.lowlimit = handles.FILES(uds.file).signal(uds.signal).lowlimit;
	sigdata.highlimit = handles.FILES(uds.file).signal(uds.signal).highlimit;
	sigdata.gain = handles.FILES(uds.file).signal(uds.signal).gain;
	sigdata.desc = handles.FILES(uds.file).signal(uds.signal).desc;
	
	if isfield(handles,'plotdatafile')
		handles.FILES(handles.plotdatafile).signal(end+1) = sigdata;
		handles.FILES(handles.plotdatafile).nvar = handles.FILES(handles.plotdatafile).nvar + 1;
		
		guidata(ud.mainhandle,handles);
	else
		filedata.type = 'plotdata';
		filedata.file = 'Plotdata';
		filedata.desc = 'Saved data from plots';
		filedata.nvar = 1;
		
		filedata.t = nan;
		filedata.nsamples = nan;
		filedata.fs = nan;
		
		filedata.signal(1) = sigdata;
		
		n = length(handles.FILES)+1;
		
		handles.FILES(n,1) = filedata;
		handles.plotdatafile = n;
		
		guidata(ud.mainhandle,handles);
		
		updatefilelist(ud.mainhandle);
	end
end
