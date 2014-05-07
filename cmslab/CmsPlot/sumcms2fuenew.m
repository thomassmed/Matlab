function fue_new=sumcms2fuenew(cmsplot_prop)
switch cmsplot_prop.filetype
    case '.sum'
        i=cmsplot_prop.state_point;
        fue_new.burnup=cmsplot_prop.exp2{i};
        fue_new.nfta=cmsplot_prop.nfta;
        fue_new.ser=cmsplot_prop.ser;
        fue_new.lab=cmsplot_prop.lab;
    case '.cms'
        %fue_new=cmsplot_prop.fue_new;
end