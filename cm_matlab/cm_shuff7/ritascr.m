%@(#)   ritascr.m 1.1	 05/07/13     10:29:39
%
%
function [Hpil,Hring]=ritascr(Hpil,Hring,gonu,mode,plmat);
hand=get(gcf,'userdata');
set(hand(3),'cdata',plmat);
set(gcf,'userdata',hand);
[Hpil,Hring]=updatpil(Hpil,Hring,gonu,mode);

