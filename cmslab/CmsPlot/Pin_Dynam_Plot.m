function Pin_Dynam_Plot
% Pin_Dynam_Plot is used by pinplot to make a dynamic plot
% 
% See also PlotDynamData, Pin_Prof_Plot

% Mikael Andersson 2011-12-15
%% get info from pinplot
pinfig=gcf;
pinplot_prop=get(pinfig,'userdata');
coreinfo = pinplot_prop.coreinfo;
npin = pinplot_prop.pindata.npin;
datatype = pinplot_prop.dataplot;
%% Read data for all state points
if strcmpi(coreinfo.fileinfo.type,'res') && ~isfield(pinplot_prop,'pininfo')
    evalstr = ['data = ReadRes(coreinfo,' char(39) 'pin' lower(pinplot_prop.dataplot) char(39) ',' char(39) 'all' char(39) ',pinplot_prop.pindata.knums);'];
    eval(evalstr);
else
    evalstr = ['data = ReadCore(pinplot_prop.pininfo, ''pin' pinplot_prop.dataplot '3'' , ''all'' , pinplot_prop.pininfo.serial(pinplot_prop.pindata.knums));'];
    eval(evalstr);
    data = cellpin2stcell(data);
end
%% message box
figure(pinfig);
mesg_string = { 'Left click to select starting point '
    '                                    '
    'Arrows to navigate                  '
    '                                    '
    'Left click again for new start point'
    '                                    '
    'Right click to quit         '};
hmsg = msgbox(mesg_string);
uiwait(hmsg); 
%% create window
scrsz = get(0,'ScreenSize');
dM=scrsz(3)*0.2;
sidy=scrsz(4)/1.7;
sidx=1.2*sidy;
dynamfig = figure('Position',[scrsz(3)/2 sidy-dM sidx sidy]);
uimenu('label','Export Data','callback','SavedataGUI(0);');
dynamfig_prop.coreinfo = coreinfo;
dynamfig_prop.datatype = datatype;
dynamfig_prop.knums = pinplot_prop.pindata.knums;
dynamfig_prop.xlab = pinplot_prop.xlab;
dynamfig_prop.ylab = pinplot_prop.ylab;
%% create listbox 
str = cell(1,length(coreinfo.Xpo));
for i=1:pinplot_prop.nod_plane(2),
    str{i}=sprintf('Node: %i',i);
end
nodlist = uicontrol('style','listbox','Max',100,'units','normalized','position',[0 0 0.15 0.94],'string', str);
set(nodlist,'callback','st=get(gcbo,''Value'');PlotDynamData(st);;');
%% choose pin and plot
contin = 1;
while contin
    figure(pinfig);
    % choose data from pinplot
    [xx, yy, button] = ginput(1);
    if isempty(button), break;end
    switch(button)
        case 1
            nx = round(xx);
            ny = round(yy);
            if nx<1, nx=1; elseif nx>npin; nx=npin; end
            if ny<1, ny=1; elseif ny>npin; ny=npin; end
        case 3
            contin = 0; return;
        case 28
            if nx>1, nx=nx-1; end
        case 29
            if nx<npin, nx=nx+1; end
        case 30
            if ny<npin, ny=ny+1; end
        case 31
            if ny>1, ny=ny-1; end
        otherwise
            contin = 0; return;
    end
    % draw cross on choosen pin
    xl=[nx-0.39*cos(pi/4) nx+0.39*cos(pi/4);
       nx+0.39*cos(pi/4) nx-0.39*cos(pi/4)];
    yl=[ny-0.39*cos(pi/4) ny-0.39*cos(pi/4);
       ny+0.39*cos(pi/4) ny+0.39*cos(pi/4)];
    if max(strcmp(fieldnames(pinplot_prop),'dynmcross')) && max(pinplot_prop.dynmcross(1) == findall(0,'type','line'))
        delete(pinplot_prop.dynmcross);
    end
    dynmcross=line(xl,yl,'color','black','erasemode','none');
    pinplot_prop.dynmcross = dynmcross;
    set(pinfig,'userdata',pinplot_prop);
    %% get plot data and use PlotDynamData to plot the data
    for i = 1:length(data) 
        pindata(:,i) = data{i}(npin+1-ny,nx,:); 
    end
    figure(dynamfig)
    dynamfig_prop.pindata = pindata;
    dynamfig_prop.pos = [nx ny];
    dynamfig_prop.plotdata = 1;
    set(dynamfig,'userdata',dynamfig_prop);
    PlotDynamData(1:pinplot_prop.nod_plane(2));
    dynamfig_prop=get(dynamfig,'userdata');    
end