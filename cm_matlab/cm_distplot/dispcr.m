%@(#)   dispcr.m 1.1	 96/02/14     10:27:40
%
%
% make all the control rod withdrawels unvisible 
% if they are out side the plot.
%

handles=get(gcf,'userdata');
hcrtext=get(handles(32),'userdata');

[ncr dump] = size(hcrtext);
hcrtext;
% set visible on for all control rods
for j=1:ncr
  set(hcrtext(j),'Visible','on');
end;

xlim=get(gca,'XLim');
ylim=get(gca,'YLim');

for i=1:ncr

  poscoord=get(hcrtext(i),'position');
  x=poscoord(1);
  y=poscoord(2);

  if ((x<=xlim(1)) | (x>=xlim(2)) | (y<=ylim(1)) | y>=ylim(2))
    set(hcrtext(i),'Visible','off');
  end;


end;
