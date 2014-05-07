function plot_matfil(varargin)
fig=gcf;
prop=get(fig,'userdata');
selec=get(prop.hvar,'Value');

if ischar(get(varargin{1},'string')),
    if strcmp(get(varargin{1},'string'),'plot in new'),
        figure;
    end
end

plot(prop.data(:,1),prop.data(:,selec));
legend(prop.legend(selec));
