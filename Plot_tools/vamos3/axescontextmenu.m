function [menu]=axescontextmenu(handles)

menu = uicontextmenu();

uimenu(menu(1),'Label','Add selected signals to plot','Callback','addtoplot(gca)');
uimenu(menu(1),'Label','Add logic signal','Callback',{@digitalsignal,gca});
uimenu(menu(1),'Label','Axes properties','Callback','scribeaxesdlg(gca)','Separator','on');
