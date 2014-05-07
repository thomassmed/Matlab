function PlotPinData
% PlotPinData is the basic plotfunction for Pinplot

% Mikael 2011-12-21
%% get information from plot
pinfig=gcf;
pinplot_prop=get(pinfig,'userdata');
pindata = pinplot_prop.pindata;
coreinfo = pinplot_prop.coreinfo;
if pinplot_prop.casmoori 
    nfraax = 0;
    nfra = pinplot_prop.pindata.nfran;
    casmorot = 1;
elseif coreinfo.core.if2x2 == 2
    nfravec = [2 3 1 0];
    casmorot = 0;
    nfraax = nfravec(pinplot_prop.rotpos);
else
    nfraax = pinplot_prop.pindata.nfran;
    casmorot = 0;
end
%% change plot text
knums = pindata.knums;
nod_plane = pinplot_prop.nod_plane;

nodtext = pinplot_prop.nodtext;
if max(strcmp(fieldnames(pinplot_prop),'hcross')) 
    delete(pinplot_prop.hcross);
    pinplot_prop = rmfield(pinplot_prop,'hcross');
end
if strcmpi(pinplot_prop.dataplot,'POW')
    datastr = ['Power - ' pinplot_prop.datacalc  '   '];
else
    datastr = ['Exposure - ' pinplot_prop.datacalc '   '];
end
datastring{1} = datastr;

if strcmp(pinplot_prop.coordinates,'ij')
    iatext = num2str(pinplot_prop.pindata.ia);
    jatext = num2str(pinplot_prop.pindata.ja);
else
    iatext = pinplot_prop.axlabels.assemlabs.lab2{pinplot_prop.pindata.ja};
    jatext = pinplot_prop.axlabels.assemlabs.lab1{pinplot_prop.pindata.ia};
end

if coreinfo.core.if2x2 == 2
        subnums=crnum2knum(coreinfo.core.knum,coreinfo.core.mminj2x2);
        %subnums = convert2x2('2subnum',coreinfo.core.knum,coreinfo.core.mminj,'full');
    [pos quart] = find(knums == subnums);
    switch quart
        case 1
            assori='NW';
        case 2
            assori='NE';
        case 3
            assori='SW';
        case 4
            assori='SE';
    end
    datastring{2} = ['Pos(ia,ja): ('  ... 
     iatext ',' ...
     jatext ')' ...
     '  Knum: ' num2str(pos) ' Asspos: ' assori ...
     '  Serial: ' pinplot_prop.coreinfo.serial{pos}];
else
    datastring{2} = ['Pos(ia,ja): ('  ... 
     iatext ',' ...
     jatext ')' ...
     '  Knum: ' num2str(knums) ...
     '  Assembly Serial: ' pinplot_prop.coreinfo.serial{knums}];
end


if pinplot_prop.nod_plane(1) == pinplot_prop.nod_plane(2)
    nodestring =  ['Node: ' num2str(pinplot_prop.nod_plane(1))];
else
    nodestring = ['Nodes: ' num2str(pinplot_prop.nod_plane(1)) ':' num2str(pinplot_prop.nod_plane(2))];
end
datastring{3} = {['StatePoint: ' num2str(pinplot_prop.st_pt) ...
     '  XPO: ' num2str(pinplot_prop.pindata.Xpo)];
   nodestring};
for i = 1:3
    set(nodtext(i),'String',datastring{i},'FontSize',10); 
end
    
%% clear old pin plot
if max(strcmp(fieldnames(pinplot_prop),'circs'))
    delete(pinplot_prop.circs(pinplot_prop.circs ~= 0));
end
if max(strcmp(fieldnames(pinplot_prop),'numbplots'))
    delete(pinplot_prop.numbplots(pinplot_prop.numbplots ~= 0));
    pinplot_prop = rmfield(pinplot_prop,'numbplots');
end


%% prepare new plot data
circs = zeros(pindata.npin);
numbplots = zeros(pindata.npin);
hold on
t = 0 : 0.05 : 2*pi;
it = fliplr(1:pindata.npin);
eval(['data = pindata.pin' lower(pinplot_prop.dataplot) ';']);
if iscell(data)
    data = data{1};
