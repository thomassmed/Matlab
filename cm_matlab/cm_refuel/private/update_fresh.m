function update_fresh(hfig,refufile)

% Set default enable status
set(findobj(hfig,'Tag','EditFreshButton'),'Enable','off');
set(findobj(hfig,'Tag','DelFreshButton'),'Enable','off');
set(findobj(hfig,'Tag','FreshNumberEdit'),'Enable','off');
set(findobj(hfig,'Tag','LoadFreshButton'),'Enable','off');
set(findobj(hfig,'Tag','FreshList'),'Data',{});

if exist(refufile,'file')
    refu=load(refufile);
            
    set(findobj(hfig,'Tag','AddFreshButton'),'Enable','on');
    
    if ~isempty(refu.freshfuel)        
        set(findobj(hfig,'Tag','EditFreshButton'),'Enable','on');
        set(findobj(hfig,'Tag','DelFreshButton'),'Enable','on');
        set(findobj(hfig,'Tag','FreshNumberEdit'),'Enable','on');
        set(findobj(hfig,'Tag','LoadFreshButton'),'Enable','on');
        
        asytyp=readdist7(refu.bocfile,'ASYTYP');
        
        freshfuel=refu.freshfuel;
        freshfuellist=cell(length(freshfuel),1);
        for i=1:length(freshfuel)
           nloaded=length(bucatch(asytyp,freshfuel(i).name));
            
           freshfuellist{i,1}=freshfuel(i).name;
           freshfuellist{i,2}=freshfuel(i).desc;
           freshfuellist{i,3}=nloaded;
           freshfuellist{i,4}=freshfuel(i).nbundles;         
        end
        set(findobj(hfig,'Tag','FreshList'),'Data',freshfuellist);     
    end
    
end