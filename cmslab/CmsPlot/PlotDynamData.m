function PlotDynamData(nods)
% PlotDynamData is used by Pin_Dynam_Plot to plot data

% Mikael Andersson 2011-12-09
%% get data from the figure
dynamfig=gcf;
dynamfig_prop=get(dynamfig,'userdata');
pindata = dynamfig_prop.pindata;
Xpo = dynamfig_prop.coreinfo.Xpo;
datatype = dynamfig_prop.datatype;
%% plot data
l = 1;
hold off
dynamfig_prop.plotdata = [];
for i = nods
    dynamplots(i) = plot(Xpo,pindata(i,:));
    dynamName{i}=['Node ',num2str(i)];
    set(dynamplots(i), 'ButtonDownFcn',@show_DisplayName,'DisplayName',dynamName{i});
    dynamfig_prop.savdat.plotdata(l,:) = pindata(i,:);
    l=l+1;
    hold all
end
hdt = datacursormode;       %see which object who is choosen
set(hdt,'Enable','on');     %Enable every time
set(hdt,'DisplayStyle','window'); %Put infobox in window
%% legend 
%for i = nods
%    lgdstr{i} = ['Nod ' num2str(i)];
%end
%hl=legend(lgdstr(nods),'Location','EastOutside')
%% save data

dynamfig_prop.dynamplots = dynamplots;
set(dynamfig,'userdata',dynamfig_prop);
xlabel('Xpo');
%% axis and title
set(gca,'position',[0.22 0.11 0.75 0.8]);
if strcmp(datatype,'POW')
    ystr = 'Pin Power';
else
    ystr = 'Pin Exposure';
end
ylabel(ystr);
title(['Channel: ' num2str(dynamfig_prop.knums) ', Pin ' dynamfig_prop.xlab{dynamfig_prop.pos(1)} ',' dynamfig_prop.ylab{dynamfig_prop.pos(2)}]);