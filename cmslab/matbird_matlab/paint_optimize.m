function paint_optimize(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

if(isfield(HotBirdProp.handles,'opt_option_text1') && ishandle(HotBirdProp.handles.opt_option_text1))
    
    
else
    
    scrsz=HotBirdProp.scrsz;
    sidx=scrsz(4)/1.8;
    sidy=0.6*sidx;
    hfig3=figure('position',[scrsz(4)/1.0 scrsz(3)/12 sidx sidy]);
    set(hfig3,'Name','Automatic optimizing');
    set(hfig3,'color',[.99 .99 .99]);
    set(hfig3,'Menubar','none');
    set(hfig3,'numbertitle','off');
    set(hfig3,'userdata',HotBirdProp);
    
%     HotBirdProp.u235_target = calc_u235([],[],hfig);
    
    %  Optimizing type text
    HotBirdProp.handles.opt_option_text1=annotation(hfig3,'textbox',[0.02 0.90 0.22 0.07], ...
        'String','Start Optimize','HorizontalAlignment','left');
    set(HotBirdProp.handles.opt_option_text1,'LineStyle','none');
    set(HotBirdProp.handles.opt_option_text1,'FontWeight','bold');
    set(HotBirdProp.handles.opt_option_text1,'FontSize',11);
    set(HotBirdProp.handles.opt_option_text1,'FontUnits', 'normalized');
    % set(HotBirdProp.handles.opt_option_text1,'BackgroundColor', [0.57,0.97,0.97]);
    
    %% Bundle Optimize button
    HotBirdProp.handles.radial_optimizing1 = uicontrol (hfig3, 'style', 'pushbutton', 'string', 'Bundle ', ...
        'units','Normalized','position', [0.02 0.80 .19 .08], 'callback', {@radial_optimizing_bundle,hfig});
    set(HotBirdProp.handles.radial_optimizing1,'FontWeight','bold');
    set(HotBirdProp.handles.radial_optimizing1,'FontSize',11);
    set(HotBirdProp.handles.radial_optimizing1,'FontUnits', 'normalized');
    set(HotBirdProp.handles.radial_optimizing1,'BackgroundColor', [0.96,0.96,0.96]);
    
    %% Bundle Optimize x times button
    HotBirdProp.handles.radial_optimizingx = uicontrol (hfig3, 'style', 'pushbutton', 'string', 'Bundle x times', ...
        'units','Normalized','position', [0.02 0.71 .19 .08], 'callback', {@radial_optimizing5,hfig});
    set(HotBirdProp.handles.radial_optimizingx,'FontWeight','bold');
    set(HotBirdProp.handles.radial_optimizingx,'FontSize',11);
    set(HotBirdProp.handles.radial_optimizingx,'FontUnits', 'normalized');
    set(HotBirdProp.handles.radial_optimizingx,'BackgroundColor', [0.96,0.96,0.96]);
    %%  Bundle times x text
    HotBirdProp.handles.bundle_xtimes_text=annotation(hfig3,'textbox',[0.03 0.635 0.065 0.06], ...
        'String','x =','HorizontalAlignment','left');
    set(HotBirdProp.handles.bundle_xtimes_text,'LineStyle','none');
    set(HotBirdProp.handles.bundle_xtimes_text,'FontWeight','bold');
    set(HotBirdProp.handles.bundle_xtimes_text,'FontSize',11);
    set(HotBirdProp.handles.bundle_xtimes_text,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bundle_xtimes_text,'BackgroundColor', [0.99,0.99,0.99]);
    
    HotBirdProp.handles.bundle_xtimes =uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.10 0.635 .05 .06]  , ...
        'string',HotBirdProp.optimize.xtimes,'callback',{@set_max_burnup,hfig});
    set(HotBirdProp.handles.bundle_xtimes,'FontSize',11);
    set(HotBirdProp.handles.bundle_xtimes,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bundle_xtimes,'BackgroundColor', [0.99,0.99,0.99]);
    
    %% u235 pellet enrichment button
    HotBirdProp.handles.enr_optimizing = uicontrol (hfig3, 'style', 'pushbutton', 'string', 'U235 ones', ...
        'units','Normalized','position', [0.02 0.53 .19 .08], 'callback', {@enr_optimizing,hfig});
    set(HotBirdProp.handles.enr_optimizing,'FontWeight','bold');
    set(HotBirdProp.handles.enr_optimizing,'FontSize',11);
    set(HotBirdProp.handles.enr_optimizing,'FontUnits', 'normalized');
    set(HotBirdProp.handles.enr_optimizing,'BackgroundColor', [0.96,0.96,0.96]);
    
    %% 17 radial 3 u235 enrichment button
    HotBirdProp.handles.both_optimizing = uicontrol (hfig3, 'style', 'pushbutton', 'string', 'Radial + U235', ...
        'units','Normalized','position', [0.02 0.44 .19 .08], 'callback', {@both_optimizing,hfig});
    set(HotBirdProp.handles.both_optimizing,'FontWeight','bold');
    set(HotBirdProp.handles.both_optimizing,'FontSize',11);
    set(HotBirdProp.handles.both_optimizing,'FontUnits', 'normalized');
    set(HotBirdProp.handles.both_optimizing,'BackgroundColor', [0.96,0.96,0.96]);
    
    %% BTFP reset button
    HotBirdProp.handles.reset_btfp_optimizing = uicontrol (hfig3, 'style', 'pushbutton', 'string', 'Reset BTFP', ...
        'units','Normalized','position', [0.02 0.35 .19 .08], 'callback', {@reset_btfp,hfig});
    set(HotBirdProp.handles.reset_btfp_optimizing,'FontWeight','bold');
    set(HotBirdProp.handles.reset_btfp_optimizing,'FontSize',11);
    set(HotBirdProp.handles.reset_btfp_optimizing,'FontUnits', 'normalized');
    set(HotBirdProp.handles.reset_btfp_optimizing,'BackgroundColor', [0.96,0.96,0.96]);
    
    %% TMOL reset button
    HotBirdProp.handles.reset_tmol_optimizing = uicontrol (hfig3, 'style', 'pushbutton', 'string', 'Reset TMOL', 'FontWeight','bold', ...
        'units','Normalized','position', [0.02 0.26 .19 .08], 'callback', {@reset_powp,hfig});
    set(HotBirdProp.handles.reset_tmol_optimizing,'FontWeight','bold');
    set(HotBirdProp.handles.reset_tmol_optimizing,'FontSize',11);
    set(HotBirdProp.handles.reset_tmol_optimizing,'FontUnits', 'normalized');
    set(HotBirdProp.handles.reset_tmol_optimizing,'BackgroundColor', [0.96,0.96,0.96]);
    
    %%  TMOL margin text
    HotBirdProp.handles.opt_option_text2=annotation(hfig3,'textbox',[0.25 0.90 0.22 0.07], ...
        'String','TMOL margin %','HorizontalAlignment','left');
    set(HotBirdProp.handles.opt_option_text2,'LineStyle','none');
    set(HotBirdProp.handles.opt_option_text2,'FontWeight','bold');
    set(HotBirdProp.handles.opt_option_text2,'FontSize',11);
    set(HotBirdProp.handles.opt_option_text2,'FontUnits', 'normalized');
    set(HotBirdProp.handles.opt_option_text2,'BackgroundColor', [0.99,0.99,0.99]);
    
    %%  corner rod checkbox
    HotBirdProp.handles.corner_rod_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
        'position',[0.25  0.80 0.12 0.06] ,'string',' Corner', 'FontWeight','bold', ...
        'callback',{@calc_tmol_limit,hfig});
    set(HotBirdProp.handles.corner_rod_checkbox,'value',HotBirdProp.optimize.corner_rod_checkbox);
    set(HotBirdProp.handles.corner_rod_checkbox,'FontSize',11);
    set(HotBirdProp.handles.corner_rod_checkbox,'FontUnits', 'normalized');
    set(HotBirdProp.handles.corner_rod_checkbox,'BackgroundColor', [0.99,0.99,0.99]);
    
    ce = sprintf('%4.0f',0);
    HotBirdProp.handles.corner_rod =uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.38 0.80 0.05 0.06]  , ...
        'string',HotBirdProp.optimize.corner_rod,'callback',{@calc_tmol_limit,hfig});
    set(HotBirdProp.handles.corner_rod,'FontSize',11);
    set(HotBirdProp.handles.corner_rod,'FontUnits', 'normalized');
    set(HotBirdProp.handles.corner_rod,'BackgroundColor', [0.99,0.99,0.99]);
    
    %%  plr rod checkbox
    HotBirdProp.handles.plr_rod_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
        'position',[0.25  0.71 0.12 0.06] ,'string',' PLR', 'FontWeight','bold', ...
        'callback',{@calc_tmol_limit,hfig});
    set(HotBirdProp.handles.plr_rod_checkbox,'value',HotBirdProp.optimize.plr_rod_checkbox);
    set(HotBirdProp.handles.plr_rod_checkbox,'FontSize',11);
    set(HotBirdProp.handles.plr_rod_checkbox,'FontUnits', 'normalized');
    set(HotBirdProp.handles.plr_rod_checkbox,'BackgroundColor', [0.99,0.99,0.99]);
    
    ce = sprintf('%4.0f',0);
    HotBirdProp.handles.plr_rod =uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.38 0.71 0.05 0.06]  , ...
        'string',HotBirdProp.optimize.plr_rod,'callback',{@calc_tmol_limit,hfig});
    set(HotBirdProp.handles.plr_rod,'FontSize',11);
    set(HotBirdProp.handles.plr_rod,'FontUnits', 'normalized');
    set(HotBirdProp.handles.plr_rod,'BackgroundColor', [0.99,0.99,0.99]);
    
    
    %%  BA rod checkbox
    HotBirdProp.handles.ba_rod_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
        'position',[0.25  0.62 0.12 0.06] ,'string',' BA', 'FontWeight','bold', ...
        'callback',{@calc_tmol_limit,hfig});
    set(HotBirdProp.handles.ba_rod_checkbox,'value',HotBirdProp.optimize.ba_rod_checkbox);
    set(HotBirdProp.handles.ba_rod_checkbox,'FontSize',11);
    set(HotBirdProp.handles.ba_rod_checkbox,'FontUnits', 'normalized');
    set(HotBirdProp.handles.ba_rod_checkbox,'BackgroundColor', [0.99,0.99,0.99]);
    
    ce = sprintf('%4.0f',0);
    HotBirdProp.handles.ba_rod =uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.38 0.62 0.05 0.06]  , ...
        'string',HotBirdProp.optimize.ba_rod,'callback',{@calc_tmol_limit,hfig});
    set(HotBirdProp.handles.ba_rod,'FontSize',11);
    set(HotBirdProp.handles.ba_rod,'FontUnits', 'normalized');
    set(HotBirdProp.handles.ba_rod,'BackgroundColor', [0.99,0.99,0.99]);
     %%  Selected ROD checkbox
    HotBirdProp.handles.sel_rods_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
        'position',[0.25  0.53 0.25 0.06] ,'string',' Selected Rods', 'FontWeight','bold', ...
        'callback',{@calc_tmol_limit,hfig});
    set(HotBirdProp.handles.sel_rods_checkbox,'value',HotBirdProp.optimize.sel_rods_checkbox);
    set(HotBirdProp.handles.sel_rods_checkbox,'FontSize',11);
    set(HotBirdProp.handles.sel_rods_checkbox,'FontUnits', 'normalized');
    set(HotBirdProp.handles.sel_rods_checkbox,'BackgroundColor', [0.99,0.99,0.99]);
    
