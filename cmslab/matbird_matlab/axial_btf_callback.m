function  axial_btf_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
HotBirdProp.axial_btf = get(src,'value');
HotBirdProp.cs.calc_u235();
HotBirdProp.cs.calc_btfax();
HotBirdProp.cs.calc_btfax_env();
cc=sprintf('<U235>=%5.3f', HotBirdProp.cs.u235);
set(HotBirdProp.handles.u235_textbox,'string',cc);
set(hfig,'userdata',HotBirdProp);
end