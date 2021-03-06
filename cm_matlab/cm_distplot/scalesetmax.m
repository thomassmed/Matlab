%@(#)   scalesetmax.m 1.2	 94/01/25     12:43:20
%
function scalesetmax
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
hp2=uicontrol('style','pushbutton','position',[130 130 60 30]...
,'string','cancel','callback','h3=get(gcf,''userdata'');hand=get(h3(4),''userdata'');set(hand(14),''userdata'',0);delete(gcf)');
htext=uicontrol('style','edit','position',[10 80 90 30],'string',num2str(cmax),'callback','hs=get(gcf,''userdata'');htext=hs(1);hsc=hs(2);set(hsc,''value'',str2num(get(htext,''string'')))');
hsc=uicontrol('style','slider','min',cmin+.01*(cmax-cmin),'max',cmax*2-cmin,'value',cmax,'position',[10 10 180 30],'callback','hs=get(gcf,''userdata'');htext=hs(1);hsc=hs(2);set(htext,''string'',num2str(get(hsc,''value'')))');
%hax=axes('position',[.05 .35 .88 0.001],'xlim',[cmin+.01*(cmax-cmin) %2*cmax-cmin],'xgrid','on');
text(0,.2,sprintf('%5.2f',cmin+.01*(cmax-cmin)));
text(0.7,.2,sprintf('%5.2f',2*cmax-cmin));
set(hwin,'name','scale max','numbertitle','off')
h(9,1:4)='yes ';
hs=[htext hsc 1 hcf]';
set(hwin,'userdata',hs)
set(ha,'userdata',h)
