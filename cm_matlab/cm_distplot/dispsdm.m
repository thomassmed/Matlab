%@(#)   dispsdm.m 1.1	 96/02/14     10:28:43
%
%
%  Visa endast varden for SDM i de fall
%  texten hamnar innanfor axlarna
%

handles=get(gcf,'userdata');
hsdmtext=get(handles(43),'userdata');

hsdm = get(hsdmtext(1),'userdata');

[no dump] = size(hsdm);

% set visible on for all control rods
for j=1:no
  set(hsdm(j),'Visible','on');
end;

xlim=get(gca,'XLim');
ylim=get(gca,'YLim');

for i=1:no

  poscoord=get(hsdm(i),'position');
  x=poscoord(1);
  y=poscoord(2);

  if ((x<=xlim(1)) | (x>=xlim(2)) | (y<=ylim(1)) | y>=ylim(2))
    set(hsdm(i),'Visible','off');
  end;
end;
