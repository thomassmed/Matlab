function removesignal(src,eventdata,ax)

sigh = gco;

delete(sigh);

ud = get(ax,'UserData');

ud.ydatah = ud.ydatah(find(sigh ~= ud.ydatah));
set(ax,'UserData',ud);

updatelegend(ax);
