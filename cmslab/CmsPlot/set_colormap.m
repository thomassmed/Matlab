% set_colormap selects colormap
%
function set_colormap(clmap)
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
p=clmap;
iflip=findstr('flipud',cmsplot_prop.colormap);
if ~isempty(iflip), % add flipud
    p=remblank(p);
    p=['flipud(',p,')'];
end
cmsplot_prop.colormap=p;
set(hfig,'userdata',cmsplot_prop);
cmsplot_now;
