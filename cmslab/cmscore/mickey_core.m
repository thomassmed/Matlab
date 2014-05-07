function mickey_core(~,~,hfig)

CmsCoreProp=get(hfig,'userdata');
axes(CmsCoreProp.handles.coremap);

global knum;
global cn;

pt = get(CmsCoreProp.handles.coremap, 'CurrentPoint');
i=round(pt(1,2));
j=round(pt(1,1));

knum=cpos2knum(i,j,CmsCoreProp.core.mminj);

if (knum)
    sel_typ = get(hfig,'SelectionType');
    switch sel_typ
        case 'extend'
            %             disp('User clicked middle-mouse button')
            
            old_knum=cpos2knum(CmsCoreProp.x,CmsCoreProp.y,CmsCoreProp.core.mminj);
            col=CmsCoreProp.core.s(old_knum).color;
            rectangle('Position',[CmsCoreProp.y-0.3, CmsCoreProp.x-0.3, 0.6, 0.6], 'LineWidth',3,'LineStyle','--','EdgeColor',CmsCoreProp.clmap(col,:));
            
            
            if(CmsCoreProp.core.s(old_knum).crd(cn) < CmsCoreProp.core.crdsteps)
                % White CRD rectangles
                crdsteps=CmsCoreProp.core.crdsteps;
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
            end
            
            
            CmsCoreProp.x=round(pt(1,2));
            CmsCoreProp.y=round(pt(1,1));
            set(hfig,'userdata',CmsCoreProp);
            %             paint_core([],[],hfig);
            rectangle('Position',[CmsCoreProp.y-0.3, CmsCoreProp.x-0.3, 0.6, 0.6], 'LineWidth',3,'LineStyle','--');
            
        case 'normal'
            %             disp('User clicked left-mouse button')
            
