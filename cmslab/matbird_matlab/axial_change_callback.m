function  axial_change_callback(src,eventdata,hfig)

HotBirdProp=get(hfig,'userdata');
[ignore,cnmax] = size(HotBirdProp.cs.s);

% Selected axial zone 
for i=1:cnmax
    HotBirdProp.axial_checkbox(i)=get(HotBirdProp.handles.axial_checkbox(i),'value');
    set(HotBirdProp.handles.axial_checkbox(i),'value',HotBirdProp.axial_checkbox(i));
    if (src==HotBirdProp.handles.axial_checkbox(i))
        zone=i;
    end
end

HotBirdProp.axial_change(zone) = get(src,'value');

set(hfig,'userdata',HotBirdProp);

end