%@(#)   ponoff.m 1.3	 97/11/04     10:49:44
%
function ponoff(pos)
par=gcf;
hand=get(gcf,'userdata');
ud=get(hand(2),'userdata');
hpowin=get(hand(61),'userdata');
h=get(0,'children');
if ~isempty(hpowin),i=find(h==hpowin);end
if strcmp(ud(17,1:3),'off')
  if nargin==0, pos=[400 160 350 220];end
  hpowin=figure('position',pos);
  axes('visible','off')
  eval(ud(3,:))
  ud(17,1:3)='on ';
  set(hand(61),'userdata',hpowin);
  figure(par);
  polcainfo;
else
  ud(17,1:3)='off';
  if ~isempty(i)
    delete(hpowin)
  end
end
set(hand(2),'userdata',ud);
