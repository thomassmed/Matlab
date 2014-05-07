function reload(~,~,hfig)

global cn;
CmsCoreProp=get(hfig,'userdata');

axes(CmsCoreProp.handles.coremap);

knum=cpos2knum(CmsCoreProp.i(1),CmsCoreProp.j(1),CmsCoreProp.core.mminj);
pool_knum=cpos2knum(CmsCoreProp.pool_i,CmsCoreProp.pool_j,CmsCoreProp.pool.mminj);

if(CmsCoreProp.core.s(knum).color == 1)
    
    CmsCoreProp.core.s(knum).burnup=CmsCoreProp.pool.s(pool_knum).burnup;
    CmsCoreProp.core.s(knum).power=CmsCoreProp.pool.s(pool_knum).power;
    CmsCoreProp.core.s(knum).dens=CmsCoreProp.pool.s(pool_knum).dens;
    CmsCoreProp.core.s(knum).void=CmsCoreProp.pool.s(pool_knum).void;
    CmsCoreProp.core.s(knum).evoid=CmsCoreProp.pool.s(pool_knum).evoid;
    CmsCoreProp.core.s(knum).kinf=CmsCoreProp.pool.s(pool_knum).kinf;
    CmsCoreProp.core.s(knum).color=CmsCoreProp.pool.s(pool_knum).color;
    
    CmsCoreProp.pool.s(pool_knum).burnup=nan(CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(pool_knum).power=nan(CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(pool_knum).dens=nan(CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(pool_knum).void=nan(CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(pool_knum).evoid=nan(CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(pool_knum).kinf=nan(CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    
    CmsCoreProp.pool.s(pool_knum).color=1;
    CmsCoreProp.pool.calc_number_of_bundles;
    
    col=CmsCoreProp.core.s(knum).color;
    rectangle('Position',[CmsCoreProp.j(1)-0.47, CmsCoreProp.i(1)-0.47, 0.94, 0.94], 'LineWidth',1,'ButtonDownFcn',{@mickey_core,hfig},'FaceColor',CmsCoreProp.clmap(col,:),'EdgeColor',CmsCoreProp.clmap(col,:));
    rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig});
    
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
    
else
    
    burnup=nan(2,CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    power=nan(2,CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    dens=nan(2,CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    void=nan(2,CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    evoid=nan(2,CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    kinf=nan(2,CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    color=ones(2,1);
    
    burnup(1,:,:,:)=CmsCoreProp.core.s(knum).burnup;
    power(1,:,:,:)=CmsCoreProp.core.s(knum).power;
    dens(1,:,:,:)=CmsCoreProp.core.s(knum).dens;
    void(1,:,:,:)=CmsCoreProp.core.s(knum).void;
    evoid(1,:,:,:)=CmsCoreProp.core.s(knum).evoid;
    kinf(1,:,:,:)=CmsCoreProp.core.s(knum).kinf;
    color(1)=CmsCoreProp.core.s(knum).color;
    
    burnup(2,:,:,:)=CmsCoreProp.pool.s(pool_knum).burnup;
    power(2,:,:,:)=CmsCoreProp.pool.s(pool_knum).power;
    dens(2,:,:,:)=CmsCoreProp.pool.s(pool_knum).dens;
    void(2,:,:,:)=CmsCoreProp.pool.s(pool_knum).void;
    evoid(2,:,:,:)=CmsCoreProp.pool.s(pool_knum).evoid;
    kinf(2,:,:,:)=CmsCoreProp.pool.s(pool_knum).kinf;
    color(2)=CmsCoreProp.pool.s(pool_knum).color;
    
    CmsCoreProp.pool.s(pool_knum).burnup=[];
    CmsCoreProp.pool.s(pool_knum).power=[];
    CmsCoreProp.pool.s(pool_knum).dens=[];
    CmsCoreProp.pool.s(pool_knum).void=[];
    CmsCoreProp.pool.s(pool_knum).evoid=[];
    CmsCoreProp.pool.s(pool_knum).kinf=[];
    CmsCoreProp.pool.s(pool_knum).color=1;
    
    CmsCoreProp.pool.calc_number_of_bundles;
    
    for k=1:CmsCoreProp.pool.tot_kan
        if(CmsCoreProp.pool.s(k).color == 1)
            kan=k;
            break;
        end
    end
    
    CmsCoreProp.pool.s(kan).burnup=reshape(burnup(1,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).power=reshape(power(1,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).dens=reshape(dens(1,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).void=reshape(void(1,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).evoid=reshape(evoid(1,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).kinf=reshape(kinf(1,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).color=color(1);
    
    CmsCoreProp.core.s(knum).burnup=reshape(burnup(2,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.core.s(knum).power=reshape(power(2,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.core.s(knum).dens=reshape(dens(2,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.core.s(knum).void=reshape(void(2,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.core.s(knum).evoid=reshape(evoid(2,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.core.s(knum).kinf=reshape(kinf(2,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.core.s(knum).color=color(2);
    
    CmsCoreProp.pool.calc_number_of_bundles;
    
    col=CmsCoreProp.core.s(knum).color;
    rectangle('Position',[CmsCoreProp.j(1)-0.47, CmsCoreProp.i(1)-0.47, 0.94, 0.94], 'LineWidth',1,'ButtonDownFcn',{@mickey_core,hfig},'FaceColor',CmsCoreProp.clmap(col,:),'EdgeColor',CmsCoreProp.clmap(col,:));
    rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig});
    
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
    
end


set(hfig,'userdata',CmsCoreProp);

if(length(CmsCoreProp.j)>1)
    CmsCoreProp.i=CmsCoreProp.i(1);
    CmsCoreProp.j=CmsCoreProp.j(1);
    set(hfig,'userdata',CmsCoreProp);
    paint_core([],[],hfig);
end


if(isfield(CmsCoreProp.handles,'pool_axes') && ishandle(CmsCoreProp.handles.pool_axes))
    paint_pool([],[],hfig);
end


end

