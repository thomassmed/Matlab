function cms_zoom
    hfig = gcf;
    h = zoom(hfig);
    set(h, 'Enable', 'on', 'ActionPostCallback', @refresh_text_labels);
    
    function refresh_text_labels(obj,evd)
        cmsplot_prop=get(hfig,'userdata');
        handles=cmsplot_prop.handles;
        hpl=handles(10,1);
        curpos_axes = get(hpl,'Position');
        curpos_figure = get(hfig,'Position');

        xlim = get(hpl,'XLim'); ylim = get(hpl,'YLim');
        % determine the "full bundle" limits of the zoom
        alimm = [ceil(xlim(1)) floor(xlim(2))-1 ceil(ylim(1)) floor(ylim(2))-1];

        bundle_width_px = (curpos_figure(3)*curpos_axes(3)) / (alimm(2) - alimm(1));
        bundle_height_px = (curpos_figure(4)*curpos_axes(4)) / (alimm(4) - alimm(3));

        for j = 1:size(cmsplot_prop.label_text, 1)
            for i = 1:size(cmsplot_prop.label_text, 2)
                if (cmsplot_prop.label_text(j,i)) ~= 0
                    if (j >= alimm(3) && j <= alimm(4) && i >= alimm(1) && i<= alimm(2))
                        set(cmsplot_prop.label_text(j,i),...
                            'FontSize', bundle_width_px/6,...
                            'Visible', 'on');
                    else
                        set(cmsplot_prop.label_text(j,i), 'Visible', 'off');
                    end
                end
            end
        end
    end
    
end