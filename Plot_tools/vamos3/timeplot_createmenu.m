function [menu]=timeplot_createmenu(fig);


menu(1) = uimenu(fig,'Label','Signalanalys');

uimenu(menu(1),'Label','Spectrum (full)','Callback','spectrumplot(gca,''full'')');
uimenu(menu(1),'Label','Spectrum (marked)','Callback','spectrumplot(gca,''marked'')');

uimenu(menu(1),'Label','Cross spectrum (full)','Callback','cross_spectrumplot(gca,''full'')','Separator','on');
uimenu(menu(1),'Label','Cross spectrum (marked)','Callback','cross_spectrumplot(gca,''marked'')');

% Fixa autocorrelations-funktionerna först
%uimenu(menu(1),'Label','Autocorrelation (full)','Callback','acf_plot(gca,''full'')','Separator','on');
%uimenu(menu(1),'Label','Autocorrelation (marked)','Callback','acf_plot(gca,''marked'')');


menu(2) = uimenu(fig,'Label','Info');
uimenu(menu(2),'Label','Add file info','Callback','timeplot_addfileinfo()');
