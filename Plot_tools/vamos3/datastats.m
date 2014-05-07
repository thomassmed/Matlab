function datastats(mainhandle)

handles = guidata(mainhandle);

fig = figure();
handles.WINDOWS = [handles.WINDOWS fig];

set(fig,'Toolbar','none');
set(fig,'MenuBar','none');
set(fig,'Position',[ 100 100 550 500]);
set(fig,'ResizeFcn','resize_list()');

texth = uicontrol(fig,'Style','listbox');
set(texth,'Position',[1 1 600 500]);
set(texth,'HorizontalAlignment','left');
set(texth,'FontName','Monospaced');
set(texth,'ForegroundColor','black');
set(texth,'BackgroundColor','white');

selfile = get(handles.filelist,'Value');
FILE = handles.FILES(selfile);

nsignals = FILE.nvar;

str = sprintf('%-20s%-12s%-12s%-12s%-12s%-12s','  Label:','  Min:','  Min t:','  Max:','  Max t:','  Mean:');

for i=1:nsignals
	data = FILE.signal(i).data;
	label = strtrim(FILE.signal(i).label);
	
	t = gettimevec(FILE,i);
	
	[minv,mint] = min(data);
	mint = t(mint);
	[maxv,maxt] = max(data);
	maxt = t(maxt);
	meanv = mean(data);
	
	sigstr = sprintf('%-20s%12.6g%12.6g%12.6g%12.6g%12.6g',label,minv,mint,maxv,maxt,meanv);
	
	str = [str; sigstr];
end

set(texth,'String',str);

guidata(mainhandle,handles);
