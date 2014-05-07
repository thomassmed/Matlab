%@(#)   getprifil.m 1.2	 94/01/25     12:42:39
%
function getprifil(lr);
curf=gcf;
pos=get(gcf,'position');
ud=setprop;
clmap=ud(3,:);
i=find(clmap==' ');clmap(i)='';
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
'callback','hand=get(gcf,''userdata'');ASCprint(0,hand(3))',...
'string','Apply','units','normalized');
