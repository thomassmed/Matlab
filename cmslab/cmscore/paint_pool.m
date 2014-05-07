function paint_pool(~,~,hfig)

global cn;
CmsCoreProp=get(hfig,'userdata');

if(isfield(CmsCoreProp.handles,'pool_axes') && ishandle(CmsCoreProp.handles.pool_axes))
    axes(CmsCoreProp.handles.pool_axes);
    
    CmsCoreProp.poolburVal=NaN(CmsCoreProp.pool.tot_kan,1);
    CmsCoreProp.poolburSel=[];
    
    %     for k=1:CmsCoreProp.pool.number_of_bundles
    %     for k=1:CmsCoreProp.pool.tot_kan
    %         CmsCoreProp.poolburVal(k)=mean(CmsCoreProp.pool.s(k).burnup(:,:,1));
    %         CmsCoreProp.poolburSel{k}=round(1000*CmsCoreProp.poolburVal(k))/1000;
    %     end
    
    for k=1:CmsCoreProp.pool.tot_kan
        CmsCoreProp.poolburVal(k)=mean(CmsCoreProp.pool.s(k).burnup(:,:,1));
        if(isnan(CmsCoreProp.poolburVal(k)))
            CmsCoreProp.poolburSel{k}=[];
        else
            CmsCoreProp.poolburSel{k}=round(1000*CmsCoreProp.poolburVal(k))/1000;
        end
    end
    
    
    
    NamesSel=CmsCoreProp.poolburSel;
    set(CmsCoreProp.handles.poolbur_listbox,'string', NamesSel');
    
else
    scrsz=CmsCoreProp.scrsz;
    sidy=scrsz(4)/2;
    sidx=1.2*sidy;
    hfig2=figure('position',[scrsz(4)/1.0 scrsz(3)/12 sidx sidy]);
    set(hfig2,'Name','Pool');
    set(hfig2,'color',[.99 .99 .99]);
    set(hfig2,'Menubar','none');
    set(hfig2,'numbertitle','off');
    set(hfig2,'userdata',CmsCoreProp);
    axes('position',[0.10 0.10 0.80/1.2 0.80]);
    CmsCoreProp.handles.pool_axes=gca;
    
    CmsCoreProp.poolburVal=NaN(CmsCoreProp.pool.tot_kan,1);
    CmsCoreProp.poolburSel=[];
    
    %     for k=1:CmsCoreProp.pool.number_of_bundles
    for k=1:CmsCoreProp.pool.tot_kan
        CmsCoreProp.poolburVal(k)=mean(CmsCoreProp.pool.s(k).burnup(:,:,1));
        if(isnan(CmsCoreProp.poolburVal(k)))
            CmsCoreProp.poolburSel{k}=[];
        else
            CmsCoreProp.poolburSel{k}=round(1000*CmsCoreProp.poolburVal(k))/1000;
        end
    end
    
    NamesSel=CmsCoreProp.poolburSel;
    
    CmsCoreProp.handles.poolbur_listbox=uicontrol (hfig2, 'style', 'listbox', 'Min',0,'Max',CmsCoreProp.pool.tot_kan,'string',NamesSel, ...
        'units','Normalized','position', [0.90 0.09 .10 .70], 'FontSize', 10, 'callback', {@poolbur_listbox_callback,hfig});
    set(CmsCoreProp.handles.poolbur_listbox,'FontWeight', 'bold');
    set(CmsCoreProp.handles.poolbur_listbox,'BackgroundColor', [1,1,0.8]);
    
    
    %%   Move Pushbutton
    CmsCoreProp.handles.reload_button=uicontrol (hfig2, 'style', 'pushbutton', 'string', 'Reload', 'FontWeight','bold', ...
        'units','Normalized','position', [0.80 0.90 .10 .04], 'callback',{@reload,hfig});
    set(CmsCoreProp.handles.reload_button,'BackgroundColor', [0.97,0.97,0.97]);
    set(CmsCoreProp.handles.reload_button, 'FontSize', 11);
    set(CmsCoreProp.handles.reload_button, 'FontUnits', 'normalized');
    set(hfig,'userdata',CmsCoreProp);
    
    
    
end

dist=zeros(20);
plmat=zeros(20);

for k=1:CmsCoreProp.pool.tot_kan
    i=CmsCoreProp.pool.s(k).pos(1);
    j=CmsCoreProp.pool.s(k).pos(2);
    dist(i,j)=mean(CmsCoreProp.pool.s(k).burnup(:,:,cn));
    plmat(i,j)=CmsCoreProp.pool.s(k).color;
end

colormap(jett_core);
image(plmat,'ButtonDownFcn',{@mickey_pool,hfig});


pool_knum=cpos2knum(CmsCoreProp.pool_i,CmsCoreProp.pool_j,CmsCoreProp.pool.mminj);

if(CmsCoreProp.pool.s(pool_knum).color > 1)
    rectangle('Position',[CmsCoreProp.pool_j(1)-0.3, CmsCoreProp.pool_i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig});
end


set(CmsCoreProp.handles.poolbur_listbox,'value',pool_knum);
set(hfig,'userdata',CmsCoreProp);

end
