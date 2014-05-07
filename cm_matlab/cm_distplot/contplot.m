%@(#)   contplot.m 1.2	 94/01/25     12:42:13
%
function contplot
hand=get(gcf,'userdata');
ud=get(hand(2),'userdata');
if strcmp(ud(2,1:7),'image  ')
  ud(2,1:7)='contour';
else
  ud(2,1:7)='image  ';
end
set(hand(2),'userdata',ud)
ccplot
