function PlotCmsProfile(varargin) 
% plot_s3k function called from s3kplot figure 

%%
hcmsp=gcf; %Get current figure handle
CmsProfileProp=get(hcmsp,'userdata');  %Get figure properties
hax=CmsProfileProp.hax;   
hvar=CmsProfileProp.hvar;
data=CmsProfileProp.data;
knum=CmsProfileProp.knum;
knm=CmsProfileProp.knums; % Selected channel
Xpo=CmsProfileProp.Xpo;
resS5=CmsProfileProp.resS5;
nodplan=CmsProfileProp.nodplan;
isel=get(hvar,'Value');    %Choosen exp point/ time steps
legstr=CmsProfileProp.legstr;
plottype=CmsProfileProp.plottype;
hold off
plotName=cell(length(isel),1);
hplot=NaN(length(isel),1);
datacursor=0;
if plottype==1,
    for i=1:length(isel),       %Many variabels selected
        if i==1,
            hold off
        elseif i==2,
            hold all
        end
        sel_str=legstr{isel(i)}; %Plot many variabels
        plotName{i}=sel_str;
        [knums,jdum]=find(knum==knm);knums=knums(1); %Pull out the symmetric correspondence
        if resS5
            delete(CmsProfileProp.H1);
            kmax = CmsProfileProp.kmax;
            yvar = CmsProfileProp.yvar;
            xvar = [data{isel}];
            xlen = CmsProfileProp.xlen;
            Xnod = [(zeros(1,kmax))' (ones(1,kmax)*xlen)'];
            Ynod = [(1:kmax)' (1:kmax)']*yvar(end)/kmax;
            hold on
            CmsProfileProp.H1 = plot(xvar,yvar);
        else
            hplot(i)=plot(hax,data{isel(i)}(nodplan),nodplan);
            CmsProfileProp.savdat.plotdata = data{isel(i)}(nodplan);
        end
    end    
else
    plotName=legstr(isel);
    yvar = cell2mat(data);
    hplot=plot(Xpo',(yvar(isel,:))');
    CmsProfileProp.savdat.plotdata = yvar(isel,:);
end
if datacursor,
    set(hplot(i), 'ButtonDownFcn',@show_DisplayName,'DisplayName',sel_str);
end
% grid on
% ylabel('Node Plane');
legend(plotName,'location','EastOutside');

if datacursor,
    hdt = datacursormode;       %see which object who is choosen
    set(hdt,'Enable','on');     %Enable every time
    set(hdt,'DisplayStyle','window'); %Put infobox in window
end
CmsProfileProp.hplot=hplot;
set(hcmsp,'userdata',CmsProfileProp);