%@(#)   defscwin.m 1.1	 95/10/15     17:38:24
%
function defscwin
hpar=gcf;
dname=setprop(4);
hfig=figure('position',[400 500 200 200],'color',[.8 .8 .8]);
axes('visible','off');
text(0,1,[dname ' default scale'],'color','k');
hmax=uicontrol('style','edit','position',[70 120 60 25]);
uicontrol('style','text','position',[20 120 50 25],'string','max:');
hmin=uicontrol('style','edit','position',[70 80 60 25]);
uicontrol('style','text','position',[20 80 50 25],'string','min:');
happly=uicontrol('style','pushb','posit',[20 20 70 40],'string','apply','callb','appdefsc');
callstr=['delete(' num2str(hfig) ');'];
hcancel=uicontrol('style','pushb','posit',[110 20 70 40],'string','cancel','callback',callstr);
ud=[hpar hfig hmin hmax];
set(gcf,'userdata',ud);
