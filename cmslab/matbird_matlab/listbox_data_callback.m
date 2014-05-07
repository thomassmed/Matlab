function listbox_data_callback(varargin)

hfig=gcf;
hObj=varargin{1};
PowProp=get(hObj,'userdata');
HotBirdProp=get(hfig,'userdata');
cn=HotBirdProp.cn;
axes(HotBirdProp.handles.patron);

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
end

axes(HotBirdProp.handles.patron);
ival=get(hObj,'Value');
ipin=PowProp.isort(ival);
ij=PowProp.ij(ipin,:);


if(HotBirdProp.cs.s(cn).enr(ij(1),ij(2)))
    rectangle('Position',[ij(2)-0.4, ij(1)-0.4, 0.8, 0.8], 'LineWidth',3);
end

set(hfig,'userdata',HotBirdProp);

end