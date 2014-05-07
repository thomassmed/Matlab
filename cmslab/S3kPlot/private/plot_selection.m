function plot_selection(~,~,hvar,filenames)
selec=get(hvar,'value');
varnames=get(hvar,'String');
AppendixPlot(filenames,varnames(selec));
