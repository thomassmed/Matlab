function cms_applyscale
hwin=gcf;
hs=get(hwin,'userdata');
hfig=hs(4);
cmsplot_prop=get(hfig,'userd');

if hs(3)<0, 
    typ='min';
else
    typ='max';
end
switch typ
    case 'min'
        cmsplot_prop.scale_min=get(hs(2),'value');
    case 'max'
        cmsplot_prop.scale_max=get(hs(2),'value');
end
set(hfig,'userdata',cmsplot_prop);
delete(hwin);
figure(hfig);
cmsplot_now;
