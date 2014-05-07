%Label Specials, underlabel Statistic
function StatMaxMin (varargin) 
hmainFig=gcf;
s3kplot_prop=get(hmainFig,'userdata'); %Data from s3k
%% Import variabels from s3k
data=s3kplot_prop.data;
Names=s3kplot_prop.Names; 
NamesSel=s3kplot_prop.NamesSel; 
filename=s3kplot_prop.filename;
hvar=s3kplot_prop.hvar; 
isel=get(s3kplot_prop.hvar,'Value');    %Value of choosen variabel
%% Show choosed variabel
itotSel=[];
for i=1:length(isel), 
    itotSel(i)=strmatch(NamesSel{isel(i)},Names,'exact');       
end
%% Pick from maindata 
itotSel=itotSel; 
itotSel=unique(itotSel);
nvar=length(itotSel);
ListNames=cell(nvar,1);
for i=1:nvar,
    ListNames{i}=Names{itotSel(i)};
end  
%% Show categories by clicking
           %0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
fprintf(1,'   Mean      Max       MaxTime MxIndx Min       MinTime MnIndx Start Val End Val  Index  Name  \n'); 
%Names of valued variabels 
for i=1:length(itotSel)
    cur_data=data(itotSel(i),:);
    [max_value,imax]=max(cur_data);
    maxtime=data(1,imax);
    [min_value,imin]=min(cur_data);
    mintime=data(1,imin);
    start_value=cur_data(1);
    end_value=cur_data(end);
    mean_value=mean(cur_data);
    fprintf(1,'%10g%10g%10g%5i%10g%10g%5i%10g%10g %5i  %s \n',mean_value,max_value,maxtime,imax,min_value,mintime,... %fix variabels in straight lines
            imin,start_value,end_value,itotSel(i),ListNames{i});
end
    

