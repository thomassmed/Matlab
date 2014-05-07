function DrawCtrrod
% DrawCtrrod gets data and draws the control rod for pinplot

%% get data from pinplot
pinfig = gcf;
pinplot_prop=get(pinfig,'userdata');
coreinfo = pinplot_prop.coreinfo;
stpt = pinplot_prop.st_pt;
npin = pinplot_prop.pindata.npin;
%% read the nessesary data from restart file
if strcmpi(coreinfo.fileinfo.type,'res')
    control_rod_data = ReadCore(coreinfo,'control rod',stpt);
else 
    konrod = ReadCore(coreinfo,'CRD.POS',stpt);
    control_rod_data.konrod = konrod;
    control_rod_data.crmminj = coreinfo.core.crmminj;
    control_rod_data.crdsteps = max(konrod);
end
if pinplot_prop.casmoori
    nfra = 0;
else
    nfra = pinplot_prop.pindata.nfran;
end
controlrod = cr2core(control_rod_data.konrod,coreinfo.core.mminj,control_rod_data.crmminj,nan);
%% delete the old controlrod
if max(strcmp(fieldnames(pinplot_prop),'ctrd')) && min(pinplot_prop.ctrd) ~= 0
    delete(pinplot_prop.ctrd);
end
if max(strcmp(fieldnames(pinplot_prop),'ctrdtext')) && min(pinplot_prop.ctrdtext) ~= 0
    delete(pinplot_prop.ctrdtext);
end
%% check if the controlrod is inserted or not
ctrdnum = controlrod(pinplot_prop.pindata.ia,pinplot_prop.pindata.ja);
if ctrdnum == control_rod_data.crdsteps
    rodcol = 'm';
    rodin = 0;
else
    rodcol = 'blue';
    rodin = 1;
end
if ~rodin || isnan(ctrdnum)
    ctrdtext = 0;
end
%% draw the control rod 
switch nfra
    case 2 %nw
        ctrd = line([0,npin+1 ; npin+1.5 npin+1.5]',[-0.5 -0.5; 0 npin+1]','color',rodcol, 'LineWidth',8);
        if rodin && ~isnan(ctrdnum)
            ctrdtext = text(npin+1.4,-0.4,num2str(ctrdnum),'FontWeight','Bold');
        end
    case 1 %ne
        ctrd = line([0,npin+1; npin+1.5,npin+1.5]',[npin+1.5 npin+1.5;npin+1 0]','color',rodcol, 'LineWidth',8);
        if rodin && ~isnan(ctrdnum)
            ctrdtext = text(npin+1.4,npin+1.5,num2str(ctrdnum),'FontWeight','Bold');
        end
    case 0 %se
        ctrd = line([-0.5,-0.5; 0 npin+1]',[0 npin+1; npin+1.5 npin+1.5]','color',rodcol, 'LineWidth',8);
        if rodin && ~isnan(ctrdnum)
            ctrdtext = text(-0.75,npin+1.5,num2str(ctrdnum),'FontWeight','Bold');
        end
    case 3 %sw
        ctrd = line([-0.5,-0.5;0 npin+1]',[npin+1 0; -0.5 -0.5]','color',rodcol, 'LineWidth',8);
        if rodin && ~isnan(ctrdnum)
            ctrdtext = text(-0.75,-0.4,num2str(ctrdnum),'FontWeight','Bold');
        end
end
%% save control rod data to userdata
pinplot_prop.ctrd = ctrd;
pinplot_prop.ctrdtext = ctrdtext;
set(pinfig,'userdata',pinplot_prop);

