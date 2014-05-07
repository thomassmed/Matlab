%@(#)   getinfil.m 1.1	 05/07/13     10:29:32
%
%
function getfil(callb,ledtext)
curf=gcf;
pos=get(gcf,'position');
ud=setprop;
hfil=figure('position',[pos(1:2)+pos(3:4)-[400 200],250,150]);
hdum=uicontrol('style','edit','string',ledtext,'position',...
[0.25 0.5 0.45 0.25],'units','normalized');
hpfil=uicontrol('style','edit','position',...
[0.51 0.5 0.4 0.25],'units','normalized');
if nargin==0, lr=2;end
hand=[curf,hpfil];
set(hfil,'userdata',hand);
happly=uicontrol('style','Pushbutton','position',[0.4 0.2 0.30 0.15],...
'callback',callb,...
'string','Apply','units','normalized');