%             delete(CmsCoreProp.arrow(1:CmsCoreProp.nr_points-1));
%             aaa=CmsCoreProp.arrow;
            
            
            if(CmsCoreProp.button==12)
                if(CmsCoreProp.core.s(knum).zon > 1)
                    CmsCoreProp.core.s(knum).zon=CmsCoreProp.core.s(knum).zon-1;
                    set(hfig,'userdata',CmsCoreProp);
                    col=CmsCoreProp.core.s(knum).zon+1;
                    %                     rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig},'EdgeColor',CmsCoreProp.clmap(col,:));
                    space=0.02;
                    x =[i-0.5+space, i-0.5+1-space,i-0.5+1-space,i-0.5+space];
                    y =[j-0.5+space, j-0.5+space, j-0.5+1-space,j-0.5+1-space];
                    fill(y,x,CmsCoreProp.clmap(col,:),'LineWidth',1,'ButtonDownFcn',{@mickey_core,hfig});
                    rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',1,'ButtonDownFcn',{@mickey_core,hfig},'EdgeColor',[0 0 0]);
                    ce=sprintf('%d',CmsCoreProp.core.s(knum).zon);
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 11,...
                        'FontUnits', 'normalized',...
                        'FontWeight', 'bold',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_core,hfig});
                    
                end
                
                if(CmsCoreProp.core.s(knum).crd(cn) < CmsCoreProp.core.crdsteps)
                    % White CRD rectangles
                    crdsteps=CmsCoreProp.core.crdsteps;
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
                end
                
                %                 paint_core([],[],hfig);
            else
                
                old_knum=cpos2knum(CmsCoreProp.i(1),CmsCoreProp.j(1),CmsCoreProp.core.mminj);
                col=CmsCoreProp.core.s(old_knum).color;
                
                if(length(CmsCoreProp.j)>1)
                    rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig},'EdgeColor',CmsCoreProp.clmap(col,:));
                    CmsCoreProp.i=[];
                    CmsCoreProp.j=[];
                    CmsCoreProp.i(1)=round(pt(1,2));
                    CmsCoreProp.j(1)=round(pt(1,1));
                    CmsCoreProp.nr_points=1;
                    set(hfig,'userdata',CmsCoreProp);
                    paint_core([],[],hfig);
                else
                    rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig},'EdgeColor',CmsCoreProp.clmap(col,:));
                end
                
                
                if(CmsCoreProp.core.s(old_knum).crd(cn) < CmsCoreProp.core.crdsteps)
                    % White CRD rectangles
                    crdsteps=CmsCoreProp.core.crdsteps;
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
                end
                
                
                CmsCoreProp.i=[];
                CmsCoreProp.j=[];
                
                CmsCoreProp.i(1)=round(pt(1,2));
                CmsCoreProp.j(1)=round(pt(1,1));
                CmsCoreProp.nr_points=1;
                set(hfig,'userdata',CmsCoreProp);
                %             paint_core([],[],hfig);
                
                rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig});
                %             rectangle('Position',[CmsCoreProp.j(1)-0.25, CmsCoreProp.i(1)-0.25, 0.5, 0.5], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig},'Curvature',[0.7 0.7]);
                
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
            
        case 'alt'
            %             disp('User clicked right-mouse button')
            
            if(CmsCoreProp.button==12)
                if(CmsCoreProp.core.s(knum).zon < 9)
                    CmsCoreProp.core.s(knum).zon=CmsCoreProp.core.s(knum).zon+1;
                    set(hfig,'userdata',CmsCoreProp);
                    col=CmsCoreProp.core.s(knum).zon+1;
                    space=0.02;
                    x =[i-0.5+space, i-0.5+1-space,i-0.5+1-space,i-0.5+space];
                    y =[j-0.5+space, j-0.5+space, j-0.5+1-space,j-0.5+1-space];
                    
                    fill(y,x,CmsCoreProp.clmap(col,:),'LineWidth',1,'ButtonDownFcn',{@mickey_core,hfig});
                    rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',1,'ButtonDownFcn',{@mickey_core,hfig},'EdgeColor',[0 0 0]);
                    ce=sprintf('%d',CmsCoreProp.core.s(knum).zon);
                    text(j, i, ce,...
                        'Color', 'black',...
                        'FontSize', 11,...
                        'FontUnits', 'normalized',...
                        'FontWeight', 'bold',...
                        'HorizontalAlignment', 'center',...
                        'ButtonDownFcn',{@mickey_core,hfig});
                end
                
                if(CmsCoreProp.core.s(knum).crd(cn) < CmsCoreProp.core.crdsteps)
                    % White CRD rectangles
                    crdsteps=CmsCoreProp.core.crdsteps;
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
                end
                
                %                 paint_core([],[],hfig);
                
            else
                
                ok=1;
                point=zeros(CmsCoreProp.nr_points,2);
                for k=1:CmsCoreProp.nr_points
                    point(k,:,:)=[CmsCoreProp.i(k),CmsCoreProp.j(k)];
                end
                
                if(CmsCoreProp.nr_points > 1)
                    for k=1:CmsCoreProp.nr_points
                        for m=1:CmsCoreProp.nr_points
                            if(min(point(m,:) == point(k,:)) && k ~= m)
                                ok=0;
                                break;
                            end
                        end
                    end
                end
                
                if(ok)
                    CmsCoreProp.nr_points=CmsCoreProp.nr_points+1;
                    CmsCoreProp.i(CmsCoreProp.nr_points)=round(pt(1,2));
                    CmsCoreProp.j(CmsCoreProp.nr_points)=round(pt(1,1));
                    
%                     nr_of_arrows=CmsCoreProp.nr_points-1;
                    for k=1:CmsCoreProp.nr_points-1
                        [h] = arrow([CmsCoreProp.j(k) CmsCoreProp.i(k)],[CmsCoreProp.j(k+1) CmsCoreProp.i(k+1)]);
                        if(k == CmsCoreProp.nr_points-1)
                            CmsCoreProp.arrow(k)=h;
                        end
                    end
                    
                    
                    set(hfig,'userdata',CmsCoreProp);
                end
            end
            
    end
    
    set(hfig,'userdata',CmsCoreProp);
end

end
