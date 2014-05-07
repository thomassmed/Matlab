%@(#)   cyreset.m 1.2	 94/01/25     12:42:26
%
hvec=get(gcf,'userdata');
ll=length(hvec)-2;
hand=get(hvec(ll+1),'userdata');
set(hand(50),'userdata',0)
