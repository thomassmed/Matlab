%@(#)   hplcol.m 1.3	 97/08/25     08:05:56
%
hand=get(gcf,'userdata');
hpl=hand(2);
xlim=get(hpl,'xlim');
xmin=min(xlim);xmax=max(xlim);
if ~(round(xmin/2)==xmin/2), xmin=xmin+1;end
if ~(round(xmax/2)==xmax/2), xmax=xmax-1;end
xtick=(xmin:2:xmax)';
for i=1:size(xtick),
  xticklabel(i,:)=sprintf('%2i',xtick(i));
end
ylim=get(hpl,'ylim');
ymin=min(ylim);ymax=max(ylim);
if ~(round(ymin/2)==ymin/2), ymin=ymin+1;end
if ~(round(ymax/2)==ymax/2), ymax=ymax-1;end
ytick=(ymin:2:ymax)';
for i=1:size(ytick),
  yticklabel(i,:)=sprintf('%2i',ytick(i));
end
set(hpl,'xtick',xtick+0.5,'ytick',ytick+0.5,'xcolor','black','ycolor',...
'black','XTickLabel',xticklabel,'YTickLabel',yticklabel);
ht=get(hpl,'title');
set(ht,'color',[0 0 0]);
