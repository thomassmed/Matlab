function HotBirdProp=cn_slider_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
[~,cnmax] = size(HotBirdProp.cs.s);

slider_value = round(get(src,'Value'));

if (slider_value > 0 && slider_value <= cnmax)
    HotBirdProp.cn = slider_value;
    cn=HotBirdProp.cn;
    cc=sprintf('Case Number %d',slider_value);
    set(HotBirdProp.handles.cn_textbox,'string',cc);
    bur= HotBirdProp.cs.s(cn).burnup(HotBirdProp.cs.s(cn).point_nr);
    burnr= HotBirdProp.cs.s(cn).point_nr;
    fint=HotBirdProp.cs.s(cn).fint(burnr);
    kinf=HotBirdProp.cs.s(cn).kinf(burnr);
    
    if (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 0)
        btf=HotBirdProp.cs.maxbtfax(burnr);
        cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);
        set(HotBirdProp.handles.bottom_textbox,'string',cc);
    elseif (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
        btf=HotBirdProp.cs.maxbtfax_env;
        cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);
        set(HotBirdProp.handles.bottom_textbox,'string',cc);
    elseif (HotBirdProp.axial_btf == 0 && HotBirdProp.kinf_env == 1)
        btf=HotBirdProp.cs.s(cn).maxbtf_env;
        cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  btf=%5.3f',bur,kinf,fint,btf);
        set(HotBirdProp.handles.bottom_textbox,'string',cc);
    else
        btf=HotBirdProp.cs.s(cn).maxbtf(burnr);
        cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  btf=%5.3f',bur,kinf,fint,btf);
        set(HotBirdProp.handles.bottom_textbox,'string',cc);
    end
    set(HotBirdProp.handles.burnup_slider,'Value',burnr);
    set(HotBirdProp.handles.burnup_listbox,'Value',burnr);
    
    set(hfig,'userdata',HotBirdProp);
    
    if (HotBirdProp.button == 1)
        paint_patron([],[],hfig);
    elseif (HotBirdProp.button == 2)
        paint_pow([],[],hfig);
    elseif (HotBirdProp.button == 3)
        paint_exp([],[],hfig);
    elseif (HotBirdProp.button == 4)
        paint_btf([],[],hfig);
    elseif (HotBirdProp.button == 5)
        paint_btfp([],[],hfig);
    elseif (HotBirdProp.button == 6)
        paint_rod([],[],hfig);
    elseif (HotBirdProp.button == 7)
        paint_powp([],[],hfig);
    elseif (HotBirdProp.button == 8)
        paint_tmol([],[],hfig);        
    end
    
    if (HotBirdProp.casmo_text_fig == 1 && HotBirdProp.cn <= cnmax && ishandle(HotBirdProp.handles.casmo_text_cn));
        ce = sprintf('case nr %d',HotBirdProp.cn);
        set(HotBirdProp.handles.casmo_text_cn,'string',ce);
        ce = sprintf('%s', HotBirdProp.cs.s(HotBirdProp.cn).caifile);
        set(HotBirdProp.handles.casmo_inpfile,'string',ce);
        ce = sprintf('%s', HotBirdProp.cs.s(HotBirdProp.cn).caxfile);
        set(HotBirdProp.handles.casmo_caxfile,'string',ce);
        
        
    end
    
    set(hfig,'Name',HotBirdProp.cs.s(HotBirdProp.cn).caifile);
    
    set(hfig,'userdata',HotBirdProp);
end
end

