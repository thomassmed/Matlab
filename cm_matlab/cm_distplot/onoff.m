%@(#)   onoff.m 1.2	 94/01/25     12:43:02
%
function onoff
hand=get(gcf,'userdata');
ud=get(hand(2),'userdata');
if strcmp(ud(16,1:3),'on ')
  ud(16,1:3)='off';
else
  ud(16,1:3)='on ';
end
set(hand(2),'userdata',ud)
ccplot
