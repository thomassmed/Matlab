function Save_plot

currfig=gcf;

prompt = 'Enter filename:';
dlg_title = 'Save';
num_lines = 1;
def = {'Pinplot.fig'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
filename = answer{1};
saveas(currfig,filename);

end