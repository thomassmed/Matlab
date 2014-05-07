%@(#)   preplot.m 1.5	 98/05/27     09:53:34
%
function preplot
hpar=gcf;
hand=get(gcf,'userdata');
load('simfile');
hprewin=figure('position',[5 100 400 400],'color',[1 1 1]*.8);
axes('visible','off')
hpu=uicontrol('style','pushbutton','string','sdm step','position',[0.7 0.2 0.2 0.05],'units','normalized','callback','sdmstep');
hpu=uicontrol('style','pushbutton','string','cycle sdm','position',[0.7 0.3 0.2 0.05],'units','normalized','callback','sdmcyc');
hpu=uicontrol('style','pushbutton','string','power step','position',[0.7 0.4 0.2 0.05],'units','normalized','callback','powstep');
hpu=uicontrol('style','pushbutton','string','burnup step','position',[0.7 0.5 0.2 0.05],'units','normalized','callback','burstep');
hpu=uicontrol('style','pushbutton','string','cycle step','position',[0.7 0.6 0.2 0.05],'units','normalized','callback','cycstep');
hpu=uicontrol('style','pushbutton','string','bwd','position',[0.7 0.7 0.2 0.05],'units','normalized','callback','prestep(''bwd'')');
hpu=uicontrol('style','pushbutton','string','fwd','position',[0.7 0.8 0.2 0.05],'units','normalized','callback','prestep(''fwd'')');
hpu=uicontrol('style','pushbutton','string','copy prev','position',[0.3 0.2 0.2 0.05],'units','normalized','callback','copcon');
hpu=uicontrol('style','pushbutton','string','auto k','position',[0.3 0.3 0.2 0.05],'units','normalized','callback','autsek');
text('string','conrod','position',[-0.1 0.01],'units','normalized','color',[0 0 0]);
hval(1)=uicontrol('style','edit','string',conrod(1,:),'position',[0.3 0.1 0.6 0.05],'units','normalized','callback','preed(1,''conrod'')');
text('string','tlowp','position',[-0.1 0.50],'units','normalized','color',[0 0 0]);
hval(3)=uicontrol('style','edit','string',tlowp(1,:),'position',[0.3 0.5 0.2 0.05],'units','normalized','callback','preed(3,''tlowp'')');
text('string','hc-flow','position',[-0.1 0.62],'units','normalized','color',[0 0 0]);
hval(4)=uicontrol('style','edit','string',hc(1,:),'position',[0.3 0.6 0.2 0.05],'units','normalized','callback','preed(4,''hc'')');
text('string','power','position',[-0.1 0.74],'units','normalized','color',[0 0 0]);
hval(5)=uicontrol('style','edit','string',pow(1,:),'position',[0.3 0.7 0.2 0.05],'units','normalized','callback','preed(5,''pow'')');
text('string','point','position',[-0.1 0.86],'units','normalized','color',[0 0 0]);
hval(6)=uicontrol('style','edit','string',num2str(blist(1)),'position',[0.3 0.8 0.2 0.05],'units','normalized','callback','preed(6,''pos'')');
set(gcf,'userdata',hval);
