% Delete fresh fuel type
function delfresh(hObject,eventdata,hfig)

    refufile=get(findobj(hfig,'Tag','RefufileEdit'), 'String');
    load(refufile,'freshfuel');
    
    selind=get(findobj(hfig,'Tag','FreshList'), 'UserData');
   
    if isempty(selind)
        return;
    end
     
    ind=[1:length(freshfuel)];
    ind=ind~=selind(1);
    freshfuel=freshfuel(ind);
    
    save(refufile, '-append', 'freshfuel');
        
    update_fresh(hfig,refufile);
end
