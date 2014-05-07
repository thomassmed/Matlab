%% Query handle 0
get(0);

%% Change the name of a figure window
f = figure;
set(f,'Name','This is a MATLAB figure');

%% Exercise 1
load gasprices;
plot(France,Germany);
set(get(gca,'Children'),'LineStyle','none');
set(get(gca,'Children'),'Marker','*');

% Alternative
plot(France,Germany,'*');

%% Exercise 2
load gasprices;
h1 = plot(Year,Germany);
hold all;
h2 = plot(Year,France);
h3 = plot(Year,Mexico);
hold off;

% Alternative
h = plot(Year,Germany,Year,France,Year,Mexico);

%% Annotating Plots
load gasprices;
h1 = plot(Year,Germany);
hold all;
h2 = plot(Year,France);
h3 = plot(Year,Mexico);
hold off;
get(gca);
set(gca,'XLim',[1992 2006]);
set(gca,'XTick',[1994 1998 2002]);
set(gca,'XTickLabel',{'Year 5','Year 9','Year 13'});
set(get(gca,'XLabel'),'String','Year');
set(gca,'XGrid','on');
l1 = legend('Germany','France','Mexico');
% TURN OFF LEGEND
l2 = legend([h3 h2 h1],{'Mexico','France','Germany'});

%% Subplots
subplot(3,3,5);

%% Exercise 3
load gasprices;
a1 = subplot(2,1,1);
h1 = plot(a1,gasprice(:,1),gasprice(:,11),'k',gasprice(:,1),gasprice(:,2),'b:',gasprice(:,1),gasprice(:,6),'r:');
% set(h1(1),'Color',[0 0 0]);
% set(h1(2),'Color',[0 0 1],'LineStyle',':');
% set(h1(3),'Color',[1 0 0],'LineStyle',':');
set(a1,'XLim',[1996 2004]);
set(get(a1,'XLabel'),'String','Year');
set(get(a1,'YLabel'),'String','Price of gasoline ($)');
set(a1,'XGrid','on','YGrid','on');
legend(a1,[h1(2) h1(3)],{'Australia','Italy'},'Location','NorthWest');
a2 = subplot(2,1,2);
h2 = plot(a2,gasprice(:,11),gasprice(:,7));
set(h2,'LineStyle','none','Marker','o','MarkerEdgeColor',[0 0.75 0],'MarkerFaceColor',[0 0.75 0]);
set(get(a2,'XLabel'),'String','Price of gasoline in US ($)');
set(get(a2,'YLabel'),'String','Price of gasoline in Japan ($)');