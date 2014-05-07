function resetsignal(src,eventdata,ax)

sigh = gco;

ud = get(ax,'UserData');
uds = get(sigh,'UserData');

handles = guidata(ud.mainhandle);

xdata = gettimevec(handles.FILES(uds.file),uds.signal);
ydata = handles.FILES(uds.file).signal(uds.signal).data;

udsnew.file = uds.file;
udsnew.signal = uds.signal;

set(sigh,'XData',xdata);
set(sigh,'YData',ydata);

set(sigh,'UserData',udsnew);
