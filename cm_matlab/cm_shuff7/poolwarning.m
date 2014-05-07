%@(#)   poolwarning.m 1.1	 05/07/13     10:29:38
%
function poolwarning
hwin=figure('position',[500,700,200,170]);
axes('visible','off');

hp1=uicontrol('style','pushbutton','position',[20 10 60 30],'string','Continue',...
'callback','set(gcf,''userdata'',''OK'');uiresume;');
hp2=uicontrol('style','pushbutton','position',[130 10 60 30],'string','Cancel',...
'callback','set(gcf,''userdata'',''CA'');uiresume;');


t=text(.2,.8,'WARNING!');
set(t,'FontSize',14);
set(t,'FontWeight','bold');
t1=text(.05,.6,'You have not defined');
t2=text(.25,.47,'a poolfile!');
set(t1,'FontSize',12);
set(t2,'FontSize',12);
