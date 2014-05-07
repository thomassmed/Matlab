function unload(~,~,hfig)

global cn;
CmsCoreProp=get(hfig,'userdata');

burnup=nan(length(CmsCoreProp.i),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
power=nan(length(CmsCoreProp.i),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
dens=nan(length(CmsCoreProp.i),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
void=nan(length(CmsCoreProp.i),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
evoid=nan(length(CmsCoreProp.i),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
kinf=nan(length(CmsCoreProp.i),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
channel=nan(length(CmsCoreProp.i),1);
color=ones(length(CmsCoreProp.i),1);

for k=1:length(channel)
    channel(k)=cpos2knum(CmsCoreProp.i(k),CmsCoreProp.j(k),CmsCoreProp.core.mminj);
    if(~isempty(CmsCoreProp.core.s(channel(k)).burnup))
        burnup(k,:,:,:)=CmsCoreProp.core.s(channel(k)).burnup;
        power(k,:,:,:)=CmsCoreProp.core.s(channel(k)).power;
        dens(k,:,:,:)=CmsCoreProp.core.s(channel(k)).dens;
        void(k,:,:,:)=CmsCoreProp.core.s(channel(k)).void;
        evoid(k,:,:,:)=CmsCoreProp.core.s(channel(k)).evoid;
        kinf(k,:,:,:)=CmsCoreProp.core.s(channel(k)).kinf;
        color(k)=CmsCoreProp.core.s(channel(k)).color;
    end
end

if(min(color(1:length(color))) > 1)
    
    for k=1:CmsCoreProp.pool.tot_kan
        if(CmsCoreProp.pool.s(k).color == 1)
            kan=k;
            break;
        end
    end
    
    CmsCoreProp.pool.s(kan).burnup=reshape(burnup(length(channel),:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).power=reshape(power(length(channel),:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).dens=reshape(dens(length(channel),:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).void=reshape(void(length(channel),:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).evoid=reshape(evoid(length(channel),:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).kinf=reshape(kinf(length(channel),:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
    CmsCoreProp.pool.s(kan).color=color(length(channel));
    
    CmsCoreProp.pool.calc_number_of_bundles;
    CmsCoreProp.core.s(channel(1)).burnup=[];
    CmsCoreProp.core.s(channel(1)).power=[];
    CmsCoreProp.core.s(channel(1)).dens=[];
    CmsCoreProp.core.s(channel(1)).void=[];
    CmsCoreProp.core.s(channel(1)).evoid=[];
    CmsCoreProp.core.s(channel(1)).kinf=[];
    CmsCoreProp.core.s(channel(1)).color=1;
    
    set(hfig,'userdata',CmsCoreProp);
    
    old_knum=cpos2knum(CmsCoreProp.i(1),CmsCoreProp.j(1),CmsCoreProp.core.mminj);
    col=CmsCoreProp.core.s(old_knum).color;
    rectangle('Position',[CmsCoreProp.j(1)-0.47, CmsCoreProp.i(1)-0.47, 0.94, 0.94], 'LineWidth',1,'ButtonDownFcn',{@mickey_core,hfig},'FaceColor',CmsCoreProp.clmap(col,:),'EdgeColor',CmsCoreProp.clmap(col,:));
    rectangle('Position',[CmsCoreProp.j(1)-0.3, CmsCoreProp.i(1)-0.3, 0.6, 0.6], 'LineWidth',3,'ButtonDownFcn',{@mickey_core,hfig});
    
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
    
    
    if(length(CmsCoreProp.j)>1)
        set(hfig,'userdata',CmsCoreProp);
        paint_core([],[],hfig);
    end
    
    
    %     paint_core([],[],hfig);
    
    if(isfield(CmsCoreProp.handles,'pool_axes') && ishandle(CmsCoreProp.handles.pool_axes))
        paint_pool([],[],hfig);
    end
    
end

CmsCoreProp=get(hfig,'userdata');
CmsCoreProp.i(2:length(CmsCoreProp.i))=[];
CmsCoreProp.j(2:length(CmsCoreProp.j))=[];
CmsCoreProp.nr_points=1;
set(hfig,'userdata',CmsCoreProp);


end

