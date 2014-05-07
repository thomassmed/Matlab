function Export2Excel (varargin)
hmainFig=gcf;
s3kplot_prop=get(hmainFig,'userdata');
%% 
data=s3kplot_prop.data;
Names=s3kplot_prop.Names; 
NamesSel=s3kplot_prop.NamesSel; 
filename=s3kplot_prop.filename;
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
printfile=strrep(filename,'.cms',['-',datestr(now,30),'.xls']);
[stat,msg]=xlswrite(printfile,ListNames','Sheet1'); 
if isempty(findstr(msg.message,'Could not start Excel server'))
    xlswrite(printfile,data(itotSel,:)','Sheet1','A2');
else
    printfile=strrep(printfile,'.xls','.csv');
    fid=fopen(printfile,'w');
    for i=1:length(ListNames),
        fprintf(fid,'%s',ListNames{i});
        fprintf(fid,',');
    end
    fprintf(fid,'\n');
    for j=1:size(data,2),
        fprintf(fid,'%g,',data(itotSel,j));
        fprintf(fid,'\n');
    end
    fclose(fid);
end
