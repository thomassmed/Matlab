%@(#)   appdefsc.m 1.1	 95/10/15     17:38:37
%
function appdefsc
ud=get(gcf,'userdata');
min=get(ud(3),'string');
max=get(ud(4),'string');
defscale(ud(1),min,max);
delete(ud(2));
