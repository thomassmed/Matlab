function cn_slider(src,~,hfig)

CmsCoreProp=get(hfig,'userdata');
global cn;
global knum;

slider_value = round(get(src,'Value'));

if (slider_value > 0 && slider_value <= length(CmsCoreProp.core.xpo))
    cn = slider_value;
    paint_core([],[],hfig)
    CmsCoreProp=get(hfig,'userdata');
    
    ce=sprintf('Case Number %d',cn);
    set(CmsCoreProp.handles.cn_textbox,'string', ce);
    
    k=1;
    while k < CmsCoreProp.core.tot_kan && (CmsCoreProp.isort(k) ~= knum)
        k=k+1;
    end
    set(CmsCoreProp.handles.data_listbox, 'value', k, 'ListboxTop',k);
    set(CmsCoreProp.handles.bur_listbox, 'value', k, 'ListboxTop',k);
    
    
    if(isfield(CmsCoreProp.handles,'axial_option_group'))
        if(ishandle(CmsCoreProp.handles.axial_option_group))
            plot_power([],[],hfig);
        end
    end
    
end

set(hfig,'userdata',CmsCoreProp);

end

