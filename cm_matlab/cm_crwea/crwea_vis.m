% $Id: crwea_vis.m 44 2012-07-16 10:18:15Z rdj $
%
function crwea_vis(resultfile)

%% Create the figure
fw=585;
fh=700;
f=figure('Position', [200 200 fw fh], 'Resize', 'off', 'Name', 'CRWE Analysis');

gdata.resultfile=resultfile;
gdata.sortorder=1;

[gdata.casedata,gdata.mminj]=get_table_data(gdata.resultfile);

% Load default settings for limits
[limit_settings,limit_names]=crwea_default_limits();
gdata.limit_settings=limit_settings;


%% Create some components
% Buttons
uicontrol('Tag','PlotButton','Style','pushbutton','String','Plot','Position',[10 fh-35 70 25],...
               'Callback', @plot_cases, 'Enable', 'off');

uicontrol('Tag','MapButton','Style','pushbutton','String','Map','Position',[90 fh-35 70 25],...
               'Callback', @plot_map, 'Enable', 'off');
           
uicontrol('Tag','BurplotButton','Style','pushbutton','String','Cycle envelope','Position',[10 fh-70 150 25],...
               'Callback', @plot_cpr_vs_burnup, 'Enable', 'off');

% Fields
uicontrol('Style','text','String','Limit settings:','Position',[fw-410 fh-30 100 19],...
          'BackgroundColor',[0.8 0.8 0.8]);
uicontrol('Tag','LimitSelect','Style','popupmenu','String',limit_names,...
          'Position',[fw-410 fh-60 100 20],'Callback',@update_limits);
      
      
uicontrol('Style','text','String','SLMCPR','Position',[fw-310 fh-30 70 19],...
          'BackgroundColor',[0.8 0.8 0.8]);
uicontrol('Tag','SlmcprEdit','Style','edit','String','1.06','Position',[fw-230 fh-30 70 20]);

uicontrol('Style','text','String','Sorting','Position',[fw-310 fh-60 70 19],...
          'BackgroundColor',[0.8 0.8 0.8]);
uicontrol('Tag','SortSelect','Style','popupmenu','String',{'Burnup';'CPRmin ER';'CPRmin VR'},...
          'Position',[fw-230 fh-60 70 20],'Callback',@update_table);
      

uicontrol('Style','text','String','Power limit','Position',[fw-150 fh-30 70 19],...
          'BackgroundColor',[0.8 0.8 0.8]);
powh=uicontrol('Tag','PowlimitEdit','Style','edit','String','200','Position',[fw-70 fh-30 60 20],...
               'Callback',@update_table);

uicontrol('Style','text','String','Flow limit','Position',[fw-150 fh-60 70 19],...
          'BackgroundColor',[0.8 0.8 0.8]);
flowh=uicontrol('Tag','FlowlimitEdit','Style','edit','String','0','Position',[fw-70 fh-60 60 20],...
               'Callback',@update_table);


      
%% Create the table
colnames={'Burnup' 'Mangrp' 'Rod' 'Flow' 'CPRmin ER' 'Power' 'CPRmin VR'};
colformat={'char' 'char' 'char' 'numeric' 'bank' 'bank' 'bank'};

tdata=filter_table_data(gdata.casedata,str2double(get(powh,'String')),str2double(get(flowh,'String')));

t = uitable(f, 'Tag', 'DataTable', 'Data', tdata, 'ColumnName', colnames, ...
    'Position', [0 0 fw fh-80], 'CellSelectionCallback', @select_cells,...
    'ColumnFormat', colformat);


%% Save data structure to guidata
guidata(f,gdata);

end


%%
function update_limits(hObject,eventdata)

gdata=guidata(hObject);
limits=gdata.limit_settings;

selind=get(findobj('Tag','LimitSelect'),'Value');

set(findobj('Tag','SlmcprEdit'),'String',limits(selind).slmcpr)
set(findobj('Tag','PowlimitEdit'),'String',limits(selind).powlimit)
set(findobj('Tag','FlowlimitEdit'),'String',limits(selind).flowlimit)

update_table(hObject,eventdata);

end


%%
function update_table(hObject,eventdata)

gdata=guidata(hObject);

