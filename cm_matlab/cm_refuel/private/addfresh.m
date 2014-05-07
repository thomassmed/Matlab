% Add fresh fuel type  
function addfresh(hObject,eventdata,hfig,mode)
    
    refufile=get(findobj(hfig,'Tag','RefufileEdit'), 'String');
    load(refufile,'freshfuel');

    if strcmp(mode,'edit')
        ind=get(findobj(hfig,'Tag','FreshList'), 'UserData');
        data=get(findobj(hfig,'Tag','FreshList'), 'Data');
        
        if isempty(ind)
            return;
        end
        
        asytyp=data{ind,1};
        desc=data{ind,2};
        nbun=data{ind,4};
        
        [answer]=inputdlg({'Name','Description','Nr of bundles'},...
            'Add a new fresh fuel type',1,{asytyp desc num2str(nbun)});
    else
        lastfresh=length(freshfuel);
        ind=lastfresh+1;
        
        [answer]=inputdlg({'Name','Description','Nr of bundles'},...
            'Add a new fresh fuel type');       
    end
    
    % Should check user input here
    if ~isempty(answer)    
        freshfuel(ind).name=strtrim(answer{1});
        freshfuel(ind).desc=strtrim(answer{2});
        freshfuel(ind).nbundles=str2num(strtrim(answer{3}));
    
        save(refufile, '-append', 'freshfuel');
        
        update_fresh(hfig,refufile);
    end
end
