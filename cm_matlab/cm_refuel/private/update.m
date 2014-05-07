% Open refuel file
function update(hObject,eventdata)

hfig=gcf;
hpar=get(hfig,'UserData');

refufile=get(findobj(hfig,'Tag','RefufileEdit'), 'String');

% Set default enable status
set(findobj(hfig,'Tag','MoveButton'),'Enable','off');
set(findobj(hfig,'Tag','MoveinFreshButton'),'Enable','off');
set(findobj(hfig,'Tag','ClearButton'),'Enable','off');
set(findobj(hfig,'Tag','RefuelButton'),'Enable','off');

if exist(refufile,'file')        
    set(findobj(hfig,'Tag','MoveButton'),'Enable','on');
    set(findobj(hfig,'Tag','MoveinFreshButton'),'Enable','on');
    set(findobj(hfig,'Tag','ClearButton'),'Enable','on');
    set(findobj(hfig,'Tag','RefuelButton'),'Enable','on');
    
    refu=load(refufile);
       
    if exist(refu.bocfile,'file') && exist(refu.eocfile,'file')
        [bocbuid,mminj]=readdist7(refu.bocfile,'ASYID');
        eocbuid=readdist7(refu.eocfile,'ASYID');
        bocburn=readdist7(refu.bocfile,'BURNUP');
        
        freshload=refu.freshload;
        poolload=refu.poolload;
        shuffles=refu.shuffles;
        
        sym=refu.symmetry;
        [right,left]=knumhalf(mminj);
        
        je=mbucatch(bocbuid,eocbuid);
        jb=1:size(bocbuid,1);
        
        % Uppdatera statistik (GUI)
        numfr=length(find(mean(bocburn==0)));
        numre=length(find(je==0))-numfr;
        nummo=length(find((je==jb')==0))-numfr-numre;
        
        set(findobj(hfig,'Tag','FreshStat'),'string',sprintf('Fresh: %3i',numfr))
        set(findobj(hfig,'Tag','MovedStat'),'string',sprintf('Moved: %3i',nummo))
        set(findobj(hfig,'Tag','ResinsStat'),'string',sprintf('Reinserted: %3i',numre))
        
        % Markera flyttade (GUI)
        set(hfig,'pointer','arrow')
        figure(hpar)
        ccplot;
        jeb=find(je==jb');
        if ~isempty(jeb)
            crosspos=knum2cpos(jeb,mminj);
            hcross=setcross(crosspos,[.5 .5 .5]);
        end
        
        % Markera färska
        i=find(max(bocburn)==0);
        pixpos=[];
        if ~isempty(i),pixpos=knum2cpos(i,mminj);end
        if ~isempty(pixpos)
            for i=1:length(pixpos)
                p=pixpos(i,:);
                X=[p(2)+.4 p(2)+.6 p(2)+.6 p(2)+.4];
                Y=[p(1)+.4 p(1)+.4 p(1)+.6 p(1)+.6];
                patch(X,Y,'gre');
            end
        end
        
        % Inritning av flaggor
        if ~isempty(refu.optionfile)
            load(refu.optionfile)
            if ~isempty(flag1),setflag(knum2cpos(flag1,mminj),[1 1 1]);end
            if ~isempty(flag2),setflag(knum2cpos(flag2,mminj),[0 0 0]);end
            if ~isempty(asyid)
                setflag(whereis(asyid,bocfile),[.7 .7 .7]);
            end
        end
        
        hold on;
        % Markera ej utförd av laddning färska
        for i=1:length(freshload)
            num=length(freshload(i).ikan);
            ikan=freshload(i).ikan;
            for ii=1:num
                b=knum2cpos(ikan(ii),mminj);
                Y=[b(1) b(1)+.5 b(1)];
                X=[b(2) b(2)+.5 b(2)+1];
                fill(X,Y,[.8 .8 .8])
                if sym==3
                    b=knum2cpos(size(bocburn,1)+1-ikan(ii),mminj);
                    Y=[b(1) b(1)+.5 b(1)];
                    X=[b(2) b(2)+.5 b(2)+1];
                    fill(X,Y,[.8 .8 .8])
                end
            end
        end
        
        % Markera ej utförda återinsättningar
        for i=1:length(poolload)
            ldchan=poolload(i).ldchan;
            
            yx=knum2cpos(ldchan,mminj);
            xx(1)=yx(2);
            yy(1)=yx(1);
            X=[yx(2) yx(2)+1 yx(2)+1];
            Y=[yx(1) yx(1) yx(1)+1];
            patch(X,Y,[1 1 1]*.8);
            if sym==3
                yx=knum2cpos(left(find(right==ldchan)),mminj);
                x=yx(2);y=yx(1);
                X=[x x+.5 x+1];
                Y=[y+1 y+.5 y+1];
                patch(X,Y,[1 1 1]*.8);
            end
        end
        
        % Markera ej utförda skyfflingar
        if ~isempty(shuffles)
            shufflesind=find(shuffles(1,:)==0);
            ops=0;
            for i=1:length(shufflesind)
                ind=shufflesind(i)+2;
                
                nr=1;
                while ind<=size(shuffles,2) && shuffles(1,ind)>0
                    xy1=shuffles(:,ind-1);
                    xy2=shuffles(:,ind);
                    knum1=cpos2knum(xy1(2),xy1(1),mminj);
                    knum2=cpos2knum(xy2(2),xy2(1),mminj);
                    
                    line([xy1(1)+0.5 xy2(1)+0.5],[xy1(2)+0.5 xy2(2)+0.5],...
                        'LineWidth',2,'Color','magenta',...
                        'Marker','o','MarkerSize',8);
                    
                    if ind==shufflesind(i)+2;
                        text(xy1(1),xy1(2)+.5,sprintf('%2i',nr),...
                            'fontsize',10,'color',[1 1 1],...
                            'fontweight','bold');
                        nr=nr+1;
                    end
                    text(xy2(1),xy2(2)+.5,sprintf('%2i',nr),...
                        'fontsize',10,'color',[1 1 1],...
                        'fontweight','bold');
                    
                    ops=ops+1;
                    
                    if sym==3 % Half core rot
                        knum1_l=left(find(right==knum1));
                        knum2_l=left(find(right==knum2));
                        xy1=knum2cpos(knum1_l,mminj);
                        xy2=knum2cpos(knum2_l,mminj);
                        
                        line([xy1(2)+0.5 xy2(2)+0.5],[xy1(1)+0.5 xy2(1)+0.5],...
                            'LineWidth',3,'Color','magenta',...
                            'Marker','o','MarkerSize',8);
                        
                        if ind==shufflesind(i)+2;
                            nr=nr-1;
                            text(xy1(2),xy1(1)+.5,sprintf('%2i',nr),...
                                'fontsize',10,'color',[1 1 1],...
                                'fontweight','bold');
                            nr=nr+1;
                        end
                        text(xy2(2),xy2(1)+.5,sprintf('%2i',nr),...
                            'fontsize',10,'color',[1 1 1],...
                            'fontweight','bold');

                        ops=ops+1;
                    end
                    
                    nr=nr+1;
                    ind=ind+1;
                end
            end
        end
        
        hold off;
    end
end
    
% Update fresh fuel table
update_fresh(hfig,refufile);

% Update pool fuel table
update_pool(hfig,refufile);

% Update shuffles table
update_shuffles(hfig,refufile);


