function donormalize(src,eventdata,ax)

sigh = gco;

ud = get(sigh,'UserData');

ydataold = get(sigh,'YData');
ydatanew = normalize(ydataold');

set(sigh,'YData',ydatanew');
