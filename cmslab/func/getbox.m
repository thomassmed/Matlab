function [x,y]=getbox
% [x,y]=getbox
%
% gets the coordinates of two corners of a box
% defined by two mouse presses
global BOXLINE PT1 PT2 
set(gcf,'WindowButtonDownFcn','global BOXLINE PT1 PT2')
waitforbuttonpress;
PT1=get(gca,'CurrentPoint');
BOXLINE=line(0,0,'EraseMode','xor','Color',[1 1 1],'LineWidth',0.1,'UserData',1);
boxstr=['PT2=get(gca,''Currentpoint'');set(BOXLINE,''Xdata'',[PT1(1,1) PT2(1,1) PT2(1,1) PT1(1,1) PT1(1,1)],''YData'',[PT1(1,2) PT1(1,2) PT2(1,2) PT2(1,2) PT1(1,2)])'];
set(gcf,'WindowButtonMotionFcn',boxstr)
waitforbuttonpress;
set(gcf,'WindowButtonMotionFcn','')
set(gcf,'WindowButtonDownFcn','')
x=[PT1(1,1);PT2(1,1)];
y=[PT1(1,2);PT2(1,2)];
delete(BOXLINE)
clear global BOXLINE PT1 PT2
