function h=cmsplot_window(filetype,h,nodelete)
if nargin <3
    nodelete='delete';
end
if strcmpi(nodelete,'delete'),
    for i=1:length(h(10,:)),
        if ishandle(h(10,i)),
            if h(10,i)>0
                delete(h(10,i));
            end
        end
    end
end

switch filetype
    case {'.h5','.hdf5'}
        h(10,3)=axes('position',[0.95 0.05 0.05 0.85]);
        h(10,4)=plot([0.1 0.1],'visible','off');
        h(10,1)=axes('position',[0.28 0.05 0.62 0.85]);
        h(10,5)=annotation('textbox',[0.28 0.96 0.42 0.04],...
            'FitBoxToText','off',...
            'EdgeColor','none');
        h(10,6)=annotation('textbox',[0.70 0.96 0.20 0.04],...
            'FitBoxToText','off',...
            'HorizontalAlignment','right',...
            'EdgeColor','none');
        h(10,7)=annotation('textbox',[0.28 0.91 0.62 0.04],...
            'FitBoxToText','off',...
            'HorizontalAlignment','center',...
            'FontWeight','bold',...
            'EdgeColor','none');
    case {'.cms','.sum','.res','.out'}
        h(10,1)=axes('position',[0.14 0.05 0.72 0.85]);
        h(10,3)=axes('position',[0.92 0.05 0.07 0.85]);
        h(10,4)=plot([0.1 0.1],'visible','off');
        h(10,5)=annotation('textbox',[0.03 0.91 0.39 0.09],...
            'EdgeColor','none');
        h(10,6)=annotation('textbox',[0.43 0.91 0.39 0.09],...
            'HorizontalAlignment','right',...
            'EdgeColor','none');
    otherwise
        h(10,1)=axes('position',[0.03 0.05 0.79 0.85]);
        h(10,3)=axes('position',[0.90 0.05 0.09 0.85]);
        h(10,4)=plot([0.1 0.1],'visible','off');
        h(10,5)=annotation('textbox',[0.03 0.91 0.39 0.09],...
            'EdgeColor','none');
        h(10,6)=annotation('textbox',[0.43 0.91 0.39 0.09],...
            'HorizontalAlignment','right',...
            'EdgeColor','none');
end

