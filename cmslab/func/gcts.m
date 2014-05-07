function h=gcts
% h=gcts
ch=get(gca,'Children');
for n=1:length(ch),
  if strcmp(get(ch(n),'Type'),'text'),
    h=[h;ch(n)];
  end
end
h=[h;get(gca,'Title');get(gca,'YLabel');get(gca,'XLabel')];
