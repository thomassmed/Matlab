%@(#)   scalesetmin.m 1.2	 94/01/25     12:43:22
%
function scalesetmin
hcf=gcf;
hand=get(gcf,'userdata');
ha=hand(2);
h=get(ha,'userdata');
cmin=str2num(h(7,:));
cmax=str2num(h(8,:));
hwin=figure('position',[900,700,200,170]);
axes('visible','off')
eval(h(3,:))
set(hand(14),'userdata',hwin);
hp1=uicontrol('style','pushbutton','position',[10 130 60 30],'string','apply','callback','applyscale');
%hp1=uicontrol('style','pushbutton','position',[10 130 60 30],'string','apply','callback','h3=get(gcf,''userdata'');figure(h3(4));cplot');
hp2=uicontrol('style','pushbutton','position',[130 130 60 30]...
,'string','cancel','callback','h3=get(gcf,''userdata'');hand=get(h3(4),''userdata'');set(hand(14),''userdata'',0);delete(gcf)');
htext=uicontrol('style','edit','position',[10 80 90 30],'string',num2str(cmin),'callback','hs=get(gcf,''userdata'');htext=hs(1);hsc=hs(2);set(hsc,''value'',str2num(get(htext,''string'')))');
hsc=uicontrol('style','slider','min',cmin-(cmax-cmin),'max',cmax-0.1*(cmax-cmin),'value',cmin,'position',[10 10 180 30],'callback','hs=get(gcf,''userdata'');htext=hs(1);hsc=hs(2);set(htext,''string'',num2str(get(hsc,''value'')))');
%hax=axes('position',[.05 .35 .88 .001],'xlim',[cmin-(cmax-cmin) %cmax-0.1*(cmax-cmin)],'xgrid','on');
text(0,.2,sprintf('%5.2f',cmin-(cmax-cmin)));
text(0.7,.2,sprintf('%5.2f',cmax-0.1*(cmax-cmin)));
set(hwin,'name','scale min','numbertitle','off')
h(9,1:4)='yes ';
hs=[htext hsc 0.0 hcf]';
set(hwin,'userdata',hs)
set(ha,'userdata',h)
