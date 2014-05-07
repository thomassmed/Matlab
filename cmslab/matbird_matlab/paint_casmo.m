function paint_casmo(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

scrsz=HotBirdProp.scrsz;
sidy=scrsz(4)/3;
sidx=1.25*sidy;
hfig3=figure('position',[scrsz(4)/1.0 scrsz(3)/12 sidx sidy]);
set(hfig3,'Name','StartCasmo');
set(hfig3,'color',[.99 .99 .99]);
set(hfig3,'Menubar','none');
set(hfig3,'numbertitle','off');
set(hfig3,'userdata',HotBirdProp);
cn=HotBirdProp.cn;

%% Case number
ce = sprintf('case nr %d',round(get(HotBirdProp.handles.cn_slider,'value')));
HotBirdProp.handles.casmo_text_cn=annotation(hfig3,'textbox',[0.03 0.02 0.19 0.06], ...
    'string',ce,'fontweight','bold','LineStyle','none');
set(HotBirdProp.handles.casmo_text_cn,'LineStyle','none');
set(HotBirdProp.handles.casmo_text_cn,'FontWeight','bold');
set(HotBirdProp.handles.casmo_text_cn,'FontSize',11);
set(HotBirdProp.handles.casmo_text_cn, 'FontUnits', 'normalized');
set(HotBirdProp.handles.casmo_text_cn,'BackgroundColor', [0.99,0.99,0.99]);
set(hfig,'userdata',HotBirdProp);
%% Casmo cax file
HotBirdProp.handles.casmo_caxtext=annotation(hfig3,'textbox',[0.02 0.90 0.13 0.06], ...
    'String','cax file','HorizontalAlignment','left');
set(HotBirdProp.handles.casmo_caxtext,'LineStyle','none');
set(HotBirdProp.handles.casmo_caxtext,'FontWeight','bold');
set(HotBirdProp.handles.casmo_caxtext,'FontSize',11);
set(HotBirdProp.handles.casmo_caxtext, 'FontUnits', 'normalized');
set(HotBirdProp.handles.casmo_caxtext','BackgroundColor', [0.99,0.99,0.99]);

ce = sprintf('%s',HotBirdProp.cs.s(cn).caxfile);
HotBirdProp.handles.casmo_caxfile=uicontrol('Style','edit','Units','Normalized',...
    'HorizontalAlignment','left','position', [0.17 0.90 0.82 0.06]  , ...
    'string',ce,'callback',{@change_caxfile,hfig3});
set(HotBirdProp.handles.casmo_caxfile,'FontWeight','bold');
set(HotBirdProp.handles.casmo_caxfile,'FontSize',10);
set(HotBirdProp.handles.casmo_caxfile, 'FontUnits', 'normalized');
set(HotBirdProp.handles.casmo_caxfile','BackgroundColor', [0.99,0.99,0.99]);
set(hfig,'userdata',HotBirdProp);
%% Casmo inp file
HotBirdProp.handles.casmo_inptext=annotation(hfig3,'textbox',[0.02 0.82 0.13 0.06], ...
    'String','inp file','HorizontalAlignment','left');
set(HotBirdProp.handles.casmo_inptext,'LineStyle','none');
set(HotBirdProp.handles.casmo_inptext,'FontWeight','bold');
set(HotBirdProp.handles.casmo_inptext,'FontSize',11);
set(HotBirdProp.handles.casmo_inptext, 'FontUnits', 'normalized');
set(HotBirdProp.handles.casmo_inptext','BackgroundColor', [0.99,0.99,0.99]);

ce = sprintf('%s',HotBirdProp.cs.s(cn).caifile);
HotBirdProp.handles.casmo_inpfile=uicontrol('Style','edit','Units','Normalized',...
    'HorizontalAlignment','left','position', [0.17 0.82 0.82 0.06]  , ...
    'string',ce,'callback',{@change_caifile,hfig3});
set(HotBirdProp.handles.casmo_inpfile,'FontWeight','bold');
set(HotBirdProp.handles.casmo_inpfile,'FontSize',10);
set(HotBirdProp.handles.casmo_inpfile, 'FontUnits', 'normalized');
set(HotBirdProp.handles.casmo_inpfile','BackgroundColor', [0.99,0.99,0.99]);
set(hfig,'userdata',HotBirdProp);
%% Start Casmo button
HotBirdProp.handles.start_casmo = uicontrol (hfig3, 'style', 'pushbutton', 'string', 'Start Casmo',...
'units','Normalized','position', [0.03 0.10 .20 .07], 'callback', {@start_casmo,hfig});
set(HotBirdProp.handles.start_casmo,'FontWeight','bold');
set(HotBirdProp.handles.start_casmo,'FontSize',10);
set(HotBirdProp.handles.start_casmo, 'FontUnits', 'normalized');
set(HotBirdProp.handles.start_casmo','BackgroundColor', [0.96,0.96,0.96]);

%%  Write cai file button
HotBirdProp.handles.caifile=uicontrol (hfig3,'style', 'pushbutton', 'string','Write cai file','FontWeight','bold', ...
'units','Normalized','position', [0.24 0.10 0.20 0.07], 'callback',{@writecaifile,hfig});
set(HotBirdProp.handles.caifile,'FontWeight','bold');
set(HotBirdProp.handles.caifile,'FontSize',10);
set(HotBirdProp.handles.caifile, 'FontUnits', 'normalized');
set(HotBirdProp.handles.caifile','BackgroundColor', [0.96,0.96,0.96]);

%%  Read cax file button
HotBirdProp.handles.caxfile=uicontrol (hfig3,'style', 'pushbutton', 'string','Read cax file','FontWeight','bold', ...
'units','Normalized','position', [0.45 0.10 0.20 0.07], 'callback',{@read_cax_file,hfig});
set(HotBirdProp.handles.caxfile,'FontWeight','bold');
set(HotBirdProp.handles.caxfile,'FontSize',10);
set(HotBirdProp.handles.caxfile, 'FontUnits', 'normalized');
set(HotBirdProp.handles.caxfile','BackgroundColor', [0.96,0.96,0.96]);

%%  Read all cax files button
HotBirdProp.handles.allcaxfile=uicontrol (hfig3,'style', 'pushbutton', 'string','Read all cax files','FontWeight','bold', ...
'units','Normalized','position', [0.66 0.10 0.25 0.07], 'callback',{@read_all_cax_file,hfig});
set(HotBirdProp.handles.allcaxfile,'FontWeight','bold');
set(HotBirdProp.handles.allcaxfile,'FontSize',10);
set(HotBirdProp.handles.allcaxfile, 'FontUnits', 'normalized');
set(HotBirdProp.handles.allcaxfile','BackgroundColor', [0.96,0.96,0.96]);
%% DEP checkbox
% HotBirdProp.handles.dep_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
%     'position',[0.30  0.02 .20 .07] ,'string','const DEP', 'FontWeight','bold', ...
%     'callback',{@change_dep_checkbox,hfig});
% set(HotBirdProp.handles.dep_checkbox,'value',0);
% HotBirdProp.dep_checbox=1;
% set(HotBirdProp.handles.dep_checkbox,'FontSize',11);
% set(HotBirdProp.handles.dep_checkbox, 'FontUnits', 'normalized');
% set(HotBirdProp.handles.dep_checkbox','BackgroundColor', [0.99,0.99,0.99]);

%%
HotBirdProp.casmo_text_fig = 1;
set(hfig,'userdata',HotBirdProp);
set(hfig3,'userdata',HotBirdProp);

end

function change_caifile(src,~,hfig3)

HotBirdProp=get(hfig3,'userdata');
HotBirdProp.cn=round(get(HotBirdProp.handles.cn_slider,'value'));
file=get(src,'string');
HotBirdProp.cs.s(HotBirdProp.cn).caifile=strcat(file);

HotBirdProp.cs.s(HotBirdProp.cn).caxfile=strrep(file,'inp','cax');
ce = sprintf('%s', HotBirdProp.cs.s(HotBirdProp.cn).caxfile);
set(HotBirdProp.handles.casmo_caxfile,'string',ce);

set(hfig3,'userdata',HotBirdProp);

end

function change_caxfile(src,~,hfig3)

HotBirdProp=get(hfig3,'userdata');
HotBirdProp.cn=round(get(HotBirdProp.handles.cn_slider,'value'));
file=get(src,'string');
HotBirdProp.cs.s(HotBirdProp.cn).caxfile=strcat(file);

HotBirdProp.cs.s(HotBirdProp.cn).caifile=strrep(file,'cax','inp');
ce = sprintf('%s', HotBirdProp.cs.s(HotBirdProp.cn).caifile);
set(HotBirdProp.handles.casmo_inpfile,'string',ce);

set(hfig3,'userdata',HotBirdProp);

end



function start_casmo(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

caifile = sprintf('%s',HotBirdProp.cs.s(HotBirdProp.cn).caifile);
[pathstr, name, ~] = fileparts(caifile);

if(~ispc)
    startfile=sprintf('%s%s',pathstr,'/start_casmo');
    logfile=sprintf('%s/%s.log',pathstr,name);
    outfile=sprintf('%s/%s.out',pathstr,name);
    fid = fopen(startfile,'w');
    
    fprintf(fid,'#!/bin/bash\n');
    fprintf(fid,'cd %s\n',pathstr);
    fprintf(fid,'rm %s\n',logfile);
    fprintf(fid,'rm %s\n',outfile);
    fprintf(fid,'cas4 %s',caifile);
    fclose(fid);
    start_cmd=strcat(startfile,'&');
    system(start_cmd);
else
    caifile=strrep(caifile,'\', '/');
    pathstr=strrep(pathstr,'\', '/');
    startfile=sprintf('%s%s',pathstr,'/start_casmo');
    fid = fopen(startfile,'w');
    fprintf(fid,'cd %s\n',pathstr);
    fprintf(fid,'cas4 -k %s',caifile);
    fclose(fid);
    start_cmd=sprintf('ksh %s',startfile);
    system(start_cmd);
end

set(hfig,'userdata',HotBirdProp);

end

function read_cax_file(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
caxfile=HotBirdProp.cs.s(HotBirdProp.cn).caxfile;

HotBirdProp.cs.s(HotBirdProp.cn).readcaifile(caxfile);
HotBirdProp.cs.s(HotBirdProp.cn).readcaxfile(caxfile);
HotBirdProp.cs.s(HotBirdProp.cn).init;
HotBirdProp.cs.s(HotBirdProp.cn).gettype;
HotBirdProp.cs.s(HotBirdProp.cn).bigcalc;
HotBirdProp.cs.s(HotBirdProp.cn).calcbtf;
HotBirdProp.cs.s(HotBirdProp.cn).calc_u235;

cn=HotBirdProp.cn;
NamesSel=cell(length(HotBirdProp.cs.s(cn).burnup),1);
for i=1:length(HotBirdProp.cs.s(cn).burnup)
    NamesSel{i}= HotBirdProp.cs.s(cn).burnup(i);
end
set(HotBirdProp.handles.burnup_listbox,'string',NamesSel);

set(hfig,'userdata',HotBirdProp);

end


function read_all_cax_file(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

for k=1:HotBirdProp.cs.cnmax
    caxfile=HotBirdProp.cs.s(k).caxfile;
    HotBirdProp.cs.s(k).readcaifile(caxfile);
    HotBirdProp.cs.s(k).readcaxfile(caxfile);
    HotBirdProp.cs.s(k).init;
    HotBirdProp.cs.s(k).gettype;
    HotBirdProp.cs.s(k).bigcalc;
    HotBirdProp.cs.s(k).calcbtf;
    HotBirdProp.cs.s(k).calc_u235;
end

cn=HotBirdProp.cn;
NamesSel=cell(length(HotBirdProp.cs.s(cn).burnup),1);
for i=1:length(HotBirdProp.cs.s(cn).burnup)
    NamesSel{i}= HotBirdProp.cs.s(cn).burnup(i);
end
set(HotBirdProp.handles.burnup_listbox,'string',NamesSel);

set(hfig,'userdata',HotBirdProp);

end



% function change_dep_checkbox(src,~,hfig)
% 
% HotBirdProp=get(hfig,'userdata');
% 
% value=get(src,'value');
% HotBirdProp.dep_checbox = value;
% 
% set(hfig,'userdata',HotBirdProp);
% 
% end

function writecaifile(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;

if(isempty(HotBirdProp.cs.s(cn).caifile))
    HotBirdProp.cs.s(cn).caifile=strrep(HotBirdProp.cs.s(cn).caxfile,'cax','inp');
end

% if (HotBirdProp.dep_checbox == 1)
%     option = 1;
% else
%     option = 0;
% end

% HotBirdProp.cs.s(cn).writecaifile(HotBirdProp.cs.s(cn).caifile,option);
HotBirdProp.cs.s(cn).writecaifile(HotBirdProp.cs.s(cn).caifile);

if (HotBirdProp.casmo_text_fig == 1 && HotBirdProp.cn <= HotBirdProp.cs.cnmax);
    ce = sprintf('%s', HotBirdProp.cs.s(HotBirdProp.cn).caifile);
    set(HotBirdProp.handles.casmo_inpfile,'string',ce);
end

set(hfig,'userdata',HotBirdProp);
end





