function h=gcas
% h=gcas
ch=get(gcf,'Children');
for n=1:length(ch),
  if strcmp(get(ch(n),'Type'),'axes'),
    h=[h;ch(n)];
  end
end
