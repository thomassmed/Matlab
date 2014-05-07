load siggui_icons.mat;
fig = figure();
plot(1:10,1:10);
toolbar = uitoolbar(fig);
rulerbar = uitoolbar();

toolbar=ruler('toolbarbuttons',rulerbar,toolbar,bmp);
ud.toolbar = toolbar;
ud.mainaxes = get(fig,'CurrentAxes');

ud.prefs.ruler.color = [ 1 1 1];
ud.prefs.ruler.markersize = 1;
ud.prefs.ruler.marker = 'o'

set(fig,'UserData',ud);

ruler('init');
