set(gcf,'InvertHardcopy','off','Color',[1 1 1]);
figob=get(gcf,'children');
for i=1:length(figob),
    if strcmpi(get(figob(i),'Tag'),'legend')
        set(figob(i),'fontsize',12);
    end
end