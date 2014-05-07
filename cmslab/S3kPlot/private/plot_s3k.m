
function plot_s3k(varargin) 
% plot_s3k function called from s3kplot figure 

%%
hmainFig=gcf; %Get current figure handle
s3kplot_prop=get(hmainFig,'userdata');  %Get figure properties

callObject=varargin{1};
if strcmp(get(callObject,'string'),'plot in new')       %Export to new window
    hplotFig=figure;            %Plot figure in new window
    datacursor=0;
else
    hax=s3kplot_prop.hax;           %New handle
    axes(hax);
    datacursor=1;
end


hvar=s3kplot_prop.hvar;
Names=s3kplot_prop.Names;
NamesSel=s3kplot_prop.NamesSel;
isel=get(s3kplot_prop.hvar,'Value');    %Choosen variabel
data=s3kplot_prop.data;
if length(isel)==1, % only one variable selected
    hold off
    sel_str=NamesSel{isel};         %Picked names from file
    itotSel=strmatch(sel_str,Names,'exact');    %Match right object
    hplot=plot(data(1,:),data(itotSel,:));      %Plot only choosen objects
    set(hplot, 'ButtonDownFcn',@show_DisplayName,'DisplayName',Names{itotSel});     %See line when mouse clicking
    grid on
    xlabel(Names{1});
    ylabel(sel_str);
    title(sel_str);
else
    hold off
    plotName=cell(length(isel),1);
    for i=1:length(isel),       %Many variabels selected
            if i==1, 
                hold off
            elseif i==2,
                hold all
            end
             sel_str=NamesSel{isel(i)}; %Plot many variabels
             plotName{i}=sel_str;
            itotSel=strmatch(sel_str,Names,'exact');
            hplot(i)=plot(data(1,:),data(itotSel,:));
            set(hplot(i), 'ButtonDownFcn',@show_DisplayName,'DisplayName',Names{itotSel});  
    end
    grid on
    xlabel(Names{1});
    legend(plotName,'location','NE');
end 

if datacursor,
    hdt = datacursormode;       %see which object who is choosen
    set(hdt,'Enable','on');     %Enable every time
    set(hdt,'DisplayStyle','window'); %Put infobox in window
end
s3kplot_prop.hplot=hplot;
set(hmainFig,'userdata',s3kplot_prop);