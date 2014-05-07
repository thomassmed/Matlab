function mdzoom
%mdzoom
%Zoomar en figur
set(gcf,'Pointer','crosshair');
[x,y]=getbox;
set(gcf,'Pointer','arrow')
axis([min(x) max(x) min(y) max(y)])
