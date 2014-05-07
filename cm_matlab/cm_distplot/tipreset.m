%@(#)   tipreset.m 1.2	 94/01/25     12:43:41
%
hvec=get(gcf,'userdata');
val=get(hvec(length(hvec)),'userdata');
nfiles=size(val,1);
hfig=hvec(length(hvec)-nfiles);
hand=get(hfig,'userdata');
set(hand(50),'userdata',0)
