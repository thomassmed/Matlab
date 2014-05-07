function ExportAll2Excel (varargin)
hmainFig=gcf;
s3kplot_prop=get(hmainFig,'userdata');
%% 
data=s3kplot_prop.data;
Names=s3kplot_prop.Names;  
filename=s3kplot_prop.filename;
if iscell(s3kplot_prop.filters.Mask),
    Mask=s3kplot_prop.filters.Mask{1};
else
    Mask=s3kplot_prop.filters.Mask;
end
Labels=s3kplot_prop.filters.Labels_Compact;
%% 
all_i=unique(Mask)';
printfile=strrep(filename,'.cms','.xls');
if exist(printfile,'file'),
    delete(printfile);
end
%%
for i=all_i,
    imask= Mask==i;
    ListNames=Names(imask);
    xlswrite(printfile,ListNames',Labels{i});
    xlswrite(printfile,data(imask,:)',Labels{i},'A2'); 
end
