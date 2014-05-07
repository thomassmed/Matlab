function get_listname(filenames)
scrsz = get(0,'ScreenSize');
x0=round(0.05*scrsz(3));
dx=.25*scrsz(3);
y0=.4*scrsz(4);
dy=.5*scrsz(4);
hfig=figure('menubar','none','name','Select Variables to plot',...
    'NumberTitle','off','Integerhandle','off',...
    'position',[x0 y0 dx dy]);
cmsinfo=read_cms(filenames{1});

hvar=uicontrol (hfig, 'style', 'listbox', 'Max',100,'string', cmsinfo.ScalarNames,...
'units','Normalized','position',[0.0 0 .9 .9]);

hplot_button=uicontrol('style','pushbutton', 'units','Normalized',...
                       'position',[.02 .95 .27 .05],...
                       'string','Plot', ...
                       'callback',{@plot_selection,hvar,filenames});