%     ce = sprintf('%4.0f',0);
%     HotBirdProp.handles.fuel_rod =uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
%         'HorizontalAlignment','center','position', [0.38 0.53 0.05 0.06]  , ...
%         'string',HotBirdProp.optimize.fuel_rod,'callback',{@calc_tmol_limit,hfig});
%     set(HotBirdProp.handles.fuel_rod,'FontSize',11);
%     set(HotBirdProp.handles.fuel_rod,'FontUnits', 'normalized');
%     set(HotBirdProp.handles.fuel_rod,'BackgroundColor', [0.99,0.99,0.99]);   
    
    %%  Auto BA rod checkbox
    HotBirdProp.handles.aut_ba_rod_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
        'position',[0.25  0.44 0.25 0.06] ,'string',' Aut U235 (BA-rod)', 'FontWeight','bold', ...
        'callback',{@calc_tmol_limit,hfig});
    set(HotBirdProp.handles.aut_ba_rod_checkbox,'value',HotBirdProp.optimize.aut_ba_rod_checkbox);
    set(HotBirdProp.handles.aut_ba_rod_checkbox,'FontSize',11);
    set(HotBirdProp.handles.aut_ba_rod_checkbox,'FontUnits', 'normalized');
    set(HotBirdProp.handles.aut_ba_rod_checkbox,'BackgroundColor', [0.99,0.99,0.99]);
    
    %%  U235 target text
    HotBirdProp.handles.u235_target_text=annotation(hfig3,'textbox',[0.25 0.25 0.15 0.07], ...
        'String','U235 target','HorizontalAlignment','left');
    set(HotBirdProp.handles.u235_target_text,'LineStyle','none');
    set(HotBirdProp.handles.u235_target_text,'FontWeight','bold');
    set(HotBirdProp.handles.u235_target_text,'FontSize',11);
    set(HotBirdProp.handles.u235_target_text,'FontUnits', 'normalized');
    set(HotBirdProp.handles.u235_target_text,'BackgroundColor', [0.99,0.99,0.99]);
    
    
    %  U235 target edit
    ce = sprintf('%5.3f',HotBirdProp.u235_target);
    HotBirdProp.handles.u235_target_edit=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.40 0.25 0.08 0.06]  , ...
        'string',ce,'callback',{@change_u235_target,hfig});
    set(HotBirdProp.handles.u235_target_edit,'FontSize',11);
    set(HotBirdProp.handles.u235_target_edit,'FontUnits', 'normalized');
    set(HotBirdProp.handles.u235_target_edit,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  U235 target Slider
    HotBirdProp.handles.u235_target_slider = uicontrol(hfig3,'Style','slider',...
        'Max',500,'Min',0,'Value',0,...
        'SliderStep',[0.002 0.02], 'units','Normalized', 'Position',[.32 .19 .16 .04], ...
        'Callback', {@u235_target_slider_callback,hfig});
    set(HotBirdProp.handles.u235_target_slider,'value',round(HotBirdProp.u235_target*100));
    set(HotBirdProp.handles.u235_target_slider,'FontSize',11);
    set(HotBirdProp.handles.u235_target_slider,'FontUnits', 'normalized');
    set(HotBirdProp.handles.u235_target_slider,'BackgroundColor', [0.97,0.97,0.97]);
    
    %%  Max Burnup text
    HotBirdProp.handles.max_burnup_text=annotation(hfig3,'textbox',[0.25 0.35 0.17 0.07], ...
        'String','Max burnup','HorizontalAlignment','left');
    set(HotBirdProp.handles.max_burnup_text,'LineStyle','none');
    set(HotBirdProp.handles.max_burnup_text,'FontWeight','bold');
    set(HotBirdProp.handles.max_burnup_text,'FontSize',11);
    set(HotBirdProp.handles.max_burnup_text,'FontUnits', 'normalized');
    set(HotBirdProp.handles.max_burnup_text,'BackgroundColor', [0.99,0.99,0.99]);
    
    ce = sprintf('%4.0f',30);
    HotBirdProp.handles.max_burnup =uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.42 0.35 0.05 0.06]  , ...
        'string',HotBirdProp.optimize.max_burnup,'callback',{@set_max_burnup,hfig});
    set(HotBirdProp.handles.max_burnup,'FontSize',11);
    set(HotBirdProp.handles.max_burnup,'FontUnits', 'normalized');
    set(HotBirdProp.handles.max_burnup,'BackgroundColor', [0.99,0.99,0.99]);
    
    %%  Optimizing info1 text
    HotBirdProp.handles.opt_info1_text=annotation(hfig3,'textbox',[0.02 0.03 0.40 0.07], ...
        'String','Pellet optimizing status','HorizontalAlignment','left');
    set(HotBirdProp.handles.opt_info1_text,'LineStyle','none');
    set(HotBirdProp.handles.opt_info1_text,'FontWeight','bold');
    set(HotBirdProp.handles.opt_info1_text,'FontSize',11);
    set(HotBirdProp.handles.opt_info1_text,'FontUnits', 'normalized');
    set(HotBirdProp.handles.opt_info1_text,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  Optimizing info2 text
    HotBirdProp.handles.opt_info2_text=annotation(hfig3,'textbox',[0.02 0.11 0.50 0.07], ...
        'String','Bundle optimizing status','HorizontalAlignment','left');
    set(HotBirdProp.handles.opt_info2_text,'LineStyle','none');
    set(HotBirdProp.handles.opt_info2_text,'FontWeight','bold');
    set(HotBirdProp.handles.opt_info2_text,'FontSize',11);
    set(HotBirdProp.handles.opt_info2_text,'FontUnits', 'normalized');
    set(HotBirdProp.handles.opt_info2_text,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  Case number opt Slider
    HotBirdProp.handles.cn_opt_slider = uicontrol(hfig3,'Style','slider','Max',10,'Min',1,'Value',0, ...
        'SliderStep',[0.1 0.1], 'units','Normalized', 'Position',[0.70 0.21 0.10 0.04], ...
        'Callback', {@cn_opt_slider_callback,hfig});
    set(HotBirdProp.handles.cn_opt_slider,'value',HotBirdProp.cn);
    set(HotBirdProp.handles.cn_opt_slider,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  Case number text
    cc=sprintf('Case nr %d',HotBirdProp.cn);
    HotBirdProp.handles.cn_fint_text1=annotation(hfig3,'textbox',[0.81 0.20 0.15 0.07], ...
        'String',cc,'HorizontalAlignment','left');
    set(HotBirdProp.handles.cn_fint_text1,'LineStyle','none');
    set(HotBirdProp.handles.cn_fint_text1,'FontWeight','bold');
    set(HotBirdProp.handles.cn_fint_text1,'FontSize',11);
    set(HotBirdProp.handles.cn_fint_text1,'FontUnits', 'normalized');
    set(HotBirdProp.handles.cn_fint_text1,'BackgroundColor', [0.99,0.99,0.99]);
    
    
    %%  btf target optimizing checkbox
    HotBirdProp.handles.btf_limit_checkbox=uicontrol('Style','checkbox','Units','Normalized', ...
        'position',[0.55  0.90 0.20 0.07] ,'string',' BTF target', 'FontWeight','bold', ...
        'callback',{@btf_target_callback,hfig});
    set(HotBirdProp.handles.btf_limit_checkbox,'value',HotBirdProp.btf_target);
    set(hfig,'userdata',HotBirdProp);
    set(HotBirdProp.handles.btf_limit_checkbox,'FontSize',11);
    set(HotBirdProp.handles.btf_limit_checkbox,'FontUnits', 'normalized');
    set(HotBirdProp.handles.btf_limit_checkbox,'BackgroundColor', [0.99,0.99,0.99]);
    HotBirdProp.btf_target = 0;
    set(hfig,'userdata',HotBirdProp);
    
    %%
    HotBirdProp.handles.cn_btf_text2=annotation(hfig3,'textbox',[0.55 0.80 0.095 0.07], ...
        'String','burnup','HorizontalAlignment','center');
    set(HotBirdProp.handles.cn_btf_text2,'LineStyle','none');
    set(HotBirdProp.handles.cn_btf_text2,'FontWeight','bold');
    set(HotBirdProp.handles.cn_btf_text2,'FontSize',11);
    set(HotBirdProp.handles.cn_btf_text2,'FontUnits', 'normalized');
    set(HotBirdProp.handles.cn_btf_text2,'BackgroundColor', [0.99,0.99,0.99]);
    
    %%  max btf text
    HotBirdProp.handles.cn_btf_text3=annotation(hfig3,'textbox',[0.65 0.80 0.12 0.07], ...
        'String','max BTF','HorizontalAlignment','left');
    set(HotBirdProp.handles.cn_btf_text3,'LineStyle','none');
    set(HotBirdProp.handles.cn_btf_text3,'FontWeight','bold');
    set(HotBirdProp.handles.cn_btf_text3,'FontSize',11);
    set(HotBirdProp.handles.cn_btf_text3,'FontUnits', 'normalized');
    set(HotBirdProp.handles.cn_btf_text3,'BackgroundColor', [0.99,0.99,0.99]);
    
    
    %  bur01
    ce = sprintf('%4.0f',0);
    HotBirdProp.handles.bur01=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.55 0.72 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur01,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.bur01,'FontSize',11);
    set(HotBirdProp.handles.bur01,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur01,'BackgroundColor', [0.99,0.99,0.99]);
    
    
    %  bur02
    ce = sprintf('%4.0f',5);
    HotBirdProp.handles.bur02=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.55 0.65 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur02,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.bur02,'FontSize',11);
    set(HotBirdProp.handles.bur02,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur02,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  bur03
    ce = sprintf('%4.0f',10);
    HotBirdProp.handles.bur03=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.55 0.58 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur03,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.bur03,'FontSize',11);
    set(HotBirdProp.handles.bur03,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur03,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  bur04
    ce = sprintf('%4.0f',20);
    HotBirdProp.handles.bur04=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.55 0.51 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur04,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.bur04,'FontSize',11);
    set(HotBirdProp.handles.bur04,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur04,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  bur05
    ce = sprintf('%4.0f',30);
    HotBirdProp.handles.bur05=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.55 0.44 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur05,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.bur05,'FontSize',11);
    set(HotBirdProp.handles.bur05,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur05,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  btf1
    ce = sprintf('%4.2f',0.98);
    HotBirdProp.handles.btf1=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.65 0.72 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.btf1,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.btf1,'FontSize',11);
    set(HotBirdProp.handles.btf1,'FontUnits', 'normalized');
    set(HotBirdProp.handles.btf1,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  btf2
    ce = sprintf('%4.2f',0.98);
    HotBirdProp.handles.btf2=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.65 0.65 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.btf2,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.btf2,'FontSize',11);
    set(HotBirdProp.handles.btf2,'FontUnits', 'normalized');
    set(HotBirdProp.handles.btf2,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  btf3
    ce = sprintf('%4.2f',0.98);
    HotBirdProp.handles.btf3=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.65 0.58 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.btf3,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.btf3,'FontSize',11);
    set(HotBirdProp.handles.btf3,'FontUnits', 'normalized');
    set(HotBirdProp.handles.btf3,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  btf4
    ce = sprintf('%4.2f',0.98);
    HotBirdProp.handles.btf4=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.65 0.51 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.btf4,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.btf4,'FontSize',11);
    set(HotBirdProp.handles.btf4,'FontUnits', 'normalized');
    set(HotBirdProp.handles.btf4,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  btf5
    ce = sprintf('%4.2f',0.98);
    HotBirdProp.handles.btf5=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.65 0.44 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.btf5,'callback',{@calc_maxbtf_tab,hfig});
    set(HotBirdProp.handles.btf5,'FontSize',11);
    set(HotBirdProp.handles.btf5,'FontUnits', 'normalized');
    set(HotBirdProp.handles.btf5,'BackgroundColor', [0.99,0.99,0.99]);
    
    %%  set max btf text
    HotBirdProp.handles.maxbtf_text=annotation(hfig3,'textbox',[0.53 0.335 0.12 0.07], ...
        'String','max BTF','HorizontalAlignment','left');
    set(HotBirdProp.handles.maxbtf_text,'LineStyle','none');
    set(HotBirdProp.handles.maxbtf_text,'FontWeight','bold');
    set(HotBirdProp.handles.maxbtf_text,'FontSize',11);
    set(HotBirdProp.handles.maxbtf_text,'FontUnits', 'normalized');
    set(HotBirdProp.handles.maxbtf_text,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  Set max btf value
    ce = sprintf('%4.2f',0.98);
    HotBirdProp.handles.maxbtf=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.65 0.34 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.maxbtf,'callback',{@set_maxbtf,hfig});
    set(HotBirdProp.handles.maxbtf,'FontSize',11);
    set(HotBirdProp.handles.maxbtf,'FontUnits', 'normalized');
    set(HotBirdProp.handles.maxbtf,'BackgroundColor', [0.99,0.99,0.99]);
    
    %%  target fint text
    HotBirdProp.handles.max_fint_text=annotation(hfig3,'textbox',[0.79 0.90 0.19 0.07], ...
        'String','fint target','HorizontalAlignment','center');
    set(HotBirdProp.handles.max_fint_text,'LineStyle','none');
    set(HotBirdProp.handles.max_fint_text,'FontWeight','bold');
    set(HotBirdProp.handles.max_fint_text,'FontSize',11);
    set(HotBirdProp.handles.max_fint_text,'FontUnits', 'normalized');
    set(HotBirdProp.handles.max_fint_text,'BackgroundColor', [0.99,0.99,0.99]);
    
    %%  Burnup text
    HotBirdProp.handles.cn_fint_text2=annotation(hfig3,'textbox',[0.79 0.80 0.08 0.07], ...
        'String','burnup','HorizontalAlignment','left');
    set(HotBirdProp.handles.cn_fint_text2,'LineStyle','none');
    set(HotBirdProp.handles.cn_fint_text2,'FontWeight','bold');
    set(HotBirdProp.handles.cn_fint_text2,'FontSize',11);
    set(HotBirdProp.handles.cn_fint_text2,'FontUnits', 'normalized');
    set(HotBirdProp.handles.cn_fint_text2,'BackgroundColor', [0.99,0.99,0.99]);
    
    
    %%  max fint text
    HotBirdProp.handles.cn_fint_text3=annotation(hfig3,'textbox',[0.89 0.80 0.10 0.07], ...
        'String','max fint','HorizontalAlignment','center');
    set(HotBirdProp.handles.cn_fint_text3,'LineStyle','none');
    set(HotBirdProp.handles.cn_fint_text3,'FontWeight','bold');
    set(HotBirdProp.handles.cn_fint_text3,'FontSize',11);
    set(HotBirdProp.handles.cn_fint_text3,'FontUnits', 'normalized');
    set(HotBirdProp.handles.cn_fint_text3,'BackgroundColor', [0.99,0.99,0.99]);
    
    %%  bur1
    ce = sprintf('%4.0f',0);
    HotBirdProp.handles.bur1=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.79 0.72 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur1{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.bur1,'FontSize',11);
    set(HotBirdProp.handles.bur1,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur1,'BackgroundColor', [0.99,0.99,0.99]);
    %  bur2
    ce = sprintf('%4.0f',5);
    HotBirdProp.handles.bur2=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.79 0.65 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur2{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.bur2,'FontSize',11);
    set(HotBirdProp.handles.bur2,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur2,'BackgroundColor', [0.99,0.99,0.99]);
    %  bur3
    ce = sprintf('%4.0f',10);
    HotBirdProp.handles.bur3=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.79 0.58 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur3{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.bur3,'FontSize',11);
    set(HotBirdProp.handles.bur3,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur3,'BackgroundColor', [0.99,0.99,0.99]);
    %  bur4
    ce = sprintf('%4.0f',20);
    HotBirdProp.handles.bur4=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.79 0.51 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur4{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.bur4,'FontSize',11);
    set(HotBirdProp.handles.bur4,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur4,'BackgroundColor', [0.99,0.99,0.99]);
    %  bur5
    ce = sprintf('%4.0f',30);
    HotBirdProp.handles.bur5=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.79 0.44 0.07 0.06]  , ...
        'string',HotBirdProp.optimize.bur5{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.bur5,'FontSize',11);
    set(HotBirdProp.handles.bur5,'FontUnits', 'normalized');
    set(HotBirdProp.handles.bur5,'BackgroundColor', [0.99,0.99,0.99]);
    %  fint1
    ce = sprintf('%4.2f',1.25);
    HotBirdProp.handles.fint1=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.89 0.72 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.fint1{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.fint1,'FontSize',11);
    set(HotBirdProp.handles.fint1,'FontUnits', 'normalized');
    set(HotBirdProp.handles.fint1,'BackgroundColor', [0.99,0.99,0.99]);
    %  fint2
    ce = sprintf('%4.2f',1.25);
    HotBirdProp.handles.fint2=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.89 0.65 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.fint2{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.fint2,'FontSize',11);
    set(HotBirdProp.handles.fint2,'FontUnits', 'normalized');
    set(HotBirdProp.handles.fint2,'BackgroundColor', [0.99,0.99,0.99]);
    %  fint3
    ce = sprintf('%4.2f',1.25);
    HotBirdProp.handles.fint3=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.89 0.58 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.fint3{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.fint3,'FontSize',11);
    set(HotBirdProp.handles.fint3,'FontUnits', 'normalized');
    set(HotBirdProp.handles.fint3,'BackgroundColor', [0.99,0.99,0.99]);
    %  fint4
    ce = sprintf('%4.2f',1.25);
    HotBirdProp.handles.fint4=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.89 0.51 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.fint4{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.fint4,'FontSize',11);
    set(HotBirdProp.handles.fint4,'FontUnits', 'normalized');
    set(HotBirdProp.handles.fint4,'BackgroundColor', [0.99,0.99,0.99]);
    %  fint5
    ce = sprintf('%4.2f',1.25);
    HotBirdProp.handles.fint5=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.89 0.44 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.fint5{HotBirdProp.cn},'callback',{@change_maxfint_tab,hfig});
    set(HotBirdProp.handles.fint5,'FontSize',11);
    set(HotBirdProp.handles.fint5,'FontUnits', 'normalized');
    set(HotBirdProp.handles.fint5,'BackgroundColor', [0.99,0.99,0.99]);
    %  set max fint text
    HotBirdProp.handles.maxfint_text=annotation(hfig3,'textbox',[0.77 0.335 0.12 0.07], ...
        'String','max fint','HorizontalAlignment','left');
    set(HotBirdProp.handles.maxfint_text,'LineStyle','none');
    set(HotBirdProp.handles.maxfint_text,'FontWeight','bold');
    set(HotBirdProp.handles.maxfint_text,'FontSize',11);
    set(HotBirdProp.handles.maxfint_text,'FontUnits', 'normalized');
    set(HotBirdProp.handles.maxfint_text,'BackgroundColor', [0.99,0.99,0.99]);
    
    %  Set max fint value
    ce = sprintf('%4.2f',1.25);
    HotBirdProp.handles.maxfint=uicontrol('Style','edit','Units','Normalized','FontWeight','bold',...
        'HorizontalAlignment','center','position', [0.89 0.335 0.08 0.06]  , ...
        'string',HotBirdProp.optimize.maxfint,'callback',{@set_maxfint,hfig});
    set(HotBirdProp.handles.maxfint,'FontWeight','bold');
    set(HotBirdProp.handles.maxfint,'FontSize',11);
    set(HotBirdProp.handles.maxfint,'FontUnits', 'normalized');
    set(HotBirdProp.handles.maxfint,'BackgroundColor', [0.99,0.99,0.99]);
    
    set(hfig,'userdata',HotBirdProp);
    
    cn = HotBirdProp.cn;
    for m=1:HotBirdProp.cs.cnmax
        HotBirdProp.cn = m;  
        set(hfig,'userdata',HotBirdProp);
        calc_maxfint_tab([],[],hfig);
    end
    HotBirdProp.cn=cn;
    set(hfig,'userdata',HotBirdProp);
    calc_maxbtf_tab([],[],hfig);
    HotBirdProp.cn = cn;
    
    
