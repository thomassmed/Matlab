function update_pool(hfig,refufile)

% Set default enable status
set(findobj(hfig,'Tag','ReinsertButton'),'Enable','off');
set(findobj(hfig,'Tag','PoolList'),'Data',{});

if exist(refufile,'file')
    refu=load(refufile);
    
    if ~isempty(refu.poolfile) && exist(refu.poolfile,'file')
        set(findobj(hfig,'Tag','ReinsertButton'),'Enable','on');
        
        % Load fuel info from pool
        pool=load(refu.poolfile);
        
        [~,lastcycind]=max(pool.ICYC');
        
        crhis=pool.CRHIS(:,lastcycind);
        onsite=pool.ONSITE;
        
        asyidcore=readdist7(refu.bocfile,'ASYID');
        incoremask=zeros(length(pool.ASYID),1);
        for i=1:length(asyidcore)
            incoreind=strmatch(asyidcore(i,:),pool.ASYID);
            incoremask(incoreind)=1;
        end
        
        mask=onsite & (~incoremask);
        
        asyid=pool.ASYID(mask,:);
        asytyp=pool.ASYTYP(mask,:);
        khot=pool.khot(mask);
        burnup=pool.burnup(mask);
        crhis=crhis(mask);
        lastcyc=pool.lastcyc(mask);
        
        [~,ind]=sort(khot,1,'descend');
        
        data =[cellstr(asyid(ind,:)) ...
            cellstr(asytyp(ind,:)) ...
            cellstr(num2str(khot(ind),'%0.5f')) ...
            cellstr(num2str(burnup(ind),'%5.0f')) ...
            cellstr(num2str(crhis(ind),'%5.1f')) ...
            cellstr(pool.CYCNAM(lastcyc(ind),:))];
        
        set(findobj(hfig,'Tag','PoolList'),'Data',data);
    end
     
end