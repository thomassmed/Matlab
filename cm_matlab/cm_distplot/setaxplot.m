%@(#)   setaxplot.m 1.2	 94/01/25     12:43:27
%
function h=setaxplot(pos);
curf=gcf;
clmap=setprop(3);
handles=get(gcf,'userdata');
if nargin==1,
    h=figure('position',pos);
else,
  p=get(gcf,'position');
  pnew=p;
  pnew=[5 p(2) 540 420];
  if (p(1)+p(3))<600, pnew(1)=580;end
  h=figure('position',pnew);
end
eval(clmap)
pp=[0 0 50 30];
uicontrol('style','Pushbutton','position',pp,...
'callback','printer','string','print');
pp=[60 0 50 30];
hcanc=uicontrol('style','Pushbutton','position',pp,...
'callback','axcancel','string','cancel');
set(h,'userdata',curf);
figure(curf);
set(handles(41),'userdata',h);
setprop(20,'yes');