powlimit=str2double(get(findobj('Tag','PowlimitEdit'),'String'));
flowlimit=str2double(get(findobj('Tag','FlowlimitEdit'),'String'));
sortorder=get(findobj('Tag','SortSelect'),'Value');

htable=findobj('Tag','DataTable');
tdata=filter_table_data(gdata.casedata,powlimit,flowlimit);

if sortorder==1
    [~,i]=sortrows(tdata(:,1));
elseif sortorder==2  
    [~,i]=sortrows(tdata(:,5));
elseif sortorder==3
    [~,i]=sortrows(tdata,7);
end
tdata=tdata(i,:);

set(htable,'Data',tdata);

end


%%
function plot_cases(hObject,eventdata)

gdata=guidata(hObject);

powlim=str2double(get(findobj('Tag','PowlimitEdit'),'String'));
flowlim=str2double(get(findobj('Tag','FlowlimitEdit'),'String'));
slmcpr=str2double(get(findobj('Tag','SlmcprEdit'),'String'));

% Loop over selected rows from table
tdata=get(findobj('Tag','DataTable'),'Data');
rows=unique(gdata.sel(:,1));
for i=1:length(rows)
    bur=tdata{rows(i),1};
    grp=tdata{rows(i),2};
    rod=tdata{rows(i),3};
    
    crwea_plot_case(gdata.resultfile,bur,grp,rod,powlim,flowlim,slmcpr);
end

end


%%
function plot_map(hObject,eventdata)

gdata=guidata(hObject);

% Loop over selected rows from table
tdata=get(findobj('Tag','DataTable'),'Data');
rows=unique(gdata.sel(:,1));
for i=1:length(rows)
    bur=tdata{rows(i),1};
    grp=tdata{rows(i),2};
    rod=tdata{rows(i),3};
    
    crwea_plot_map(gdata.resultfile,bur,grp,rod);
end

end


%% TODO Add check if VR and/or ER exists
function plot_cpr_vs_burnup(hObject,eventdata)

gdata=guidata(hObject);

% Loop over selected rows from table
tdata=get(findobj('Tag','DataTable'),'Data');
rows=unique(gdata.sel(:,1));

bursteps=unique(cell2mat(tdata(:,1)));
nbur=length(bursteps);

grps=num2str((cell2mat(tdata(:,2))));
rods=char(cellfun(@char,tdata(:,3),'UniformOutput',false));
cases=[grps ones(size(grps,1),1).*' ' rods];

selgrps=grps(rows,:);
selrods=rods(rows,:);
selcases=unique([selgrps ones(size(selgrps,1),1).*' ' selrods],'rows');

ncases=size(selcases,1);
bur=nan(nbur,ncases);
cpr_er=nan(nbur,ncases);
cpr_vr=nan(nbur,ncases);
for i=1:ncases
    ind=strmatch(selcases(i,:),cases);
    
    bur_case=cell2mat(tdata(ind,1));
    l=1:length(bur_case);
    [~,bind]=sort(bur_case);
    
    bur(l,i)=bur_case(bind);
    cpr_er_case=cell2mat(tdata(ind,5));
    cpr_er(l,i)=cpr_er_case(bind);
    cpr_vr_case=cell2mat(tdata(ind,7));
    cpr_vr(l,i)=cpr_vr_case(bind);
end

figure;
subplot(2,1,1);
plot(bur,cpr_er,'+-');
set(gca,'YLim',[0.8 1.8]);
xlabel('EFPH');
ylabel('CPR_{min}');
grid on;
legend(selcases);
title('ER');
subplot(2,1,2);
plot(bur,cpr_vr,'+-');
set(gca,'YLim',[0.8 1.8]);
xlabel('EFPH');
ylabel('CPR_{min}');
grid on;
legend(selcases);
title('VR');

end


%%
function select_cells(hObject,eventdata)

gdata=guidata(hObject);
gdata.sel=eventdata.Indices;
guidata(hObject,gdata);

set(findobj('Tag','PlotButton'),'Enable','on');
set(findobj('Tag','MapButton'),'Enable','on');
set(findobj('Tag','BurplotButton'),'Enable','on');

end


