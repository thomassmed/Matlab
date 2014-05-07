function poolbur_listbox_callback(src,~,hfig)

% global knum;

CmsCoreProp=get(hfig,'userdata');
axes(CmsCoreProp.handles.pool_axes);

% toplistvalue=get(CmsCoreProp.handles.poolbur_listbox,'ListboxTop');

ival=get(src,'Value');

CmsCoreProp.pool_j=CmsCoreProp.pool.s(ival).pos(2);
CmsCoreProp.pool_i=CmsCoreProp.pool.s(ival).pos(1);

set(hfig,'userdata',CmsCoreProp);
paint_pool([],[],hfig);

end