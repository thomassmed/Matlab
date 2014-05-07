%@(#)   axcancel.m 1.3	 97/11/04     10:24:49
%
function axcancel
curf=get(gcf,'userdata');
delete(gcf);
figure(curf);
setprop(20,'no');