%%
function tdata=filter_table_data(casedata,powlimit,flowlimit)

tdata=cell(ceil(length(casedata)/2),7);

for i=1:length(casedata)   
    tdata{i,1}=casedata{i}.burnup;
    tdata{i,2}=casedata{i}.mangrp;
    if isfield(casedata{i},'rodnr')
        tdata{i,3}=casedata{i}.rodnr;
    end
    if isfield(casedata{i},'er')
        regmod='er';
        iflow=find(casedata{i}.(regmod).hcflow >= flowlimit);
        if ~isempty(iflow)
            [~,cprmin_intp]=crwea_interp(casedata{i}.(regmod).pos,...
                casedata{i}.(regmod).hcflow,casedata{i}.(regmod).cprmin,flowlimit);
            
            if isnan(cprmin_intp)
                [cprmin_intp,flowind]=min(casedata{i}.(regmod).cprmin);
                flow=casedata{i}.(regmod).hcflow(flowind);
                if flow<flowlimit
                    flow=[];
                end
            else
                flow=flowlimit;
            end
            
            %[cprmin,cprmini]=min(casedata{i}.(regmod).cprmin(iflow));
            %tdata{i,4}=round(casedata{i}.(regmod).hcflow(iflow(cprmini)));
            tdata{i,4}=round(flow);
            tdata{i,5}=cprmin_intp;
        else
            tdata{i,4}=NaN;
            tdata{i,5}=NaN;
        end
    end
    if isfield(casedata{i},'vr')
        regmod='vr';
        ipow=find(casedata{i}.(regmod).power <= powlimit);
        if ~isempty(ipow)
            [~,cprmin_intp]=crwea_interp(casedata{i}.(regmod).pos,...
                casedata{i}.(regmod).power,casedata{i}.(regmod).cprmin,powlimit);
            
            if isnan(cprmin_intp)
                [cprmin_intp,powind]=min(casedata{i}.(regmod).cprmin);
                power=casedata{i}.(regmod).power(powind);
                if power>powlimit
                    power=[];
                end
            else
                power=powlimit;
            end
            
            %[cprmin,cprmini]=min(casedata{i}.(regmod).cprmin(ipow));
            %tdata{i,6}=casedata{i}.(regmod).power(ipow(cprmini));
            tdata{i,6}=power;
            tdata{i,7}=cprmin_intp;
        else
            tdata{i,6}=NaN;
            tdata{i,7}=NaN;
        end
    end  
end

end


%% 
function [data,mminj]=get_table_data(resultfile)

load(resultfile,'res');

hwb=waitbar(0,'Reading file ...');

ci=1;

burfields=fieldnames(res);
burind=strmatch('B_',burfields);
for i=1:length(burind)
    fbur=burfields{burind(i)};
    
    burnup=res.(fbur).burnup;
    mminj=res.(fbur).mminj;
    
    % GRPS
    grpfields=fieldnames(res.(fbur));
    grpind=strmatch('G_',grpfields);
    for ii=1:length(grpind)
        fgrp=grpfields{grpind(ii)};

        mangrp=str2double(fliplr(strtok(fliplr(fgrp),'_')));
        
        grp_data=crwea_fetch_case_data(res.(fbur).(fgrp),false);
        if ~isempty(grp_data)
            grp_data.burnup=burnup;
            grp_data.mangrp=mangrp;
            
            data{ci}=grp_data;
            ci=ci+1;
        end
        
        % RODS
        rodfields=fieldnames(res.(fbur).(fgrp));
        rodind=strmatch('R_',rodfields);
        for iii=1:length(rodind)       
            frod=rodfields{rodind(iii)};
            
            rod=str2double(fliplr(strtok(fliplr(frod),'_')));
            
            rod_data=crwea_fetch_case_data(res.(fbur).(fgrp).(frod),false);
            if ~isempty(rod_data)
                rod_data.burnup=burnup;
                rod_data.mangrp=mangrp;
                rod_data.rodnr=crpos2axis(crnum2crpos(rod,mminj),0);
                
                data{ci}=rod_data;
                ci=ci+1;
            end

        end
    end
    
    waitbar(i/length(burind),hwb);
end

close(hwb);

end

