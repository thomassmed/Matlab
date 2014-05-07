function mickey_patron(~,~,hfig)
HotBirdProp=get(hfig,'userdata');

if (HotBirdProp.button ~= 6)
    cn=HotBirdProp.cn;
    axes(HotBirdProp.handles.patron);
    pt = get(HotBirdProp.handles.patron, 'CurrentPoint');
    i=round(pt(1,2));
    j=round(pt(1,1));
    
    [~,cnmax] = size(HotBirdProp.cs.s);
    sel_typ = get(hfig,'SelectionType');
    switch sel_typ
        case 'extend'
            %disp('User clicked middle-mouse button')
            if (HotBirdProp.button ~= 5 && HotBirdProp.button ~= 7 && HotBirdProp.button ~= 8)
                for k=1:cnmax
                    if(HotBirdProp.axial_change(k) ==1)
                        HotBirdProp.cs.s(k).decrease_enr(i,j);
                        if (HotBirdProp.button ~= 1)
                            HotBirdProp.cs.s(k).bigcalc();
                        end
                    end
                end
            end
            
            if (HotBirdProp.button == 1)
                paint_patron([],[],hfig);
            elseif (HotBirdProp.button == 2)
                paint_pow([],[],hfig);
            elseif (HotBirdProp.button == 3)
                paint_exp([],[],hfig);
            elseif (HotBirdProp.button == 4)
                paint_btf([],[],hfig);
            elseif (HotBirdProp.button == 5)
                HotBirdProp.cs.decrease_btfp(i,j);
                paint_btfp([],[],hfig);
            elseif (HotBirdProp.button == 8)
                for k=1:cnmax
                    if(HotBirdProp.axial_change(k) ==1)
                        HotBirdProp.cs.s(k).decrease_tmol(i,j);
                    end
                end
                paint_tmol([],[],hfig);
            end            %set(src,'Selected','on')
            
        case 'normal'
            %disp('User clicked left-mouse button')
            if (HotBirdProp.button == 1)
                paint_patron([],[],hfig);
                axes(HotBirdProp.handles.patron);
                rectangle('Position',[j-0.4, i-0.4, 0.8, 0.8], 'LineWidth',3);
            elseif (HotBirdProp.button == 2)
                paint_pow([],[],hfig);
                axes(HotBirdProp.handles.patron);
                rectangle('Position',[j-0.4, i-0.4, 0.8, 0.8], 'LineWidth',3);
            elseif (HotBirdProp.button == 3)
                paint_exp([],[],hfig);
                axes(HotBirdProp.handles.patron);
                rectangle('Position',[j-0.4, i-0.4, 0.8, 0.8], 'LineWidth',3);
            elseif (HotBirdProp.button == 4)
                paint_btf([],[],hfig);
                axes(HotBirdProp.handles.patron);
                rectangle('Position',[j-0.4, i-0.4, 0.8, 0.8], 'LineWidth',3);
            elseif (HotBirdProp.button == 5)
                HotBirdProp.cs.increase_btfp(i,j);
                paint_btfp([],[],hfig);
                axes(HotBirdProp.handles.patron);
                rectangle('Position',[j-0.4, i-0.4, 0.8, 0.8], 'LineWidth',3);
            end
            
            PowProp=get(HotBirdProp.handles.data_listbox,'userdata');
            knum=cpos2knum(i,j,ones(HotBirdProp.cs.s(cn).npst,1));
            
            k=1;
            while k < HotBirdProp.cs.s(cn).npst*HotBirdProp.cs.s(cn).npst && (PowProp.isort(k) ~= knum)
                k=k+1;
            end
            
            set(HotBirdProp.handles.data_listbox,'ListboxTop',k);
            set(HotBirdProp.handles.data_listbox,'Value',k)
            
        case 'alt'
            %disp('User clicked right-mouse button')
            if (HotBirdProp.button ~= 5 && HotBirdProp.button ~= 7 && HotBirdProp.button ~= 8)
                for k=1:cnmax
                    if(HotBirdProp.axial_change(k) ==1)
                        HotBirdProp.cs.s(k).increase_enr(i,j);
                        if (HotBirdProp.button ~= 1)
                            HotBirdProp.cs.s(k).bigcalc();
                        end
                    end
                end
            end
            
            if (HotBirdProp.button == 1)
                paint_patron([],[],hfig);
            elseif (HotBirdProp.button == 2)
                paint_pow([],[],hfig);
            elseif (HotBirdProp.button == 3)
                paint_exp([],[],hfig);
            elseif (HotBirdProp.button == 4)
                paint_btf([],[],hfig);
            elseif (HotBirdProp.button == 5)
                HotBirdProp.cs.increase_btfp(i,j);
                paint_btfp([],[],hfig);
            elseif (HotBirdProp.button == 8)
                for k=1:cnmax
                    if(HotBirdProp.axial_change(k) ==1)
                        HotBirdProp.cs.s(k).increase_tmol(i,j);
                    end
                end
                paint_tmol([],[],hfig);
            end
            
            HotBirdProp=data_slider(HotBirdProp);
    end
end
