function dodetrend(src,eventdata,ax)

sigh = gco;

ud = get(sigh,'UserData');

ydataold = get(sigh,'YData');
ydatanew = detrend(ydataold);

set(sigh,'YData',ydatanew);
