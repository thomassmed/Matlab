function update_shuffles(hfig,refufile)

% Set default enable status
set(findobj(hfig,'Tag','UndoButton'),'Enable','off');

if exist(refufile,'file')
    refu=load(refufile);
    shuffles=refu.shuffles;
    
    set(findobj(hfig,'Tag','ShuffleList'),'Data',[]);
    
    if ~isempty(shuffles)
        set(findobj(hfig,'Tag','UndoButton'),'Enable','on');

        [asytyp,mminj]=readdist7(refu.bocfile,'ASYTYP');
        khot=readdist7(refu.bocfile,'KHOT');
        
        ops=1;
        data={};
        
        shufflesind=find(shuffles(1,:)==0);
        for i=1:length(shufflesind)
            ind=shufflesind(i)+2;
            
            while ind<=size(shuffles,2) && shuffles(1,ind)>0
                % Create operations
                
                if refu.symmetry==1 % Full core
                    from_pos=shuffles(:,ind-1);
                    to_pos=shuffles(:,ind);
                    
                    from_knum=cpos2knum(from_pos(1),from_pos(2),mminj);
                    to_knum=cpos2knum(to_pos(1),to_pos(2),mminj);
                    
                    data{ops,1}=[num2str(from_pos(1)) ' ' num2str(from_pos(2))];
                    data{ops,2}=asytyp(from_knum,:);
                    data{ops,3}=sprintf('%1.5f',khot(from_knum));
                    data{ops,4}=[num2str(to_pos(1)) ' ' num2str(to_pos(2))];
                    data{ops,5}=asytyp(to_knum,:);
                    data{ops,6}=sprintf('%1.5f',khot(to_knum));
                    
                    ops=ops+1;
                end
                
                if refu.symmetry==3 % Half core rot
                    [right,left]=knumhalf(mminj);
                    
                    % Right half
                    from_pos=shuffles(:,ind-1);
                    to_pos=shuffles(:,ind);
                    from_knum=cpos2knum(from_pos(2),from_pos(1),mminj);
                    to_knum=cpos2knum(to_pos(2),to_pos(1),mminj);
                    
                    data{ops,1}=[num2str(from_pos(1)) ' ' num2str(from_pos(2))];
                    data{ops,2}=asytyp(from_knum,:);
                    data{ops,3}=sprintf('%1.5f',khot(from_knum));
                    data{ops,4}=[num2str(to_pos(1)) ' ' num2str(to_pos(2))];
                    data{ops,5}=asytyp(to_knum,:);
                    data{ops,6}=sprintf('%1.5f',khot(to_knum));
                    
                    ops=ops+1;
                    
                    % Left half
                    from_knum_left=left(find(right==from_knum));
                    to_knum_left=left(find(right==to_knum));
                    from_pos_left=knum2cpos(from_knum_left,mminj);
                    to_pos_left=knum2cpos(to_knum_left,mminj);
                    
                    data{ops,1}=[num2str(from_pos_left(1)) ' ' num2str(from_pos_left(2))];
                    data{ops,2}=asytyp(from_knum_left,:);
                    data{ops,3}=sprintf('%1.5f',khot(from_knum_left));
                    data{ops,4}=[num2str(to_pos_left(1)) ' ' num2str(to_pos_left(2))];
                    data{ops,5}=asytyp(to_knum_left,:);
                    data{ops,6}=sprintf('%1.5f',khot(to_knum_left));
                    
                    ops=ops+1;
                end
                
                ind=ind+1;
            end
        end
        
        set(findobj(hfig,'Tag','ShuffleList'),'Data',data);
    end
    
end