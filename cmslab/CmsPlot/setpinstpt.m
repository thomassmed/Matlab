function setpinstpt(st)
% setpinstpt is used by pinplot to change state point

% Mikael Andersson 2011-11-28
%% get data from pinplot
pinfig=gcf;
pinplot_prop=get(pinfig,'userdata');
pinplot_prop.st_pt = st;
%% Read new data from file
if isfield(pinplot_prop,'pininfo')
    pinstruct = ReadCore(pinplot_prop.pininfo,{'PINPOW3','fuel_data','pinexp3'},pinplot_prop.st_pt,pinplot_prop.coreinfo.serial(pinplot_prop.knumuse));
    % create pindata
    pinw = cellpin2stcell(pinstruct.pinpow3);
    pine = cellpin2stcell(pinstruct.pinexp3);
    pindata.pinpow = pinw{1};
    pindata.pinexp = pine{1};
    pindata.kdfuel = pinstruct.fuel_data.KDFUEL;
    pindata.ser = pinstruct.fuel_data.SERIAL{st}(pinplot_prop.knumuse); % TODO: check with other state points..
    pindata.knums = pinplot_prop.knumuse;
    pindata.npin = pinstruct.fuel_data.NPIN(pinplot_prop.knumuse,st);
    pindata.ia = pinstruct.fuel_data.IIAS(pinplot_prop.knumuse);
    pindata.ja = pinstruct.fuel_data.JJAS(pinplot_prop.knumuse);
    pindata.nfran = pinstruct.fuel_data.IROT(st); % TODO: check this!!
    pindata.Xpo = pinstruct.fuel_data.XPO(st);
else
    pindata = ReadCore(pinplot_prop.coreinfo,'pindata',pinplot_prop.st_pt,pinplot_prop.knumuse);
end
%% save new data
pinplot_prop.pindata = pindata;
set(pinfig,'userdata',pinplot_prop);
%% draw new data
DrawCtrrod;
PlotPinData;
end