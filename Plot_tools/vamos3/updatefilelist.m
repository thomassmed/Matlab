function updatefilelist(mainh)

handles = guidata(mainh);

FILES = handles.FILES;

n = length(FILES);

%oldlist = get(handles.filelist,'String');
%if isempty(oldlist)
%	newlist = {[' 01 ' fliplr(strtok(fliplr(FILES(n).file),'/'))]};
%else
%	newlist = vertcat(oldlist,{[' ' num2str(size(oldlist,1)+1,'%02d') ' ' fliplr(strtok(fliplr(FILES(n).file),'/'))]});
%end

for i=1:n
	newlist(i,1) = {[' ' num2str(i,'%02d') ' ' fliplr(strtok(fliplr(FILES(i).file),'/'))]};
end

set(handles.filelist,'String',newlist);
set(handles.filelist,'Value',n);

siglist = makesignallist(FILES(n));
set(handles.signallist,'String',siglist);
set(handles.signallist,'Value',1);
