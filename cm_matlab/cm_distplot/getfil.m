%@(#)   getfil.m 1.5	 98/04/07     10:16:24
%
function getfil(callb,ledtext,ledpos);
curf=gcf;
pos=get(gcf,'position');
ud=setprop;
hfil=figure('position',[pos(1:2)+pos(3:4)-[400 200],250,150],'color',[.85 .85 1]);
if nargin<3, ledpos=[0.1 0.5 0.45 0.15];end
hdum=uicontrol('style','text','string',ledtext,'units','normalized','position',...
ledpos,'backgroundcolor',[.8 .8 1]);
hpfil=uicontrol('style','edit','units','normalized','position',...
[0.51 0.5 0.4 0.15],'backgroundcolor',[.8 .8 1]);
if nargin==0, lr=2;end
hand=[curf,hpfil];
set(hfil,'userdata',hand);
happly=uicontrol('style','Pushbutton','units','normalized','position',[0.15 0.2 0.30 0.15],...
'callback',callb,...
'string','OK','backgroundcolor',[.8 .8 1]);
hcancel=uicontrol('style','pushbutton','units','normalized','position',[.55 0.2 0.30 0.15],...
'callback','delete(gcf)','string','Cancel','backgroundcolor',[.8 .8 1]);
