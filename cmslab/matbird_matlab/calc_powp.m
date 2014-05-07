function calc_powp(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
HotBirdProp.cs.calc_powp();
set(hfig,'userdata',HotBirdProp);
end