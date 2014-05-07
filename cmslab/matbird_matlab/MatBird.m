function MatBird(varargin)
%
global cs;
if (nargin < 1)
    return;
elseif (nargin==1)
    
    if (strfind(char(varargin(1)),'matb'))
        matb=1;
        cn=1;
        fid = fopen(char(varargin(1)),'r');
        TEXT = textscan(fid,'%s','delimiter','\n');
        TEXT = TEXT{1};
        fclose(fid);
        axial_zone=zeros(length(TEXT),1);
        for k=1:length(TEXT)
            icolumn=strfind(TEXT{k},'#');
            caxfile{k} = sscanf(TEXT{k}(1:icolumn-1),'%s');
            HotBirdProp.filename{k} = caxfile{k};
            axial_zone(k)=sscanf(TEXT{k}(icolumn+1:end),'%g');
        end
        for k=1:length(TEXT)
            axial_zone(k) = axial_zone(k)/axial_zone(length(TEXT));
        end
        ax_zone=zeros(length(TEXT),1);
        ax_zone(1) = axial_zone(1);
        for k=2:length(TEXT)
            ax_zone(k) = axial_zone(k)-axial_zone(k-1);
        end
        filetype=1;  
    else
        matb=0;
        cn=1;
        if (strfind(char(varargin(cn)),'cax'))
            caxfile{cn}=file('normalize',char(varargin(cn)));
            HotBirdProp.filename{cn} = caxfile{cn};
            filetype=1;
        elseif (strfind(char(varargin(cn)),'inp'))
            caifile{cn}=file('normalize',char(varargin(cn)));
            HotBirdProp.filename{cn} = caifile{cn};
            filetype=0;
        else
            return;
        end  
    end
     
else
    matb=0;
    cn=0;
    for i=1:nargin
        cn=cn+1;
        if (strfind(char(varargin(cn)),'cax'))
            caxfile{i}=file('normalize',char(varargin(i)));
            HotBirdProp.filename{i} = caxfile{i};
            filetype=1;
        elseif (strfind(char(varargin(cn)),'inp'))
            caifile{i}=file('normalize',char(varargin(i)));
            HotBirdProp.filename{i} = caifile{i};
            filetype=0;
        else
            return;
        end
    end
end



% global HotBirdProp;

if (filetype == 1)
    cnmax=length(caxfile);
    for i=1:cnmax,
        s=InitHotBirdCax(caxfile{i},i);
        HotBirdProp.cs.s(i)=s;
%         HotBirdProp.filename{i} = varargin{i};
    end
else
    cnmax=length(caifile);
    for i=1:cnmax,
        s=InitHotBirdCai(caifile{i},i);
        HotBirdProp.cs.s(i)=s;
        %         HotBirdProp.filename{i} = varargin{i};
    end
end



if(matb==1)
    for k=1:cnmax
        for i=1:cnmax
            HotBirdProp.cs.s(k).axial_zone(i)=ax_zone(i);
        end
    end
end



%% Read in all data in common class cs
cs=c_cax(HotBirdProp.cs.s);
%% Starting settings
HotBirdProp.cs=cs;
HotBirdProp.cn=1;
HotBirdProp.cs.cnmax=cnmax;
axial_change=ones(cnmax,1);
HotBirdProp.axial_change=axial_change;
HotBirdProp.axial_btf=0;
HotBirdProp.kinf_env = 0;
HotBirdProp.button = 1;
HotBirdProp.FirstEnrCall = 1;
HotBirdProp.FirstRodCall = 1;

HotBirdProp.axial_checkbox=ones(cnmax,1);
HotBirdProp.optimize.xtimes='10';
HotBirdProp.optimize.corner_rod_checkbox=0;
HotBirdProp.optimize.corner_rod='0';
HotBirdProp.optimize.plr_rod_checkbox=0;
HotBirdProp.optimize.plr_rod='0';
HotBirdProp.optimize.ba_rod_checkbox=0;
HotBirdProp.optimize.ba_rod='0';
HotBirdProp.optimize.sel_rods_checkbox=0;
% HotBirdProp.optimize.fuel_rod='0';

HotBirdProp.optimize.aut_ba_rod_checkbox=0;

