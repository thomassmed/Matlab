function PlotProfData(xps)
% PlotProfData is used by Pin_Prof_Plot to plot data
% 
% See also Pin_Prof_Plot

% Mikael Andersson 2011-12-15

%% get data from the figure
proffig=gcf;
proffig_prop=get(proffig,'userdata');
pindata = proffig_prop.pindata;
nodpl = proffig_prop.nodpl;
datatype = proffig_prop.datatype;
Xpo = proffig_prop.coreinfo.Xpo;
kmax = proffig_prop.coreinfo.core.kmax;
%% plot data
hold off
proffig_prop.plotdata = [];
if proffig_prop.Sim == 5
    Yhei = cumsum(proffig_prop.geom);
    
    xlen = round(max(pindata(:))+max(pindata(:))/10);
    Xnod = [(zeros(1,kmax))' (ones(1,kmax)*xlen)'];
    Ynod = [(1:kmax)' (1:kmax)']*Yhei(end)/kmax;
    [AX,profplots,H2] = plotyy(pindata(:,xps),Yhei,Xnod',Ynod');
        axtick1 = get(AX(1),'Ytick');
    set(AX,'Ytick',[]);
    set(AX(1),'Box','Off');
    set(AX(1),'Ytick',axtick1);
    numm = round(kmax/5);
    
    set(AX(2),'YTick',Yhei(end)/numm*(1:numm)-Yhei(end)/50)
    for i = 1:numm
       tickcell{i} = num2str(5*i);
    end
    set(AX(2),'YTickLabel',tickcell)
    set(H2,'LineStyle',':','color','b')
    axis(AX,[0 xlen 0 axtick1(end)])
    ylabel(AX(1),'Core Height');
    ylabel(AX(2),'Node Planes');
else
    Yhei = 1:nodpl;
    profplots = plot(pindata(:,xps),Yhei');
    proffig_prop.plotdata = pindata(:,xps);
    ylabel('Node Planes');
end

% for i = xps
%     dynamplots(l) = plot(pindata(:,i)',Yhei);
%     l=l+1;
%     hold all
% end
% plot(Xnod',Ynod','b:')
%% legend 
for i = 1:length(Xpo)
    lgdstr{i} = ['Xpo: ' num2str(Xpo(i))];
end
legend(lgdstr(xps),'Location','SouthEastOutside') % TODO: is in the way.. don't know where to put it..
%% save data
proffig_prop.dynamplots = profplots;
set(proffig,'userdata',proffig_prop);
%% axis and title

set(gca,'position',[0.2 0.11 0.6 0.8]);
if strcmp(datatype,'POW')
    xstr = 'Pin Power';
else
    xstr = 'Pin Exposure';
end
xlabel(xstr);
title(['Channel: ' num2str(proffig_prop.knums) ', Pin ' proffig_prop.xlab{proffig_prop.pos(1)} ',' proffig_prop.ylab{proffig_prop.pos(2)}]);