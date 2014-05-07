%@(#)   nodplan.m 1.2	 94/01/25     12:42:58
%
function nodplan
hcf=gcf;
hand=get(gcf,'userdata');
ud=get(hand(2),'userdata');
nod=ud(15,:);
i=find(nod==' ');nod(i)='';
hwin=figure('position',[900,700,200,170]);
eval(ud(3,:))
set(hand(44),'userdata',hwin);
hp1=uicontrol('style','pushbutton','position',[10 130 60 30],'string','apply', 'callback',...
'hh=get(gcf,''userdata'');ud=get(hh(2),''userdata'');nod=get(hh(3),''string'');ud(15,1:7)=''       '';ud(15,1:length(nod))=nod;set(hh(2),''userdata'',ud);delete(gcf);figure(hh(1));goplot');
hp2=uicontrol('style','pushbutton','position',[130 130 60 30]...
,'string','cancel','callback','delete(gcf);figure(hh(1));');
htext=uicontrol('style','edit','position',[10 80 90 30],'string',nod);
set(hwin,'name','nodplan','numbertitle','off')
set(hwin,'userdata',[hcf hand(2) htext]);