end
%% rotate data if casmo orientation is wanted or PWR
%% TODO: check rotation for PWR
if coreinfo.core.if2x2 == 2 && ~casmorot
    rotvec = [2 1 3 0];
    rotpos = pinplot_prop.rotpos;
    for i = 1:size(data,3)
        data(:,:,i) = rot90(data(:,:,i),rotvec(rotpos));
    end
elseif casmorot && coreinfo.core.if2x2 ~= 2
    rotdata = zeros(size(data));
    for i = 1:size(data,3)
        rotdata(:,:,i) = rot90(data(:,:,i),nfra);
    end
    data = rotdata;
end


%% plot circles
for i = 1:pindata.npin
    for j = 1:pindata.npin
        % take care of datacalc (mean, max, min) and pow or exp
        eval(['plotdata(j,i) = ' lower(pinplot_prop.datacalc) '(data(it(j),i,nod_plane(1):nod_plane(2)));']);
        
        x = 0.39*cos(t) + i;
        y = 0.39*sin(t) + j;
        if (plotdata(j,i) > 0)
            circs(j,i) = fill(x, y,plotdata(j,i));
        else
%             circs(j,i) = fill(x, y,[1 1 1]);
        end
    end
end
pinplot_prop.savdat.plotdata = double(flipud(plotdata));
% pinplot_prop.rawdata = data;
%% plot values if wanted
if strcmp(pinplot_prop.numberplot,'val')
    for i = 1:pindata.npin
        for j = 1:pindata.npin
            plotdatastr = num2str(plotdata(j,i));
            if (plotdata(j,i) > 0)
                if length(plotdatastr) >= 4
                    numbplots(j,i) = text(i,j,plotdatastr(1:4),'HorizontalAlignment','center');
                else
                    numbplots(j,i) = text(i,j,plotdatastr(1:length(plotdatastr)),'HorizontalAlignment','center');
                end
            else
%                 numbplots(j,i) = text(i,j,plotdatastr);
            end
        end
    end
end

%% set scale to colorbar
datamin = min(plotdata(plotdata ~= 0));
datamax = max(plotdata(:));
colorbar
if strcmpi(pinplot_prop.autoscale,'no')
    caxis([pinplot_prop.scale_min pinplot_prop.scale_max]);
elseif strcmpi(pinplot_prop.autoscale,'yes')
    pinplot_prop.scale_min = datamin;
    pinplot_prop.scale_max = datamax;
    if datamax ~= 0
        caxis([pinplot_prop.scale_min pinplot_prop.scale_max])
    end
end

%% Create axlabels
switch pinplot_prop.axkind 
    case 1
    letstr = 'ABCDEFGHIJKLMNOPQRSTUV';
    for i = 1:pinplot_prop.pindata.npin
        letlab{i} = letstr(i);
        numlab{i} = num2str(i);
    end
    ordxlab = numlab;
    ordylab = letlab;
    case 2 
    letstr = 'ABCDEFGHIJKLMNOPQRSTUV';
    itvar = fliplr(1:pinplot_prop.pindata.npin);
    for i = 1:pinplot_prop.pindata.npin
        letlab{i} = letstr(itvar(i));
        
        numlab{i} = num2str(itvar(i));
    end
    ordxlab = letlab;
    ordylab = numlab;
end
switch nfraax
    case 0
        xlab = fliplr(ordxlab);
        ylab = ordylab;
    case 1
        xlab = ordylab;
        ylab = ordxlab;
    case 2
        xlab = ordxlab;
        ylab = fliplr(ordylab);
    case 3
        xlab = fliplr(ordylab);
        ylab = fliplr(ordxlab);
end

set(gca,'Xtick',1:pindata.npin)
set(gca,'Ytick',1:pindata.npin)
set(gca,'YTickLabel',ylab);
set(gca,'XTickLabel',xlab);
pinplot_prop.savdat.plotxlab = xlab;
pinplot_prop.savdat.plotylab = ylab;
pinplot_prop.savdat.cordtyp = 'pin';


%% save new data to userdata
pinplot_prop.ylab = ylab;
pinplot_prop.xlab = xlab;
pinplot_prop.circs = circs;
pinplot_prop.data = data;
if strcmp(pinplot_prop.numberplot,'val')
    pinplot_prop.numbplots = numbplots;
end
set(pinfig,'userdata',pinplot_prop);

end