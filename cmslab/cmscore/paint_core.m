function paint_core(src,~,hfig)

CmsCoreProp=get(hfig,'userdata');
global cn;
global knum;
axes(CmsCoreProp.handles.coremap);
reset(gca);

dist=zeros(CmsCoreProp.core.iafull);
crdsteps=CmsCoreProp.core.crdsteps;

%Always Burnup
for k=1:CmsCoreProp.core.tot_kan
    i=CmsCoreProp.core.s(k).pos(1);
    j=CmsCoreProp.core.s(k).pos(2);
    if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
        dist(i,j)=mean(CmsCoreProp.core.s(k).burnup(:,:,cn));
        CmsCoreProp.burVal(k)=mean(dist(i,j));
    elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
        dist(i,j)=max(CmsCoreProp.core.s(k).burnup(:,:,cn));
        CmsCoreProp.burVal(k)=max(dist(i,j));
    elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
        dist(i,j)=min(CmsCoreProp.core.s(k).burnup(:,:,cn));
        CmsCoreProp.burVal(k)=min(dist(i,j));
    elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
        dist(i,j)=CmsCoreProp.core.s(k).burnup(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
        CmsCoreProp.burVal(k)=mean(dist(i,j));
    end
    CmsCoreProp.burSel{k}=round(1000*CmsCoreProp.burVal(k))/1000;
end

if(strcmp(get(src,'string'),'POW'))
    set(CmsCoreProp.handles.sel, 'string', 'POW');
    CmsCoreProp.button = 1;
elseif(strcmp(get(src,'string'),'EVOI'))
    set(CmsCoreProp.handles.sel, 'string', 'EVOI');
    CmsCoreProp.button = 3;
elseif(strcmp(get(src,'string'),'VOID'))
    set(CmsCoreProp.handles.sel, 'string', 'VOID');
    CmsCoreProp.button = 4;
elseif(strcmp(get(src,'string'),'BUR'))
    CmsCoreProp.button = 2;
elseif(strcmp(get(src,'string'),'KINF'))
    set(CmsCoreProp.handles.sel, 'string', 'KINF');
    CmsCoreProp.button = 5;
elseif(strcmp(get(src,'string'),'LHG'))
    set(CmsCoreProp.handles.sel, 'string', 'LHG');
    CmsCoreProp.button = 6;
elseif(strcmp(get(src,'string'),'FLP'))
    set(CmsCoreProp.handles.sel, 'string', 'FLP');
    CmsCoreProp.button = 7;
elseif(strcmp(get(src,'string'),'APL'))
    set(CmsCoreProp.handles.sel, 'string', 'APL');
    CmsCoreProp.button = 8;
elseif(strcmp(get(src,'string'),'FLA'))
    set(CmsCoreProp.handles.sel, 'string', 'FLA');
    CmsCoreProp.button = 9;
elseif(strcmp(get(src,'string'),'SER'))
    set(CmsCoreProp.handles.sel, 'string', 'SER');
    CmsCoreProp.button = 10;
% elseif(strcmp(get(src,'string'),'CPR'))
%     set(CmsCoreProp.handles.sel, 'string', 'CPR');
%     CmsCoreProp.button = 11;
elseif(strcmp(get(src,'string'),'ZON'))
    set(CmsCoreProp.handles.sel, 'string', 'ZON');
    CmsCoreProp.button = 12;
end


if(CmsCoreProp.button == 1)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        
        if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
            dist(i,j)=mean(CmsCoreProp.core.s(k).power(:,:,cn));
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
            dist(i,j)=max(CmsCoreProp.core.s(k).power(:,:,cn));
            CmsCoreProp.SelVal(k)=max(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
            dist(i,j)=min(CmsCoreProp.core.s(k).power(:,:,cn));
            CmsCoreProp.SelVal(k)=min(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
            dist(i,j)=CmsCoreProp.core.s(k).power(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        end
        CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.SelVal,'descend');
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
elseif(CmsCoreProp.button == 3)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        
        if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
            dist(i,j)=mean(CmsCoreProp.core.s(k).evoid(:,:,cn));
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
            dist(i,j)=max(CmsCoreProp.core.s(k).evoid(:,:,cn));
            CmsCoreProp.SelVal(k)=max(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
            dist(i,j)=min(CmsCoreProp.core.s(k).evoid(:,:,cn));
            CmsCoreProp.SelVal(k)=min(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
            dist(i,j)=CmsCoreProp.core.s(k).evoid(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        end
        
        CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.SelVal,'descend');
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
elseif(CmsCoreProp.button == 4)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        
        if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
            dist(i,j)=mean(CmsCoreProp.core.s(k).void(:,:,cn));
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
            dist(i,j)=max(CmsCoreProp.core.s(k).void(:,:,cn));
            CmsCoreProp.SelVal(k)=max(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
            dist(i,j)=min(CmsCoreProp.core.s(k).void(:,:,cn));
            CmsCoreProp.SelVal(k)=min(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
            dist(i,j)=CmsCoreProp.core.s(k).void(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        end
        
        CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.SelVal,'descend');
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
elseif(CmsCoreProp.button == 5)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        
        if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
            dist(i,j)=mean(CmsCoreProp.core.s(k).kinf(:,:,cn));
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
            dist(i,j)=max(CmsCoreProp.core.s(k).kinf(:,:,cn));
            CmsCoreProp.SelVal(k)=max(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
            dist(i,j)=min(CmsCoreProp.core.s(k).kinf(:,:,cn));
            CmsCoreProp.SelVal(k)=min(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
            dist(i,j)=CmsCoreProp.core.s(k).kinf(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        end
        
        CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.SelVal,'descend');
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
elseif(CmsCoreProp.button == 6)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        
        if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
            dist(i,j)=mean(CmsCoreProp.core.s(k).lhg(:,:,cn));
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
            dist(i,j)=max(CmsCoreProp.core.s(k).lhg(:,:,cn));
            CmsCoreProp.SelVal(k)=max(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
            dist(i,j)=min(CmsCoreProp.core.s(k).lhg(:,:,cn));
            CmsCoreProp.SelVal(k)=min(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
            dist(i,j)=CmsCoreProp.core.s(k).lhg(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        end
        
        CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.SelVal,'descend');
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
elseif(CmsCoreProp.button == 7)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        
        if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
            dist(i,j)=mean(CmsCoreProp.core.s(k).flp(:,:,cn));
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
            dist(i,j)=max(CmsCoreProp.core.s(k).flp(:,:,cn));
            CmsCoreProp.SelVal(k)=max(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
            dist(i,j)=min(CmsCoreProp.core.s(k).flp(:,:,cn));
            CmsCoreProp.SelVal(k)=min(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
            dist(i,j)=CmsCoreProp.core.s(k).flp(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        end
        
        CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.SelVal,'descend');
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
elseif(CmsCoreProp.button == 8)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        
        if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
            dist(i,j)=mean(CmsCoreProp.core.s(k).apl(:,:,cn));
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
            dist(i,j)=max(CmsCoreProp.core.s(k).apl(:,:,cn));
            CmsCoreProp.SelVal(k)=max(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
            dist(i,j)=min(CmsCoreProp.core.s(k).apl(:,:,cn));
            CmsCoreProp.SelVal(k)=min(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
            dist(i,j)=CmsCoreProp.core.s(k).apl(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        end
        
        CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.SelVal,'descend');
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
elseif(CmsCoreProp.button == 9)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        
        if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
            dist(i,j)=mean(CmsCoreProp.core.s(k).fla(:,:,cn));
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
            dist(i,j)=max(CmsCoreProp.core.s(k).fla(:,:,cn));
            CmsCoreProp.SelVal(k)=max(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
            dist(i,j)=min(CmsCoreProp.core.s(k).fla(:,:,cn));
            CmsCoreProp.SelVal(k)=min(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
            dist(i,j)=CmsCoreProp.core.s(k).fla(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
            CmsCoreProp.SelVal(k)=mean(dist(i,j));
        end
        
        CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.SelVal,'descend');
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
    
elseif(CmsCoreProp.button == 10)
    
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
            dist(i,j)=mean(CmsCoreProp.core.s(k).burnup(:,:,cn));
            CmsCoreProp.burVal(k)=mean(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
            dist(i,j)=max(CmsCoreProp.core.s(k).burnup(:,:,cn));
            CmsCoreProp.burVal(k)=max(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
            dist(i,j)=min(CmsCoreProp.core.s(k).burnup(:,:,cn));
            CmsCoreProp.burVal(k)=min(dist(i,j));
        elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
            dist(i,j)=CmsCoreProp.core.s(k).burnup(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn);
            CmsCoreProp.burVal(k)=mean(dist(i,j));
        end
        CmsCoreProp.burSel{k}=round(1000*CmsCoreProp.burVal(k))/1000;
        CmsCoreProp.NamesSel{k}=CmsCoreProp.core.s(k).ser;
        
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.burVal,'ascend');
    
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
    
elseif(CmsCoreProp.button == 12)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        
        dist(i,j)=CmsCoreProp.core.s(k).zon;
        CmsCoreProp.SelVal(k)=CmsCoreProp.core.s(k).zon;
        CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
    end
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.SelVal,'descend');
    NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
    
elseif(CmsCoreProp.button == 2)
    
    [~,CmsCoreProp.isort]=sort(CmsCoreProp.burVal,'ascend');
    NamesSel=CmsCoreProp.burSel(CmsCoreProp.isort);
    set(CmsCoreProp.handles.bur_listbox,'string', NamesSel');
    
    if(strcmp(get(CmsCoreProp.handles.sel, 'string'),'POW'))
        for k=1:CmsCoreProp.core.tot_kan
            if (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.mean)
                CmsCoreProp.SelVal(k)=mean(CmsCoreProp.core.s(k).power(:,:,cn));
            elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.max)
                CmsCoreProp.SelVal(k)=max(CmsCoreProp.core.s(k).power(:,:,cn));
            elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.min)
                CmsCoreProp.SelVal(k)=min(CmsCoreProp.core.s(k).power(:,:,cn));
            elseif (get(CmsCoreProp.handles.bgh,'SelectedObject') == CmsCoreProp.handles.axial)
                CmsCoreProp.SelVal(k)=mean( CmsCoreProp.core.s(k).power(round(get(CmsCoreProp.handles_axial_node_slider,'value')),:,cn));
            end
            CmsCoreProp.NamesSel{k}=round(1000*CmsCoreProp.SelVal(k))/1000;
        end
        
        NamesSel=CmsCoreProp.NamesSel(CmsCoreProp.isort);
        set(CmsCoreProp.handles.data_listbox,'string', NamesSel');
    end
    
end


if(strcmp(get(src,'string'),'BUR') || CmsCoreProp.button == 2 || strcmp(get(src,'string'),'SER') || CmsCoreProp.button == 10)
    cmax = max(max(dist));
    cmin = 1;
    ncol = 8;
    plmat=round(abs(ncol*dist/(cmax-cmin)-ncol))+2;
    
    for i = 1 : CmsCoreProp.core.iafull
        for j = 1 : CmsCoreProp.core.iafull
            if(~cpos2knum(i,j,CmsCoreProp.core.mminj))
                plmat(i,j) = 1;
            else
                if(isnan(plmat(i,j)))
                    CmsCoreProp.core.s(cpos2knum(i,j,CmsCoreProp.core.mminj)).color=1;
                else
                    CmsCoreProp.core.s(cpos2knum(i,j,CmsCoreProp.core.mminj)).color=plmat(i,j);
                end
            end
        end
    end
 
elseif(CmsCoreProp.button == 12)

    plmat=round(dist+1);    
    
else
    cmax = max(max(dist));
    
    if(CmsCoreProp.button == 5)
        cmin = 0.9;
    else
        cmin=0;
    end
    
    ncol = 10;
    %     plmat=ncol*dist/(cmax-cmin)-ncol*cmin/(cmax-cmin);
    plmat=round(ncol*dist/(cmax-cmin)-ncol*cmin/(cmax-cmin));
    for i = 1 : CmsCoreProp.core.iafull
        for j = 1 : CmsCoreProp.core.iafull
            if(plmat(i,j) < 2 && plmat(i,j) > 0)
                plmat(i,j) = 2;
            end
        end
    end
end


conrod=zeros(CmsCoreProp.core.irmx);
for k=1:CmsCoreProp.core.tot_crd
    i=CmsCoreProp.core.sc(k).pos(1);
    j=CmsCoreProp.core.sc(k).pos(2);
    conrod(i,j)=CmsCoreProp.core.sc(k).konrod(cn);
    
end

image(plmat,'ButtonDownFcn',{@mickey_core,hfig});
set(gca,'XTick',1:CmsCoreProp.core.iafull);
set(gca,'XAxisLocation','top');

set(gca,'YTick',1:CmsCoreProp.core.iafull);

%     set(gca,'XDir','reverse');

set(gca,'FontWeight','bold');
%     set(gca,'XGrid','on','YGrid','on');

hold on;


%% White space outside bundles

for i = 1 : CmsCoreProp.core.iafull
    for j = 1 : CmsCoreProp.core.iafull
        x = [0 CmsCoreProp.core.iafull+0.5];
        y = [i+0.5 i+0.5];
        line(x,y,'color', [1,1,1]);
        line(y,x,'color', [1,1,1]);
    end
end

%% Black help super cells lines

for k = 1 : CmsCoreProp.core.tot_crd
    x = [0 CmsCoreProp.core.tot_crd];
    y = [2*k+0.5 2*k+0.5];
    line(x,y,'color', [0,0,0]);
    
    y = [0 CmsCoreProp.core.tot_crd];
    x = [2*k+0.5 2*k+0.5];
    line(x,y,'color', [0,0,0]);
end


% Black thick lines outside super cells
for i = 1 : CmsCoreProp.core.irmx
    for j = 1 : CmsCoreProp.core.irmx
        for k=1:CmsCoreProp.core.tot_crd
            if(CmsCoreProp.core.sc(k).pos(2)==i && CmsCoreProp.core.sc(k).pos(1)==j)
                rectangle('Position',[2*i-1-0.5, 2*j-1-0.5, 2, 2], 'LineWidth',2, 'edgecolor', [0,0,0],'ButtonDownFcn',{@mickey_core,hfig});
                break;
            end
        end
    end
end



% Inserted CRD black cross
for k=1:CmsCoreProp.core.tot_crd
    for i = 1 : CmsCoreProp.core.irmx
        for j = 1 : CmsCoreProp.core.irmx
            if(i==CmsCoreProp.core.sc(k).pos(2) && j==CmsCoreProp.core.sc(k).pos(1))
                if(CmsCoreProp.core.sc(k).konrod(cn) < crdsteps)
                    rectangle('Position',[2*i-1-0.2    , 2*j-0.5, 1.4   , 0.05], 'LineWidth',3, 'edgecolor', [0,0,0],'ButtonDownFcn',{@mickey_core,hfig});
                    rectangle('Position',[2*i-0.525, 2*j-1.2  , 0.05,    1.4], 'LineWidth',3, 'edgecolor', [0,0,0],'ButtonDownFcn',{@mickey_core,hfig});
                end
                
            end
        end
    end
end


% White CRD rectangles

for i = 1 : CmsCoreProp.core.irmx
    for j = 1 : CmsCoreProp.core.irmx
        for k=1:CmsCoreProp.core.tot_crd
            if(i==CmsCoreProp.core.sc(k).pos(2) && j==CmsCoreProp.core.sc(k).pos(1) && CmsCoreProp.core.sc(k).konrod(cn) < crdsteps)
                x =[2*i-0.35,2*i-0.35,2*i-1-0.2,2*i-1-0.2];
                x=x+0.25;
                y =[2*j-0.5,2*j-1.2,2*j-1.2,2*j-0.5];
                y=y+0.3;
                fill(x,y,[1.0,1.0,1.0],'LineWidth',1);
                break;
            end
        end
    end
end


% CRD inserted values

if(crdsteps > 100)
    crddiv=10;
else
    crddiv=1;
end


for i = 1 : CmsCoreProp.core.irmx
    for j = 1 : CmsCoreProp.core.irmx
        for k=1:CmsCoreProp.core.tot_crd
            if(i==CmsCoreProp.core.sc(k).pos(2) && j==CmsCoreProp.core.sc(k).pos(1)&&CmsCoreProp.core.sc(k).konrod(cn) < crdsteps)
                ce=sprintf('%d',CmsCoreProp.core.sc(k).konrod(cn)/crddiv);
                text(2*i-0.48, 2*j-0.5, ce,...
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontUnits', 'normalized',...
                    'FontWeight', 'bold',...
                    'HorizontalAlignment', 'center',...
                    'ButtonDownFcn',{@mickey_core,hfig});
                break;
            end
        end
    end
end


if(CmsCoreProp.button==5 || CmsCoreProp.button==12)
    for k=1:CmsCoreProp.core.tot_kan
        i=CmsCoreProp.core.s(k).pos(1);
        j=CmsCoreProp.core.s(k).pos(2);
        ce=sprintf('%d',CmsCoreProp.core.s(k).zon);
        text(j, i, ce,...
            'Color', 'black',...
            'FontSize', 11,...
            'FontUnits', 'normalized',...
            'FontWeight', 'bold',...
            'HorizontalAlignment', 'center',...
            'ButtonDownFcn',{@mickey_core,hfig});
    end
end


rectangle('Position',[CmsCoreProp.y-0.3, CmsCoreProp.x-0.3, 0.6, 0.6], 'LineWidth',3,'LineStyle','--');
rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig});

k=1;
while k < CmsCoreProp.core.tot_kan && (CmsCoreProp.isort(k) ~= knum)
    k=k+1;
end

set(CmsCoreProp.handles.data_listbox, 'value', k);
set(CmsCoreProp.handles.bur_listbox, 'value', k);

set(hfig,'userdata',CmsCoreProp);



end


% function [bun] = is_bundle(i,j,hfig)
%
% CmsCoreProp=get(hfig,'userdata');
% bun=0;
% for k=1:CmsCoreProp.core.tot_kan
%
%     if(CmsCoreProp.core.s(k).pos(1,1)==i && CmsCoreProp.core.s(k).pos(1,2)==j)
%         bun=1;
%         break;
%     end
%
%
% end
%
% end


