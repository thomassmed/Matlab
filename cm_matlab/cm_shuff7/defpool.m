%@(#)   defpool.m 1.1	 05/07/13     10:29:29
%
function defpool
hand=get(gcf,'userdata');
h=get(hand(1),'userdata');
fil=get(hand(2),'string');
set(h(93),'userdata',fil);
delete(gcf);
