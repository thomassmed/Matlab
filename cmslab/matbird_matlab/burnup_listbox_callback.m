function burnup_listbox_callback(src,eventdata,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
point_nr = get(HotBirdProp.handles.burnup_listbox,'Value');
HotBirdProp.cs.s(cn).point_nr = point_nr;

if (HotBirdProp.button == 1)
    paint_patron([],[],hfig);
elseif (HotBirdProp.button == 2)
    paint_pow([],[],hfig)
elseif (HotBirdProp.button == 3)
    paint_exp([],[],hfig)
elseif (HotBirdProp.button == 4)
    paint_btf([],[],hfig)
elseif (HotBirdProp.button == 8)
    paint_powl([],[],hfig)    
end

bur= HotBirdProp.cs.s(cn).burnup(HotBirdProp.cs.s(cn).point_nr);
burnr= HotBirdProp.cs.s(cn).point_nr;
fint=HotBirdProp.cs.s(cn).fint(burnr);
kinf=HotBirdProp.cs.s(cn).kinf(burnr);

if (HotBirdProp.axial_btf == 1  && HotBirdProp.kinf_env == 0)
    btf=HotBirdProp.cs.maxbtfax(burnr);
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);   
elseif (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
    btf=HotBirdProp.cs.maxbtfax_env;
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);    
elseif (HotBirdProp.axial_btf == 0 && HotBirdProp.kinf_env == 1)
    btf=HotBirdProp.cs.s(cn).maxbtf_env;
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  <btf>=%5.3f',bur,kinf,fint,btf);       
else
    btf=HotBirdProp.cs.s(cn).maxbtf(burnr);
    cc=sprintf('burnup=%4.1f  kinf=%7.5f  fint=%5.3f  btf=%5.3f',bur,kinf,fint,btf);
end

if HotBirdProp.handles.bottom_textbox==0,
    HotBirdProp.handles.bottom_textbox = annotation(hfig,'textbox',[.15 .025 .50 .04], ...
        'LineStyle','none',  'string',cc,'fontweight','bold');
else
    set(HotBirdProp.handles.bottom_textbox,'string',cc);
end

set(HotBirdProp.handles.burnup_slider,'Value',burnr);
HotBirdProp=data_slider(HotBirdProp);
set(hfig,'userdata',HotBirdProp);

end

