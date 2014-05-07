function  kinf_env_callback(src,~,hfig)

HotBirdProp=get(hfig,'userdata');
HotBirdProp.kinf_env = get(src,'value');
HotBirdProp.cs.calc_u235();
HotBirdProp.cs.calc_btfax();
HotBirdProp.cs.calc_btfax_env();
set(hfig,'userdata',HotBirdProp);
end