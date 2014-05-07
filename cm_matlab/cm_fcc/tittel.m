%@(#)   tittel.m 1.2	 94/08/12     12:15:51
%
function ht=tittel(titext,fsize,xl)
if nargin<2, fsize=14;end
if nargin<3, xl=max(0.5-length(titext)/80,0);end
c=get(gcf,'children');
for i=1:length(c),
  if strcmp('titext',get(c(i),'userdata'))
     delete(c(i));break;
  end
end
ha=axes('pos',[0 .95 1.0 0.02]);
set(ha,'userdata','titext');
set(ha,'visible','off');
ht=text(xl,1.5,titext);
set(ht,'fontsize',fsize);
end
