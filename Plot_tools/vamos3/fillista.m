function fillista(mainhandle)

handles = guidata(mainhandle);

fig = figure();
handles.WINDOWS = [handles.WINDOWS fig];

set(fig,'Toolbar','none');
set(fig,'MenuBar','none');
set(fig,'Position',[ 20 20 920 100]);
set(fig,'ResizeFcn','resize_list()');

texth = uicontrol(fig,'Style','listbox');
set(texth,'Position',[1 1 920 100]);
set(texth,'HorizontalAlignment','left');
set(texth,'FontName','Monospaced');
set(texth,'ForegroundColor','black');
set(texth,'BackgroundColor','white');


nfiles = size(handles.FILES,1);

str = sprintf('%-04s%-120s%-10s%-7s%-7s%-10s','Nr:','File:','Type:','Nvar:','Fs:','Samples:');


for i=1:nfiles
	FILE = handles.FILES(i);
	filestr = sprintf('%-04d%-120s%-10s%-7d%-7.2f%-10d',i,FILE.file,FILE.type,FILE.nvar,FILE.fs,FILE.nsamples);
	str = [str; filestr];
end

set(texth,'String',str);

guidata(mainhandle,handles);
