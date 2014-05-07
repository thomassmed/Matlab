% cms_flipscale flips scale upside down, toggle
%
function cms_flipscale
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
if isfield(cmsplot_prop,'colormap'),
    p=cmsplot_prop.colormap;
else
    p='jett';
end
iflip=findstr('flipud',p);
if isempty(iflip), % add flipud
    p=['flipud(',p,')'];
else
    p=remblank(p);
    p=strrep(p,'flipud(','');
    iclose=findstr(p,')');
    p(iclose(end))=[];
end
cmsplot_prop.colormap=p;
set(hfig,'userdata',cmsplot_prop);
cmsplot_now;
