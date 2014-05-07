%@(#)   getsgfil.m 1.1	 05/07/13     10:29:32
%
%
function getsgfil
hand=get(gcf,'userdata');
filename=get(hand(2),'string');
delete(gcf);
evstr=sprintf('%s%s','!cp infil-work.txt ',filename);
eval(evstr);