HotBirdProp.optimize.max_burnup=30;
HotBirdProp.btf_target=0;
HotBirdProp.optimize.bur01='0';
HotBirdProp.optimize.bur02='5';
HotBirdProp.optimize.bur03='10';
HotBirdProp.optimize.bur04='20';
HotBirdProp.optimize.bur05='30';
HotBirdProp.optimize.btf1='0.98';
HotBirdProp.optimize.btf2='0.98';
HotBirdProp.optimize.btf3='0.98';
HotBirdProp.optimize.btf4='0.98';
HotBirdProp.optimize.btf5='0.98';
HotBirdProp.optimize.maxbtf='0.98';


HotBirdProp.optimize.bur1=cell(cnmax,1);
HotBirdProp.optimize.bur2=cell(cnmax,1);
HotBirdProp.optimize.bur3=cell(cnmax,1);
HotBirdProp.optimize.bur4=cell(cnmax,1);
HotBirdProp.optimize.bur5=cell(cnmax,1);
HotBirdProp.optimize.fint1=cell(cnmax,1);
HotBirdProp.optimize.fint2=cell(cnmax,1);
HotBirdProp.optimize.fint3=cell(cnmax,1);
HotBirdProp.optimize.fint4=cell(cnmax,1);
HotBirdProp.optimize.fint5=cell(cnmax,1);

for k=1:cnmax
    HotBirdProp.optimize.bur1{k}='0';
    HotBirdProp.optimize.bur2{k}='5';
    HotBirdProp.optimize.bur3{k}='10';
    HotBirdProp.optimize.bur4{k}='20';
    HotBirdProp.optimize.bur5{k}='30';
    HotBirdProp.optimize.fint1{k}='1.25';
    HotBirdProp.optimize.fint2{k}='1.25';
    HotBirdProp.optimize.fint3{k}='1.25';
    HotBirdProp.optimize.fint4{k}='1.25';
    HotBirdProp.optimize.fint5{k}='1.25';
end
 HotBirdProp.optimize.maxfint='1.25';
HotBirdProp.cs.crd=100;

HotBirdProp.handles.selection_textbox = 0;
%%
scrsz = get(0,'ScreenSize');
HotBirdProp.scrsz=scrsz;
dM=scrsz(3)*0.2;
sidy=scrsz(4)/1.7;
sidx=1.2*sidy;
hfig = figure('Position',[scrsz(3)-1.4*dM-sidx sidy-dM sidx sidy]);
set(hfig,'Name',HotBirdProp.filename{cn});
set(hfig,'color',[1 1 1]);
set(hfig,'menubar', 'none');
set(hfig,'numbertitle', 'off');
%%  U235 textbox
cc=sprintf('U235= %5.3f', HotBirdProp.cs.s(cn).u235);
HotBirdProp.handles.u235_textbox = annotation(hfig,'textbox',[.74 .02 .15 .04], ...
    'string',cc,'fontweight','bold','LineStyle','none');
