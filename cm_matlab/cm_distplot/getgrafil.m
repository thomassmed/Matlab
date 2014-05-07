%@(#)   getgrafil.m 1.2	 94/01/25     12:42:37
%
function getprifil(lr);
curf=gcf;
pos=get(gcf,'position');
clmap=setprop(3);
clmap=['cmap=',clmap(10:length(clmap)-1),';'];
eval(clmap); 
hfil=figure('position',[pos(1:2)+pos(3:4)-[400 200],250,150],'colormap',cmap);
ledtext='Printfile:';
hdum=uicontrol('style','edit','string',ledtext,'position',...
[0.05 0.5 0.45 0.25],'units','normalized');
hpfil=uicontrol('style','edit','position',...
[0.51 0.5 0.4 0.25],'units','normalized');
if nargin==0, lr=2;end
hand=[curf,hpfil,lr];
set(hfil,'userdata',hand);
happly=uicontrol('style','Pushbutton','position',[0.4 0.2 0.30 0.15],...
'callback','hand=get(gcf,''userdata'');grafil',...
'string','Apply','units','normalized');
