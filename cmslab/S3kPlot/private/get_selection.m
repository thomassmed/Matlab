function get_selection(varargin)
%%
if length(varargin)==1, 
    iselect=varargin{1};
else
    iselect=varargin{3};
end
hmainFig=gcf;
s3kplot_prop=get(hmainFig,'userdata');

%% Pick up needed variables
filters=s3kplot_prop.filters;
Names=s3kplot_prop.Names;
%%

if iscell(filters.Mask), filters.Mask=filters.Mask{1};end
iSel=find(filters.Mask==iselect);
NamesSel=cell(length(iSel),1);
for i=1:length(iSel),
    NamesSel{i}=Names{iSel(i)};
end 
if isempty(iSel) 
    NamesSel=Names;  
end
    
%% open a new figure
figsz=get(hmainFig,'pos'); 
winheight=figsz(4);
winwidth= max(0.20*figsz(3),100);

hvar=uicontrol (hmainFig, 'style', 'listbox', 'Max',100,'string', NamesSel,...
    'units','Normalized','position', [0 0 .22 .92]);
set(hvar,'callback',{@plot_s3k,gcbo});
hplot_button=uicontrol('style','pushbutton', 'units','Normalized',...
                       'position',[.02 .95 .07 .04],...
                       'string','plot in new', ...
                       'callback',{@plot_s3k,gcbo});                   
%%
s3kplot_prop.NamesSel=NamesSel;
set(hvar,'Value',[]);
s3kplot_prop.hvar=hvar;
s3kplot_prop.hplot_button=hplot_button;
s3kplot_prop.iselect=iselect;
set(hmainFig,'userdata',s3kplot_prop);