set(HotBirdProp.handles.u235_textbox, 'FontSize', 10);
set(HotBirdProp.handles.u235_textbox, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%% Fix the legend for the enrichment levels
HotBirdProp.handles.enrlegend=axes('position',[0.77 0.10 0.12 0.7]);
HotBirdProp.clmap = colormap(jett);
set(hfig,'userdata',HotBirdProp);
paint_enr([],[],hfig);
%% Fix the control rod drawing
HotBirdProp.handles.crd1=axes('position',[0.13 0.82 0.7/1.2 0.01]);
HotBirdProp.handles.crd2=axes('position',[0.12 0.12 0.01 0.71]);
set(hfig,'userdata',HotBirdProp);
paint_crd([],[],hfig);
%% Fix the channel drawing
HotBirdProp.handles.channel=axes('position',[0.145 0.095 0.71/1.2 0.71]);
set(hfig,'userdata',HotBirdProp);
paint_channel([],[],hfig);
%% Fix the main drawing
HotBirdProp.handles.patron=axes('position',[0.15 0.10 0.7/1.2 0.7]);
set(hfig,'userdata',HotBirdProp);
paint_patron([],[],hfig);
%%  Burnup Slider
HotBirdProp.handles.burnup_slider = uicontrol(hfig,'Style','slider',...
'Max',100,'Min',0,'Value',0,...
'SliderStep',[0.01 0.1], 'units','Normalized', 'Position',[.01 .04 .10 .020], ...
'Callback', {@burnup_slider_callback,hfig});
set(HotBirdProp.handles.burnup_slider,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.burnup_slider,'value',1);
set(hfig,'userdata',HotBirdProp);
%%   ENR Pushbutton
HotBirdProp.handles.enr_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'ENR', 'FontWeight','bold', ...
'units','Normalized','position', [0.03 0.94 .07 .04], 'callback', {@paint_patron,hfig});
set(HotBirdProp.handles.enr_button,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.enr_button, 'FontSize', 11);
set(HotBirdProp.handles.enr_button, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   POW Pushbutton
HotBirdProp.handles.pow_button=uicontrol (hfig, 'style', 'pushbutton', 'string','POW', 'FontWeight','bold', ...
'units','Normalized','position', [0.11 0.94 .07 .04], 'callback', {@paint_pow,hfig});
set(HotBirdProp.handles.pow_button,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.pow_button, 'FontSize', 11);
set(HotBirdProp.handles.pow_button, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   EXP Pushbutton
HotBirdProp.handles.exp_button=uicontrol (hfig, 'style', 'pushbutton', 'string','EXP','FontWeight','bold',  ...
'units','Normalized','position', [0.19 0.94 .07 .04], 'callback', {@paint_exp,hfig});
set(HotBirdProp.handles.exp_button,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.exp_button, 'FontSize', 11);
set(HotBirdProp.handles.exp_button, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   BTF Pushbutton
HotBirdProp.handles.btf_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'BTF','FontWeight','bold', ...
'units','Normalized','position', [0.27 0.94 .07 .04], 'callback', {@paint_btf,hfig});
set(HotBirdProp.handles.btf_button,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.btf_button, 'FontSize', 11);
set(HotBirdProp.handles.btf_button, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   BTFP Pushbutton
HotBirdProp.handles.btfp_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'BTFP','FontWeight','bold', ...
'units','Normalized','position', [0.03 0.895 .07 .04], 'callback', {@paint_btfp,hfig});
set(HotBirdProp.handles.btfp_button,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.btfp_button, 'FontSize', 11);
set(HotBirdProp.handles.btfp_button, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   ROD Pushbutton
HotBirdProp.handles.rod_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'ROD','FontWeight','bold', ...
'units','Normalized','position', [0.11 0.895 .07 .04], 'callback', {@paint_rod,hfig});
set(HotBirdProp.handles.rod_button,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.rod_button, 'FontSize', 11);
set(HotBirdProp.handles.rod_button, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   POWP Pushbutton
HotBirdProp.handles.powp_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'POWP','FontWeight','bold', ...
'units','Normalized','position', [0.19 0.895 .07 .04], 'callback', {@paint_powp,hfig});
set(HotBirdProp.handles.powp_button,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.powp_button, 'FontSize', 11);
set(HotBirdProp.handles.powp_button, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   TMOL Pushbutton
HotBirdProp.handles.tmol_button=uicontrol (hfig, 'style', 'pushbutton', 'string', 'TMOL','FontWeight','bold', ...
'units','Normalized','position', [0.27 0.895 .07 .04], 'callback', {@paint_tmol,hfig});
set(HotBirdProp.handles.tmol_button,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.tmol_button, 'FontSize', 11);
set(HotBirdProp.handles.tmol_button, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   Burnup listbox
NamesSel=cell(length(HotBirdProp.cs.s(cn).burnup),1);
for i=1:length(HotBirdProp.cs.s(cn).burnup)
    NamesSel{i}=HotBirdProp.cs.s(cn).burnup(i);
end
HotBirdProp.handles.burnup_listbox=uicontrol (hfig, 'style', 'listbox', 'Max',100,'string',NamesSel, ...
    'units','Normalized','position', [0.01 0.10 .08 .70], 'callback', {@burnup_listbox_callback,hfig});
set(HotBirdProp.handles.burnup_listbox,'FontWeight', 'bold');
set(HotBirdProp.handles.burnup_listbox,'FontSize',10);
set(HotBirdProp.handles.burnup_listbox, 'FontUnits', 'normalized');
set(HotBirdProp.handles.burnup_listbox,'BackgroundColor', [1,1,0.8]);
set(hfig,'userdata',HotBirdProp);
%%   Data listbox
HotBirdProp=data_slider(HotBirdProp,1,hfig);
HotBirdProp.handles.bottom_textbox=0;
set(hfig,'userdata',HotBirdProp);
if (filetype == 1)
    HotBirdProp=burnup_slider_callback([],[],hfig);
end
set(hfig,'userdata',HotBirdProp);
%%  Plot button
HotBirdProp.handles.plot=uicontrol (hfig, 'style', 'pushbutton', 'string', 'Plot ...','FontWeight','bold', ...
'units','Normalized','position', [0.89 0.94 .095 .04], 'callback',{@paint_plott,hfig});
set(HotBirdProp.handles.plot,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.plot, 'FontSize', 11);
set(HotBirdProp.handles.plot, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   Casmo Pushbutton
HotBirdProp.handles.casmo_button=uicontrol (hfig, 'style', 'pushbutton', 'string','Casmo ...', 'FontWeight','bold', ...
'units','Normalized','position', [0.785 0.94 .095 .04], 'callback', {@paint_casmo,hfig});
set(HotBirdProp.handles.casmo_button, 'FontSize', 11);
set(HotBirdProp.handles.casmo_button, 'FontUnits', 'normalized');
set(HotBirdProp.handles.casmo_button,'BackgroundColor', [0.97,0.97,0.97]);
HotBirdProp.casmo_text_fig = 0;
set(hfig,'userdata',HotBirdProp);
%%   AXIAL Pushbutton
HotBirdProp.handles.axial_button=uicontrol (hfig, 'style', 'pushbutton', 'string','Axial ...', 'FontWeight','bold', ...
'units','Normalized','position', [0.68 0.94 .095 .04], 'callback', {@paint_axial,hfig});
set(HotBirdProp.handles.axial_button, 'FontSize', 11);
set(HotBirdProp.handles.axial_button, 'FontUnits', 'normalized');
set(HotBirdProp.handles.axial_button,'BackgroundColor', [0.97,0.97,0.97]);
set(hfig,'userdata',HotBirdProp);
%%   Data Pushbutton
HotBirdProp.handles.axial_button=uicontrol (hfig, 'style', 'pushbutton', 'string','Data ...', 'FontWeight','bold', ...
'units','Normalized','position', [0.89 0.895 .095 .04], 'callback', {@paint_data,hfig});
set(HotBirdProp.handles.axial_button, 'FontSize', 11);
set(HotBirdProp.handles.axial_button, 'FontUnits', 'normalized');
set(HotBirdProp.handles.axial_button,'BackgroundColor', [0.97,0.97,0.97]);
set(hfig,'userdata',HotBirdProp);
%%   Bowing Pushbutton
HotBirdProp.handles.axial_button=uicontrol (hfig, 'style', 'pushbutton', 'string','Bowing ...', 'FontWeight','bold', ...
'units','Normalized','position', [0.785 0.895 .095 .04], 'callback', {@paint_bowing,hfig});
set(HotBirdProp.handles.axial_button, 'FontSize', 11);
set(HotBirdProp.handles.axial_button, 'FontUnits', 'normalized');
set(HotBirdProp.handles.axial_button,'BackgroundColor', [0.97,0.97,0.97]);
set(hfig,'userdata',HotBirdProp);
%%   Optimize Pushbutton
HotBirdProp.handles.optimize_button=uicontrol (hfig, 'style', 'pushbutton', 'string','Optimize ...', 'FontWeight','bold', ...
'units','Normalized','position', [0.55 0.94 .12 .04], 'callback', {@paint_optimize,hfig});
set(HotBirdProp.handles.optimize_button, 'FontSize', 11);
set(HotBirdProp.handles.optimize_button, 'FontUnits', 'normalized');
set(HotBirdProp.handles.optimize_button,'BackgroundColor', [0.97,0.97,0.97]);
set(hfig,'userdata',HotBirdProp);
%%  Burnup textbox
HotBirdProp.handles.burnup_textbox = annotation(hfig,'textbox',[.01 .71 .10 .04], ...
'string','Burnup','fontweight','bold','LineStyle','none');
set(HotBirdProp.handles.burnup_textbox, 'FontSize', 10);
set(HotBirdProp.handles.burnup_textbox, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%  Case number textbox
cc=sprintf('Case Number %d',1);
HotBirdProp.handles.cn_textbox = annotation(hfig,'textbox',[.86 .05 .15 .04], ...
'string',cc,'fontweight','bold','LineStyle','none');
set(HotBirdProp.handles.cn_textbox, 'FontSize', 10);
set(HotBirdProp.handles.cn_textbox, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%  Case number Slider
HotBirdProp.handles.cn_slider = uicontrol(hfig,'Style','slider','Max',10,'Min',1,'Value',0, ...
'SliderStep',[0.1 0.1], 'units','Normalized', 'Position',[.87 .03 .10 .02], ...
'Callback', {@cn_slider_callback,hfig});
set(HotBirdProp.handles.cn_slider,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.cn_slider,'value',1);
set(hfig,'userdata',HotBirdProp);
%%   Bundle BTF checkbox
HotBirdProp.handles.axial_btf_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
    'position',[0.03  0.85 0.13 0.035] ,'string','Bundle BTF', 'FontWeight','bold', ...
    'callback',{@axial_btf_callback,hfig});
set(HotBirdProp.handles.axial_btf_checkbox, 'FontSize', 11);
set(HotBirdProp.handles.axial_btf_checkbox, 'FontUnits', 'normalized');
set(HotBirdProp.handles.axial_btf_checkbox,'BackgroundColor', [0.97,0.97,0.97]);
% set(HotBirdProp.handles.axial_btf_checkbox,'BackgroundColor', [1,1,1]);
set(HotBirdProp.handles.axial_btf_checkbox,'value',0);
HotBirdProp.axial_btf = 0;
set(hfig,'userdata',HotBirdProp);
%%   f(kinf) checkbox
HotBirdProp.handles.env_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
    'position',[0.17  0.85 .09 .035] ,'string',' f(kinf)', 'FontWeight','bold', ...
    'callback',{@kinf_env_callback,hfig});
set(HotBirdProp.handles.env_checkbox, 'FontSize', 11);
set(HotBirdProp.handles.env_checkbox, 'FontUnits', 'normalized');
set(HotBirdProp.handles.env_checkbox,'BackgroundColor', [1,1,1]);
set(HotBirdProp.handles.env_checkbox,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.env_checkbox,'value',0);
set(hfig,'userdata',HotBirdProp);
%%   CRD checkbox
HotBirdProp.handles.crd_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
    'position',[0.27  0.85 .07 .035] ,'string',' CRD', 'FontWeight','bold', ...
    'callback',{@crd_callback,hfig});
set(HotBirdProp.handles.crd_checkbox, 'FontSize', 11);
set(HotBirdProp.handles.crd_checkbox, 'FontUnits', 'normalized');
set(HotBirdProp.handles.crd_checkbox,'BackgroundColor', [1,1,1]);
set(HotBirdProp.handles.crd_checkbox,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.crd_checkbox,'value',0);
set(hfig,'userdata',HotBirdProp);

% HotBirdProp.handles.crd =uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
%     'HorizontalAlignment','center','position', [0.35 0.85 0.05 0.035]  , ...
%     'string',HotBirdProp.crd,'callback',{@calc_tmol_limit,hfig});
% set(HotBirdProp.handles.crd,'FontSize',11);
% set(HotBirdProp.handles.crd,'FontUnits', 'normalized');
% set(HotBirdProp.handles.crd,'BackgroundColor', [0.99,0.99,0.99]);

%%   Pertubation calc Pushbutton
HotBirdProp.handles.axial_button=uicontrol (hfig, 'style', 'pushbutton', 'string','Pertubation', 'FontWeight','bold', ...
    'units','Normalized','position', [0.55 0.895 .12 .04], 'callback', {@pert_calc,hfig});
set(HotBirdProp.handles.axial_button,'BackgroundColor', [0.97,0.97,0.97]);
set(HotBirdProp.handles.axial_button, 'FontSize', 11);
set(HotBirdProp.handles.axial_button, 'FontUnits', 'normalized');
set(hfig,'userdata',HotBirdProp);
%%   Increase  Enr button
HotBirdProp.handles.increase_button=uicontrol (hfig, 'style', 'pushbutton', 'string','increase enr', 'FontWeight','bold', ...
    'units','Normalized','position', [0.41 0.895 .13 .04], 'callback', {@inenr,hfig});
set(HotBirdProp.handles.increase_button, 'FontSize', 11);
set(HotBirdProp.handles.increase_button, 'FontUnits', 'normalized');
set(HotBirdProp.handles.increase_button,'BackgroundColor', [1,1,1]);
set(HotBirdProp.handles.increase_button,'BackgroundColor', [0.97,0.97,0.97])
set(hfig,'userdata',HotBirdProp);
%%   Decrease Enr Pushbutton
HotBirdProp.handles.decrease_button=uicontrol (hfig, 'style', 'pushbutton', 'string','decrease enr', 'FontWeight','bold', ...
'units','Normalized','position', [0.41 0.94 .13 .04], 'callback', {@deenr,hfig});
set(HotBirdProp.handles.decrease_button, 'FontSize', 11);
set(HotBirdProp.handles.decrease_button, 'FontUnits', 'normalized');
set(HotBirdProp.handles.decrease_button,'BackgroundColor', [1,1,1]);
set(HotBirdProp.handles.decrease_button,'BackgroundColor', [0.97,0.97,0.97]);
set(hfig,'userdata',HotBirdProp);
%%
cs.calc_rod();

% java_calcbtfax();
HotBirdProp.cs.calc_u235();
HotBirdProp.u235_target=HotBirdProp.cs.u235;
% HotBirdProp.u235_target = calc_u235([],[],hfig);
set(hfig,'userdata',HotBirdProp);
end
%%

function [s]=InitHotBirdCax(caxfile,cn)
s=cax(cn);
s.readcaifile(caxfile);
s.readcaxfile(caxfile);
s.init;
s.gettype;
s.bigcalc;
s.calcbtf;
s.calc_u235;
end


function [s]=InitHotBirdCai(caifile,cn)

s=cax(cn);
s.readcaifile(caifile);
s.gettype();
s.update_enr_ba();
s.calc_u235();
end


function pert_calc(src,~,hfig)
HotBirdProp=get(hfig,'userdata');

for k=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(k).bigcalc();
end
calc_powp([],[],hfig);

if (HotBirdProp.button==2)
   paint_pow([],[],hfig); 
elseif (HotBirdProp.button==3)
    paint_exp([],[],hfig);
elseif (HotBirdProp.button==4)
    paint_btf([],[],hfig);
elseif (HotBirdProp.button==7)
    paint_powp([],[],hfig);      
end


set(hfig,'userdata',HotBirdProp);
end


function inenr(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
HotBirdProp.cs.increase_u235();
u235=calc_u235([],[],hfig);
paint_patron([],[],hfig);
set(hfig,'userdata',HotBirdProp);
end


function deenr(~,~,hfig,imax,jmax)

HotBirdProp=get(hfig,'userdata');
if (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
    [imax,jmax]=calc_btf([],[],hfig);
    decrease_u235([],[],hfig,imax,jmax);
    u235=calc_u235([],[],hfig);
    paint_btf([],[],hfig);
end
set(hfig,'userdata',HotBirdProp);
end



function decrease_u235(~,~,hfig,imax,jmax)

HotBirdProp=get(hfig,'userdata');
HotBirdProp.cs.decrease_u235(imax,jmax);
set(hfig,'userdata',HotBirdProp);
end


function [u235]=calc_u235(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

cn = HotBirdProp.cn;

if (HotBirdProp.axial_btf == 1)
    HotBirdProp.cs.calc_u235();
    u235=HotBirdProp.cs.u235;
    cc=sprintf('<U235>=%5.3f', u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);
else
    HotBirdProp.cs.s(cn).calc_u235;
    u235=HotBirdProp.cs.s(cn).u235;
    cc=sprintf('U235= %5.3f', u235);
    set(HotBirdProp.handles.u235_textbox,'string',cc);
end
set(hfig,'userdata',HotBirdProp);

end



function [imax,jmax]=calc_btf(~,~,hfig)
HotBirdProp=get(hfig,'userdata');

if (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
    [imax,jmax]=HotBirdProp.cs.calc_btfax_env();
end

set(hfig,'userdata',HotBirdProp);

end



function crd_callback(~,~,hfig)
HotBirdProp=get(hfig,'userdata');


if(HotBirdProp.button==2)
    paint_pow([],[],hfig);
elseif(HotBirdProp.button==4)
    paint_btf([],[],hfig);
end


end

