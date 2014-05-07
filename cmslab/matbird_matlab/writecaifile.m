function writecaifile(~,~,hfig)

HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
caifile=[HotBirdProp.cs.s(cn).caxfile,'.cai'];
HotBirdProp.cs.s(cn).writecaifile(caifile)
end

