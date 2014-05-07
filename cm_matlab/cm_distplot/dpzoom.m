%@(#)   dpzoom.m 1.1	 94/11/22     08:28:33
%
function zoom
disp('hej')
set(gcf,'Pointer','crosshair');
[x,y]=getbox;
set(gcf,'Pointer','arrow')
xl=fix(min(x));xu=fix(max(x))+1;yl=fix(min(y));yu=fix(max(y))+1;
axis([xl xu yl yu]);
delete(hinstr);
axiss=['[',num2str(xl),' ',num2str(xu),' ',num2str(yl),' ',num2str(yu),']'];
setprop(10,axiss);
