%function Expressionsmenu_Callback(hObject, eventdata, handles)
if ~isfield(handles,'FILES')
	n = 1;
else
	FILES = handles.FILES;
	n = size(FILES,1)+1;
end

expr = createexpr(handles.VAMOS2);

if isfield(handles,'exprfile')
	for i=1:size(handles.FILES,1)
		if strcmp(handles.FILES(i).type,'expr')
			if handles.FILES(i).nsamples == size(expr.data,2)
				handles.FILES(i).nvar = handles.FILES(i).nvar+1;
				handles.FILES(i).data = [handles.FILES(i).data; expr.data];
				handles.FILES(i).labels = [handles.FILES(i).labels; ...
										   [expr.label char(32*ones(1,17-size(expr.label,2)))]];
				handles.FILES(i).units = [handles.FILES(i).units; ...
										  [expr.unit char(32*ones(1,7-size(expr.unit,2)))]];
				handles.FILES(i).lowlimit = [handles.FILES(i).lowlimit; 0];
				handles.FILES(i).highlimit = [handles.FILES(i).highlimit; 0];
				handles.FILES(i).gain = [handles.FILES(i).gain; 1];
				handles.FILES(i).vardesc = [handles.FILES(i).vardesc; ...
											[expr.vardesc char(32*ones(1,33-size(expr.vardesc,2)))]];
			
				guidata(hObject,handles);
			end
		end
	end
else
	if isstruct(expr)
		file.type = 'expr';
		file.file = 'EXPRESSIONS';
		file.desc = 'User created expressions';
		file.nvar = size(expr.data,1);
		file.data = expr.data;
		file.t = 1:size(expr.data,2);
		file.nsamples = size(expr.data,2);
		file.fs = 1/(expr.data(1,2) - expr.data(1,1));
		file.labels = [expr.label char(32*ones(1,17-size(expr.label,2)))];
		file.units = [expr.unit char(32*ones(1,7-size(expr.unit,2)))];
		file.lowlimit = 0; 
		file.highlimit = 0;
		file.gain = 1;
		file.vardesc = [expr.vardesc char(32*ones(1,33-size(expr.vardesc,2)))];
	
		FILES(n) = file;
	
		oldlist = get(handles.filelist,'String');
		if isempty(oldlist)
			newlist = {fliplr(strtok(fliplr(FILES(n).file),'/'))};
		else
			newlist = vertcat(oldlist,{fliplr(strtok(fliplr(FILES(n).file),'/'))});
		end
		set(handles.filelist,'String',newlist);
		set(handles.filelist,'Value',n);
		set(handles.signallist,'String',[FILES(n).labels FILES(n).vardesc]);
		set(handles.signallist,'Value',1);
		
	
		handles.FILES = FILES(:);
		handles.exprfile = n;
		guidata(hObject,handles);
	end
end