end
set(hfig,'userdata',HotBirdProp);

end

%
%----------- Start of optimizing functions --------------------------
%


function radial_optimizing(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

if (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
    increase_u235([],[],hfig);
    u235=calc_u235([],[],hfig);
    k=0;
    u1=999;
    i1=999;
    j1=999;
    while (u235 > HotBirdProp.u235_target+0.004 && k < 100)
        [imax,jmax]=calc_btf([],[],hfig);
        u0=HotBirdProp.cs.s(HotBirdProp.cn).fue((HotBirdProp.cs.s(HotBirdProp.cn).lfu(imax,jmax)),3);
        if (u0==u1 && i1==imax && j1==jmax)
            if (HotBirdProp.cs.s(HotBirdProp.cn).ba(imax,jmax) > 0)
                decrease_u235_barod([],[],hfig,imax,jmax);
                [~,~]=calc_btf([],[],hfig);
            else
                check_min_u235([],[],hfig,imax,jmax);
                [~,~]=calc_btf([],[],hfig);
            end
        end
        decrease_u235([],[],hfig,imax,jmax);
        u235=calc_u235([],[],hfig);
        k=k+1;
        i1=imax;
        j1=jmax;
        u1= HotBirdProp.cs.s(HotBirdProp.cn).fue((HotBirdProp.cs.s(HotBirdProp.cn).lfu(i1,j1)),3);
%        paint_patron([],[],hfig);
    end
    max_corner_fint([],[],hfig);
    max_corner_tmol([],[],hfig);
    [~,~]=calc_btf([],[],hfig);
    check_maxfint([],[],hfig);
    check_maxbtf([],[],hfig);
    adjust_btfp([],[],hfig);
    [~,~]=calc_btf([],[],hfig);
%     max_corner_fint([],[],hfig);
%     max_corner_tmol([],[],hfig);
    calc_tmol_limit([],[],hfig);
    adjust_tmol([],[],hfig);
    set(hfig,'userdata',HotBirdProp);
    paint_btf([],[],hfig);
end
end


function radial_optimizing5(~,~,hfig)

HotBirdProp=get(hfig,'userdata');


%HotBirdProp.handles.bundle_xtimes
k=str2double(get(HotBirdProp.handles.bundle_xtimes,'string'));


for i=1:k
    ce = sprintf('Radial optimizing status %d of %d',i,k);
    set(HotBirdProp.handles.opt_info2_text,'string',ce);
    
    radial_optimizing([],[],hfig);
    
    
    
end
set(hfig,'userdata',HotBirdProp);
paint_btf([],[],hfig);
end



function radial_optimizing_bundle(~,~,hfig)

HotBirdProp=get(hfig,'userdata');


k=40;


for i=1:k
    ce = sprintf('Radial optimizing status %d of max %d',i,k);
    set(HotBirdProp.handles.opt_info2_text,'string',ce);
    
    radial_optimizing([],[],hfig);
    HotBirdProp=get(hfig,'userdata');
    
    if(max(max(HotBirdProp.cs.fintp_bundle))==0 && max(max(HotBirdProp.cs.btfp_btf))==0 && max(max(HotBirdProp.cs.powp))==0)
        break;
    end 
end

set(hfig,'userdata',HotBirdProp);
paint_btf([],[],hfig);
end











function both_optimizing(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

if (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
    n=0;
    for j=1:3
        for i=1:5
            n=n+1;
            ce = sprintf('Radial optimizing status %d of %d',n,17);
            set(HotBirdProp.handles.opt_info2_text,'string',ce);
            radial_optimizing([],[],hfig);
        end
        enr_optimizing([],[],hfig);
    end
    ce = sprintf('Radial optimizing status %d of %d',16,17);
    set(HotBirdProp.handles.opt_info2_text,'string',ce);
    radial_optimizing([],[],hfig);
    ce = sprintf('Radial optimizing status %d of %d',17,17);
    set(HotBirdProp.handles.opt_info2_text,'string',ce);
    radial_optimizing([],[],hfig);
    set(hfig,'userdata',HotBirdProp);
    paint_btf([],[],hfig);
end

end



function enr_optimizing(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

if (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
    mz=HotBirdProp.cs.enr_combinations();
    HotBirdProp.cs.min_btfax_env=100;
    ce = sprintf('U235 optimizing status %d of %d',1,mz);
    set(HotBirdProp.handles.opt_info1_text,'string',ce);
    for mm=1:mz
        ce = sprintf('U235 optimizing status %d of %d',mm,mz);
        set(HotBirdProp.handles.opt_info1_text,'string',ce);
        HotBirdProp.cs.enr_opt(mm);
    end   
    calc_tmol_limit([],[],hfig);
    set(hfig,'userdata',HotBirdProp);
    paint_btf([],[],hfig);
    paint_enr([],[],hfig);
end

end


function increase_u235(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
HotBirdProp.cs.increase_u235();
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

 
 
 function decrease_u235(~,~,hfig,imax,jmax)
 
 HotBirdProp=get(hfig,'userdata');
 HotBirdProp.cs.decrease_u235(imax,jmax);
 set(hfig,'userdata',HotBirdProp);
 end

 
 
 function decrease_u235_barod(~,~,hfig,imax,jmax)
 
 HotBirdProp=get(hfig,'userdata');
 HotBirdProp.cs.decrease_u235_barod(imax,jmax);
 set(hfig,'userdata',HotBirdProp);
 end
 
 
 
 function check_min_u235(~,~,hfig,imax,jmax)
 
 HotBirdProp=get(hfig,'userdata');
 HotBirdProp.cs.check_min_u235(imax,jmax);
 set(hfig,'userdata',HotBirdProp);
 end
 
 
 function check_maxfint(~,~,hfig)
 
 HotBirdProp=get(hfig,'userdata');
 HotBirdProp.cs.check_maxfint();
 set(hfig,'userdata',HotBirdProp);
 end
 
 
 function check_maxbtf(~,~,hfig)
 
 HotBirdProp=get(hfig,'userdata');
 
 if (HotBirdProp.axial_btf == 1 && HotBirdProp.btf_target == 1)
     HotBirdProp.cs.check_maxbtf();
 end
 set(hfig,'userdata',HotBirdProp);
 end
 
 
 
 function adjust_btfp(~,~,hfig)
 
 HotBirdProp=get(hfig,'userdata');
 
 HotBirdProp.cs.adjust_btfp();
 if (HotBirdProp.btf_target == 1)
     HotBirdProp.cs.adjust_btfp_btf();
 end
 set(hfig,'userdata',HotBirdProp);
 end
 
 
 function adjust_tmol(~,~,hfig)
 
 HotBirdProp=get(hfig,'userdata');
 
 if (HotBirdProp.ba_rod==1 || HotBirdProp.corner_rod==1 || HotBirdProp.plr_rod==1 || HotBirdProp.aut_ba_rod==1 || HotBirdProp.sel_rods==1)
     HotBirdProp.cs.adjust_tmol();
 end
 set(hfig,'userdata',HotBirdProp);
 end
 
 %
 % ---------------------------- End of optimizing functions -----------
 %



 function change_u235_target(src,~,hfig)
 
 HotBirdProp=get(hfig,'userdata');
 
 Str = get(src,'String');
 HotBirdProp.u235_target = sscanf(Str,'%f');
 if(HotBirdProp.u235_target > 5)
     HotBirdProp.u235_target = 5.00;
     Str = sprintf('%4.2f', HotBirdProp.u235_target);
     set(HotBirdProp.handles.u235_target_edit,'String',Str);
 end
 if(HotBirdProp.u235_target < 0)
     HotBirdProp.u235_target = 0.00;
    Str = sprintf('%4.2f', HotBirdProp.u235_target);
    set(HotBirdProp.handles.u235_target_edit,'String',Str);    
 end
set(HotBirdProp.handles.u235_target_slider,'Value',round(HotBirdProp.u235_target*100));
set(hfig,'userdata',HotBirdProp);
end


function u235_target_slider_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
slider_value = get(src,'Value');
HotBirdProp.u235_target=slider_value/100;
Str = sprintf('%4.2f', HotBirdProp.u235_target);
set(HotBirdProp.handles.u235_target_edit,'String',Str);
set(hfig,'userdata',HotBirdProp);
end


function cn_opt_slider_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');

slider_value = round(get(src,'Value'));
if (slider_value > HotBirdProp.cs.cnmax)
    slider_value = HotBirdProp.cs.cnmax;
end
HotBirdProp.cn = slider_value;
set(HotBirdProp.handles.cn_slider,'value',slider_value);
cc=sprintf('Case Number %d',slider_value);
set(HotBirdProp.handles.cn_textbox,'string',cc);
cc=sprintf('Case nr %d',slider_value);
set(HotBirdProp.handles.cn_fint_text1,'string',cc);
cn_slider_callback(HotBirdProp.handles.cn_slider,[],hfig);
cn = HotBirdProp.cn;
ce = sprintf('%4.0f',HotBirdProp.cs.s(cn).finttab(1,1));
set(HotBirdProp.handles.bur1,'string',ce);
% set(HotBirdProp.handles.bur1, 'FontSize', 10);
ce = sprintf('%4.2f',HotBirdProp.cs.s(cn).finttab(1,2));
set(HotBirdProp.handles.fint1,'string',ce);
ce = sprintf('%4.0f',HotBirdProp.cs.s(cn).finttab(2,1));
set(HotBirdProp.handles.bur2,'string',ce);
ce = sprintf('%4.2f',HotBirdProp.cs.s(cn).finttab(2,2));
set(HotBirdProp.handles.fint2,'string',ce);
ce = sprintf('%4.0f',HotBirdProp.cs.s(cn).finttab(3,1));
set(HotBirdProp.handles.bur3,'string',ce);
ce = sprintf('%4.2f',HotBirdProp.cs.s(cn).finttab(3,2));
set(HotBirdProp.handles.fint3,'string',ce);
ce = sprintf('%4.0f',HotBirdProp.cs.s(cn).finttab(4,1));
set(HotBirdProp.handles.bur4,'string',ce);
ce = sprintf('%4.2f',HotBirdProp.cs.s(cn).finttab(4,2));
set(HotBirdProp.handles.fint4,'string',ce);
ce = sprintf('%4.0f',HotBirdProp.cs.s(cn).finttab(5,1));
set(HotBirdProp.handles.bur5,'string',ce);
ce = sprintf('%4.2f',HotBirdProp.cs.s(cn).finttab(5,2));
set(HotBirdProp.handles.fint5,'string',ce);
ce = sprintf('%4.0f',HotBirdProp.cs.btftab(1,1));
set(HotBirdProp.handles.bur01,'string',ce);
ce = sprintf('%4.2f',HotBirdProp.cs.btftab(1,2));
set(HotBirdProp.handles.btf1,'string',ce);
ce = sprintf('%4.0f',HotBirdProp.cs.btftab(2,1));
set(HotBirdProp.handles.bur02,'string',ce);
ce = sprintf('%4.2f',HotBirdProp.cs.btftab(2,2));
set(HotBirdProp.handles.btf2,'string',ce);
ce = sprintf('%4.0f',HotBirdProp.cs.btftab(3,1));
set(HotBirdProp.handles.bur03,'string',ce);
ce = sprintf('%4.2f',HotBirdProp.cs.btftab(3,2));
set(HotBirdProp.handles.btf3,'string',ce);
ce = sprintf('%4.0f',HotBirdProp.cs.btftab(4,1));
set(HotBirdProp.handles.bur04,'string',ce);
ce = sprintf('%4.2f',HotBirdProp.cs.btftab(4,2));
set(HotBirdProp.handles.btf4,'string',ce);
ce = sprintf('%4.0f',HotBirdProp.cs.btftab(5,1));
set(HotBirdProp.handles.bur05,'string',ce);
ce = sprintf('%4.2f',HotBirdProp.cs.btftab(5,2));
set(HotBirdProp.handles.btf5,'string',ce);
set(hfig,'userdata',HotBirdProp);
end


function calc_maxfint_tab(~,~,hfig)

HotBirdProp=get(hfig,'userdata');


tab = nan(5,2);
for k=1:HotBirdProp.cs.cnmax
    tab(1,1) = sscanf(HotBirdProp.optimize.bur1{k},'%f');
    tab(2,1) = sscanf(HotBirdProp.optimize.bur2{k},'%f');
    tab(3,1) = sscanf(HotBirdProp.optimize.bur3{k},'%f');
    tab(4,1) = sscanf(HotBirdProp.optimize.bur4{k},'%f');
    tab(5,1) = sscanf(HotBirdProp.optimize.bur5{k},'%f');
    tab(1,2) = sscanf(HotBirdProp.optimize.fint1{k},'%f');
    tab(2,2) = sscanf(HotBirdProp.optimize.fint2{k},'%f');
    tab(3,2) = sscanf(HotBirdProp.optimize.fint3{k},'%f');
    tab(4,2) = sscanf(HotBirdProp.optimize.fint4{k},'%f');
    tab(5,2) = sscanf(HotBirdProp.optimize.fint5{k},'%f');
    HotBirdProp.cs.s(k).calc_maxfint_tab(tab);
end



set(hfig,'userdata',HotBirdProp);

end


function change_maxfint_tab(~,~,hfig)

HotBirdProp=get(hfig,'userdata');


k=HotBirdProp.cn;
HotBirdProp.optimize.bur1{k} = '0';
set(HotBirdProp.handles.bur1,'string','0');
HotBirdProp.optimize.bur2{k} = get(HotBirdProp.handles.bur2,'string');
HotBirdProp.optimize.bur3{k} = get(HotBirdProp.handles.bur3,'string');
HotBirdProp.optimize.bur4{k} = get(HotBirdProp.handles.bur4,'string');
HotBirdProp.optimize.bur5{k} = get(HotBirdProp.handles.bur5,'string');
HotBirdProp.optimize.fint1{k} = get(HotBirdProp.handles.fint1,'string');
HotBirdProp.optimize.fint2{k} = get(HotBirdProp.handles.fint2,'string');
HotBirdProp.optimize.fint3{k} = get(HotBirdProp.handles.fint3,'string');
HotBirdProp.optimize.fint4{k} = get(HotBirdProp.handles.fint4,'string');
HotBirdProp.optimize.fint5{k} = get(HotBirdProp.handles.fint5,'string');



tab = nan(5,2);
for k=1:HotBirdProp.cs.cnmax
    tab(1,1) = sscanf(HotBirdProp.optimize.bur1{k},'%f');
    tab(2,1) = sscanf(HotBirdProp.optimize.bur2{k},'%f');
    tab(3,1) = sscanf(HotBirdProp.optimize.bur3{k},'%f');
    tab(4,1) = sscanf(HotBirdProp.optimize.bur4{k},'%f');
    tab(5,1) = sscanf(HotBirdProp.optimize.bur5{k},'%f');
    tab(1,2) = sscanf(HotBirdProp.optimize.fint1{k},'%f');
    tab(2,2) = sscanf(HotBirdProp.optimize.fint2{k},'%f');
    tab(3,2) = sscanf(HotBirdProp.optimize.fint3{k},'%f');
    tab(4,2) = sscanf(HotBirdProp.optimize.fint4{k},'%f');
    tab(5,2) = sscanf(HotBirdProp.optimize.fint5{k},'%f');
    HotBirdProp.cs.s(k).calc_maxfint_tab(tab);
end





set(hfig,'userdata',HotBirdProp);

end






function calc_maxbtf_tab(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

tab = nan(5,2);


HotBirdProp.optimize.bur01 = '0';
set(HotBirdProp.handles.bur01,'string','0');
tab(1,1) = sscanf(HotBirdProp.optimize.bur01,'%f');
HotBirdProp.optimize.bur02 = get(HotBirdProp.handles.bur02,'string');
tab(2,1) = sscanf(HotBirdProp.optimize.bur02,'%f');
HotBirdProp.optimize.bur03 = get(HotBirdProp.handles.bur03,'string');
tab(3,1) = sscanf(HotBirdProp.optimize.bur03,'%f');
HotBirdProp.optimize.bur04 = get(HotBirdProp.handles.bur04,'string');
tab(4,1) = sscanf(HotBirdProp.optimize.bur04,'%f');
HotBirdProp.optimize.bur05 = get(HotBirdProp.handles.bur05,'string');
tab(5,1) = sscanf(HotBirdProp.optimize.bur05,'%f');
HotBirdProp.optimize.btf1 = get(HotBirdProp.handles.btf1,'string');
tab(1,2) = sscanf(HotBirdProp.optimize.btf1,'%f');
HotBirdProp.optimize.btf2 = get(HotBirdProp.handles.btf2,'string');
tab(2,2) = sscanf(HotBirdProp.optimize.btf2,'%f');
HotBirdProp.optimize.btf3 = get(HotBirdProp.handles.btf3,'string');
tab(3,2) = sscanf(HotBirdProp.optimize.btf3,'%f');
HotBirdProp.optimize.btf4 = get(HotBirdProp.handles.btf4,'string');
tab(4,2) = sscanf(HotBirdProp.optimize.btf4,'%f');
HotBirdProp.optimize.btf5 = get(HotBirdProp.handles.btf5,'string');
tab(5,2) = sscanf(HotBirdProp.optimize.btf5,'%f');
HotBirdProp.cs.calc_maxbtf_tab(tab);
set(hfig,'userdata',HotBirdProp);
end



function reset_btfp(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

HotBirdProp.cs.reset_btfp();
paint_btfp([],[],hfig);
set(hfig,'userdata',HotBirdProp);
end


function reset_powp(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

for m=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(m).reset_tmol();
end
paint_tmol([],[],hfig);
set(hfig,'userdata',HotBirdProp);
end


function set_maxfint(src,~,hfig)

HotBirdProp=get(hfig,'userdata');

HotBirdProp.optimize.maxfint = get(src,'string');
maxfint = sscanf(HotBirdProp.optimize.maxfint,'%f');
cn = HotBirdProp.cn;
ce = sprintf('%4.2f',maxfint);
set(HotBirdProp.handles.fint1,'string',ce);
HotBirdProp.cs.s(cn).finttab(1,2) = maxfint;
HotBirdProp.optimize.fint1{cn}=ce;
ce = sprintf('%4.2f',maxfint);
set(HotBirdProp.handles.fint2,'string',ce);
HotBirdProp.cs.s(cn).finttab(2,2) = maxfint;
HotBirdProp.optimize.fint2{cn}=ce;
ce = sprintf('%4.2f',maxfint);
set(HotBirdProp.handles.fint3,'string',ce);
HotBirdProp.cs.s(cn).finttab(3,2) = maxfint;
HotBirdProp.optimize.fint3{cn}=ce;
ce = sprintf('%4.2f',maxfint);
set(HotBirdProp.handles.fint4,'string',ce);
HotBirdProp.cs.s(cn).finttab(4,2) = maxfint;
HotBirdProp.optimize.fint4{cn}=ce;
ce = sprintf('%4.2f',maxfint);
set(HotBirdProp.handles.fint5,'string',ce);
HotBirdProp.cs.s(cn).finttab(5,2) = maxfint;
HotBirdProp.optimize.fint5{cn}=ce;
set(hfig,'userdata',HotBirdProp);
calc_maxfint_tab([],[],hfig);
set(hfig,'userdata',HotBirdProp);
end


function set_maxbtf(src,~,hfig)

HotBirdProp=get(hfig,'userdata');

HotBirdProp.optimize.maxbtf = get(src,'string');
maxbtf = sscanf(HotBirdProp.optimize.maxbtf,'%f');
cn = HotBirdProp.cn;
ce = sprintf('%4.2f',maxbtf);
set(HotBirdProp.handles.btf1,'string',ce);
HotBirdProp.optimize.btf1=ce;
HotBirdProp.cs.btftab(1,2) = maxbtf;
ce = sprintf('%4.2f',maxbtf);
set(HotBirdProp.handles.btf2,'string',ce);
HotBirdProp.optimize.btf2=ce;
HotBirdProp.cs.btftab(2,2) = maxbtf;
ce = sprintf('%4.2f',maxbtf);
set(HotBirdProp.handles.btf3,'string',ce);
HotBirdProp.optimize.btf3=ce;
HotBirdProp.cs.btftab(3,2) = maxbtf;
ce = sprintf('%4.2f',maxbtf);
set(HotBirdProp.handles.btf4,'string',ce);
HotBirdProp.optimize.btf4=ce;
HotBirdProp.cs.btftab(4,2) = maxbtf;
ce = sprintf('%4.2f',maxbtf);
set(HotBirdProp.handles.btf5,'string',ce);
HotBirdProp.optimize.btf5=ce;
HotBirdProp.cs.btftab(5,2) = maxbtf;
calc_maxbtf_tab([],[],hfig);
set(hfig,'userdata',HotBirdProp);
end


function btf_target_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');


HotBirdProp.btf_target = get(src,'value');
set(hfig,'userdata',HotBirdProp);
end


function calc_tmol_limit(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

HotBirdProp.optimize.corner_rod_checkbox=get(HotBirdProp.handles.corner_rod_checkbox,'value');
HotBirdProp.optimize.corner_rod=get(HotBirdProp.handles.corner_rod,'string');
set(HotBirdProp.handles.corner_rod,'string',HotBirdProp.optimize.corner_rod);

HotBirdProp.optimize.plr_rod_checkbox=get(HotBirdProp.handles.plr_rod_checkbox,'value');
HotBirdProp.optimize.plr_rod=get(HotBirdProp.handles.plr_rod,'string');
set(HotBirdProp.handles.plr_rod,'string',HotBirdProp.optimize.plr_rod);

HotBirdProp.optimize.ba_rod_checkbox=get(HotBirdProp.handles.ba_rod_checkbox,'value');
HotBirdProp.optimize.ba_rod=get(HotBirdProp.handles.ba_rod,'string');
set(HotBirdProp.handles.ba_rod,'string',HotBirdProp.optimize.ba_rod);

HotBirdProp.optimize.sel_rods_checkbox=get(HotBirdProp.handles.sel_rods_checkbox,'value');
% HotBirdProp.optimize.fuel_rod=get(HotBirdProp.handles.fuel_rod,'string');
% set(HotBirdProp.handles.fuel_rod,'string',HotBirdProp.optimize.fuel_rod);

HotBirdProp.optimize.aut_ba_rod_checkbox=get(HotBirdProp.handles.aut_ba_rod_checkbox,'value');

HotBirdProp.ba_rod = get(HotBirdProp.handles.ba_rod_checkbox,'value');
HotBirdProp.plr_rod = get(HotBirdProp.handles.plr_rod_checkbox,'value');
HotBirdProp.corner_rod = get(HotBirdProp.handles.corner_rod_checkbox,'value');
HotBirdProp.aut_ba_rod = get(HotBirdProp.handles.aut_ba_rod_checkbox,'value');
HotBirdProp.sel_rods = get(HotBirdProp.handles.sel_rods_checkbox,'value');



ba_value=0;
plr_value=0;
corner_value=0;

for k=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(k).ba_tmol = 0;
    HotBirdProp.cs.s(k).plr_tmol = 0;
    HotBirdProp.cs.s(k).corner_tmol = 0;
end
if (HotBirdProp.ba_rod == 1)
    Str = get(HotBirdProp.handles.ba_rod,'string');
    ba_value = sscanf(Str,'%f');
    for k=1:HotBirdProp.cs.cnmax
        HotBirdProp.cs.s(k).ba_tmol = 1;
    end
end
if (HotBirdProp.plr_rod == 1)
    Str = get(HotBirdProp.handles.plr_rod,'string');
    plr_value = sscanf(Str,'%f');
    for k=1:HotBirdProp.cs.cnmax
        HotBirdProp.cs.s(k).plr_tmol = 1;
    end
end
if (HotBirdProp.corner_rod == 1)
    HotBirdProp.optimize.corner_rod = get(HotBirdProp.handles.corner_rod,'string');
    corner_value = sscanf(HotBirdProp.optimize.corner_rod,'%f');
    for k=1:HotBirdProp.cs.cnmax
        HotBirdProp.cs.s(k).corner_tmol = 1;
    end
end

if (HotBirdProp.aut_ba_rod == 1)
    for k=1:HotBirdProp.cs.cnmax
        HotBirdProp.cs.s(k).aut_ba = 1;
    end
else
    for k=1:HotBirdProp.cs.cnmax
        HotBirdProp.cs.s(k).aut_ba = 0;
    end
end


if (HotBirdProp.sel_rods == 1)
    for k=1:HotBirdProp.cs.cnmax
        HotBirdProp.cs.s(k).sel_rods = 1;
    end
else
    for k=1:HotBirdProp.cs.cnmax
        HotBirdProp.cs.s(k).sel_rods = 0;
    end
end




for m=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(m).calc_powl(1+ba_value/100, 1+plr_value/100, 1+corner_value/100, HotBirdProp.cs.s(m).ba_tmol, HotBirdProp.cs.s(m).plr_tmol, HotBirdProp.cs.s(m).corner_tmol);
end
calc_powp([],[],hfig);
set(hfig,'userdata',HotBirdProp);
end



function set_max_burnup(src,~,hfig)

HotBirdProp=get(hfig,'userdata');

HotBirdProp.optimize.max_burnup=get(HotBirdProp.handles.max_burnup,'string');

HotBirdProp.optimize.xtimes = get(src,'string');
for m=1:HotBirdProp.cs.cnmax
    HotBirdProp.cs.s(m).max_burnup = sscanf(HotBirdProp.optimize.xtimes,'%f');
end
calc_powp([],[],hfig);
set(hfig,'userdata',HotBirdProp);
end


function max_corner_fint(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

HotBirdProp.cs.max_corner_fint();
set(hfig,'userdata',HotBirdProp);
end


function max_corner_tmol(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

HotBirdProp.cs.max_corner_tmol();
set(hfig,'userdata',HotBirdProp);
end

