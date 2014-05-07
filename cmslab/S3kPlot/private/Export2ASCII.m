%Export data from figure
function Export2ASCII (varargin)
hmainFig=gcf;
s3kplot_prop=get(hmainFig,'userdata');
%% 
data=s3kplot_prop.data;
Names=s3kplot_prop.Names; 
NamesSel=s3kplot_prop.NamesSel; 
filename=s3kplot_prop.filename;
hvar=s3kplot_prop.hvar; 
isel=get(s3kplot_prop.hvar,'Value'); 
%% 
itotSel=[];
for i=1:length(isel), 
    itotSel(i)=strmatch(NamesSel{isel(i)},Names,'exact');
end
%% 
itotSel=[1,itotSel]; 
itotSel=unique(itotSel);
nvar=length(itotSel);
ListNames=cell(nvar,1);
for i=1:nvar,
    ListNames{i}=Names{itotSel(i)};
end 
%%
printfile=strrep(filename,'.cms','.ascii'); %Get data 2 ascii
fid=fopen(printfile,'w');
pwidth=12;
rows=split_rows(ListNames,pwidth);      %Sort each data for new rows
for j=1:size(rows,1)
    for i=1:nvar,
        fprintf(fid,'%s\t',rows{j,i});
    end
    fprintf(fid,'\n'); 
end
fprintf(fid,'\n'); 

%% Export right amount of data 2 ascii
for j=1:size(data,2) 
    for i=1:length(itotSel)
        format=['%',num2str(pwidth-1),'g \t'];
        fprintf(fid,format,data(itotSel(i),j));
    end 
    fprintf(fid,'\n');
end
fclose(fid);