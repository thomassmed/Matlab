function move(~,~,hfig)

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

if(min(color(1:length(color)-1)) > 1)
    if(channel(1)==channel(length(channel)))
        for k=1:length(channel)-1
            CmsCoreProp.core.s(channel(k+1)).burnup=reshape(burnup(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).power=reshape(power(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).dens=reshape(dens(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).void=reshape(void(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).evoid=reshape(evoid(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).kinf=reshape(kinf(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).color=color(k);
        end
        set(hfig,'userdata',CmsCoreProp);
        paint_core([],[],hfig);
    else
        for k=1:length(channel)-1
            CmsCoreProp.core.s(channel(k+1)).burnup=reshape(burnup(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).power=reshape(power(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).dens=reshape(dens(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).void=reshape(void(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).evoid=reshape(evoid(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).kinf=reshape(kinf(k,:,:,:),CmsCoreProp.core.kmax,1,length(CmsCoreProp.core.xpo));
            CmsCoreProp.core.s(channel(k+1)).color=color(k);
        end
        
        
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
        paint_core([],[],hfig);
        
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

end

