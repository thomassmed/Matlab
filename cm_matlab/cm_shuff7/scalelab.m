%@(#)   scalelab.m 1.1	 05/07/13     10:29:39
%
%
%function scalelab
function scalelab
hand=get(gcf,'userdata');
YT=[
'Tom      '
'N. tömd  '
'N. fylld '
'Klar     '
'Skyfflas '
'Skyf. nu '
'Urladd.  '
'Utbyte   '
'         '
'         '];
yt=get(hand(4),'Ytick');
if length(yt)>10
	ytt=(yt(1:length(yt)-1 )+yt(2:length(yt)))/2;
	set(hand(4),'Ytick',ytt);
end
set(hand(4),'YTicklabel',YT);
end
