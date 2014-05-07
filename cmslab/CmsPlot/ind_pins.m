function ind_pins
% ind_pins is used by pinplot to plot individual axial distributions

%% get data from pinplot
pinfig = gcf;
pinplot_prop=get(pinfig,'userdata');
pindata = pinplot_prop.pindata;
npin = pindata.npin;
if iscell(pindata.pinexp), pindata.pinexp=pindata.pinexp{1};end
kmax = pinplot_prop.coreinfo.core.kmax;
figure(pinfig)
uiwait(msgbox('Left button to select, right to plot'));
%% start choosing pins wanted
i=0;
button = 1;
while button==1
    [xx,yy,button]=ginput(1);
    if button==1
        i=i+1;
        x(i,1)=xx;
        y(i,1)=yy;
        nx(i)=round(xx);
        ny(i)=round(yy);
        % set cross on pin
        xl=[nx(i)-0.39*cos(pi/4) nx(i)+0.39*cos(pi/4);
           nx(i)+0.39*cos(pi/4) nx(i)-0.39*cos(pi/4)];
        yl=[ny(i)-0.39*cos(pi/4) ny(i)-0.39*cos(pi/4);
           ny(i)+0.39*cos(pi/4) ny(i)+0.39*cos(pi/4)];
        if ~(nx(i)<=0 || ny(i)<=0) && ~(nx(i)>=npin+1 || ny(i)>=npin+1)
            hcross(:,i)=line(xl,yl,'color','black','erasemode','none');
        else
            i=i-1;
        end
    end
end
%% get and plot the pin data wanted
indpinfig = figure;
uimenu('label','Export Data','callback','SavedataGUI(0);');
temp=nx;
nx=pinplot_prop.pindata.npin+1-ny;
ny=temp;
for i = 1:length(nx)
    eval(['axdata(i,:) = pindata.pin' lower(pinplot_prop.dataplot) '(nx(i),ny(i),:);'])
    
end
indpin_prop.savdat.plotdata = axdata';
indpin_prop.coreinfo = pinplot_prop.coreinfo;

if isfield(pinplot_prop.coreinfo.fileinfo,'Sim') && pinplot_prop.coreinfo.fileinfo.Sim == 5
    yvar = cumsum(pinplot_prop.pindata.geoms);
    xlen = round(max(axdata(:))+max(axdata(:))/10);
    Xnod = [(zeros(1,kmax))' (ones(1,kmax)*xlen)'];
    Ynod = [(1:kmax)' (1:kmax)']*yvar(end)/kmax;
    [AX,dum,H2] = plotyy(axdata',yvar',Xnod',Ynod');
    axtick1 = get(AX(1),'Ytick');
    set(AX,'Ytick',[]);
    set(AX(1),'Box','Off');
    set(AX(1),'Ytick',axtick1);
    numm = round(kmax/5);
    
    set(AX(2),'YTick',yvar(end)/numm*(1:numm)-yvar(end)/50)
    for i = 1:numm
       tickcell{i} = num2str(5*i);
    end
    set(AX(2),'YTickLabel',tickcell)
    axis(AX,[0 xlen 0 axtick1(end)])
    ylabel(AX(1),'Core Heigth');
    ylabel(AX(2),'Node Planes');
    set(H2,'LineStyle',':','color','b')
    indpin_prop.savdat.plotxvar = {yvar};
else
    yvar = 1:pinplot_prop.nod_plane(2);
    plot(axdata',yvar');
    ylabel('Node Planes');
end
set(indpinfig,'userdata',indpin_prop);

%% set legend
xlab = pinplot_prop.xlab;
ylab = pinplot_prop.ylab;
for i = 1:length(nx), 
    legc{i,:} = cell2mat([xlab(nx(i)) ',' ylab(ny(i))]); 
end

 
legend(legc,'Location','Best')
% save data to pinplot
pinplot_prop.hcross = hcross;
set(pinfig,'userdata',pinplot_prop);

if strcmp(pinplot_prop.dataplot,'POW')
    xstr = 'Pin Power';
else
    xstr = 'Pin Exposure';
end
xlabel(xstr);
title(['Individual Pin(s) in channel: ' num2str(pinplot_prop.pindata.knums)])



