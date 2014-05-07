function mickey_pool(~,~,hfig)

CmsCoreProp=get(hfig,'userdata');
axes(CmsCoreProp.handles.pool_axes);

% global knum;

pt = get(CmsCoreProp.handles.pool_axes, 'CurrentPoint');
i=round(pt(1,2));
j=round(pt(1,1));


knum_pool=cpos2knum(i,j,CmsCoreProp.pool.mminj);

if (knum_pool && CmsCoreProp.pool.s(knum_pool).color > 1)
    %     set(hfig,'userdata',CmsCoreProp);
    %     paint_core([],[],hfig);
    sel_typ = get(hfig,'SelectionType');
    switch sel_typ
        case 'extend'
            %             disp('User clicked middle-mouse button')
            
        case 'normal'
            %             disp('User clicked left-mouse button')

            CmsCoreProp.pool_i=[];
            CmsCoreProp.pool_j=[];
            
            CmsCoreProp.pool_i(1)=round(pt(1,2));
            CmsCoreProp.pool_j(1)=round(pt(1,1));

            set(hfig,'userdata',CmsCoreProp);
            paint_pool([],[],hfig);

%             rectangle('Position',[CmsCoreProp.pool_j(1)-0.3, CmsCoreProp.pool_i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_pool,hfig});

            set(CmsCoreProp.handles.poolbur_listbox, 'value',knum_pool, 'ListboxTop',1);

        case 'alt'
            %             disp('User clicked right-mouse button')

    end
    
    set(hfig,'userdata',CmsCoreProp);
end

end
