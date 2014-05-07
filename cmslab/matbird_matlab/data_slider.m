function HotBirdProp=data_slider(HotBirdProp,FirstCall,hfig)

if nargin<2, 
    FirstCall=0;
end

cn=HotBirdProp.cn;
npst=HotBirdProp.cs.npst;
point_nr=HotBirdProp.cs.s(cn).point_nr;
NamesSel=cell(npst*npst,1);
SelVal=NaN(npst*npst,1);

if (HotBirdProp.button == 2)
    if(get(HotBirdProp.handles.crd_checkbox,'value') && ~isempty(HotBirdProp.cs.s(cn).pow_crd))
        dist=HotBirdProp.cs.s(cn).pow_crd;
    else
        dist=HotBirdProp.cs.s(cn).pow;
    end
    k=1;
    for i=1:npst
        for j=1:npst
%             tempvalue=HotBirdProp.cs.s(cn).pow(i,j,point_nr);
            tempvalue=dist(i,j,point_nr);
            NamesSel{k}= round(1000*tempvalue)/1000;
            SelVal(k)=tempvalue;
            k=k+1;
        end
    end
elseif (HotBirdProp.button == 8)
    k=1;
    for i=1:npst
        for j=1:npst
            tempvalue=HotBirdProp.cs.s(cn).powl(i,j,point_nr);
            NamesSel{k}= round(1000*tempvalue)/1000;
            SelVal(k)=tempvalue;
            k=k+1;
        end
    end   
elseif (HotBirdProp.button == 3)
    k=1;
    for i=1:npst
        for j=1:npst
            tempvalue=HotBirdProp.cs.s(cn).exp(i,j,point_nr);
            NamesSel{k}= round(1000*tempvalue)/1000;
            SelVal(k)=tempvalue;
            k=k+1;
        end
    end    
elseif (HotBirdProp.button == 4)
    k=1;
    if (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 0)
        for i=1:npst
            for j=1:npst
                tempvalue=HotBirdProp.cs.btfax(i,j,point_nr);
                NamesSel{k}= round(1000*tempvalue)/1000;
                SelVal(k)=tempvalue;
                k=k+1;
            end
        end
    elseif (HotBirdProp.axial_btf == 1 && HotBirdProp.kinf_env == 1)
        for i=1:npst
            for j=1:npst
                tempvalue=HotBirdProp.cs.btfax_env(i,j);
                NamesSel{k}= round(1000*tempvalue)/1000;
                SelVal(k)=tempvalue;
                k=k+1;
            end
        end
    elseif (HotBirdProp.axial_btf == 0 && HotBirdProp.kinf_env == 1)
        if(get(HotBirdProp.handles.crd_checkbox,'value') && ~isempty(HotBirdProp.cs.s(cn).pow_crd))
            dist=HotBirdProp.cs.s(cn).btf_env_crd;
        else
            dist=HotBirdProp.cs.s(cn).btf_env;
        end
        for i=1:npst
            for j=1:npst
                %                 tempvalue=HotBirdProp.cs.s(cn).btf_env(i,j);
                tempvalue=dist(i,j);
                NamesSel{k}= round(1000*tempvalue)/1000;
                SelVal(k)=tempvalue;
                k=k+1;
            end
        end
    else
        if(get(HotBirdProp.handles.crd_checkbox,'value') && ~isempty(HotBirdProp.cs.s(cn).pow_crd))
            dist=HotBirdProp.cs.s(cn).btf_crd;
        else
            dist=HotBirdProp.cs.s(cn).btf;
        end
        for i=1:npst
            for j=1:npst
%                 tempvalue=HotBirdProp.cs.s(cn).btf(i,j,point_nr);
                tempvalue=dist(i,j,point_nr);
                NamesSel{k}= round(1000*tempvalue)/1000;
                SelVal(k)=tempvalue;
                k=k+1;
            end
        end
    end
end



[~,isort]=sort(SelVal,'descend');
NamesSel=NamesSel(isort);

if FirstCall
    HotBirdProp.handles.data_listbox=uicontrol (hfig, 'style', 'listbox', 'Max',100,'string', ...
        NamesSel,'units','Normalized','position', [0.90 0.10 .09 .70],'callback', @listbox_data_callback);
    set(HotBirdProp.handles.data_listbox,'BackgroundColor', [1,1,0.8]);
    set(HotBirdProp.handles.data_listbox,'FontWeight', 'bold');
    set(HotBirdProp.handles.data_listbox,'FontSize',10);
    set(HotBirdProp.handles.data_listbox, 'FontUnits', 'normalized');
else
    set(HotBirdProp.handles.data_listbox,'string',NamesSel);
end
   
PowProp.isort=isort;
PowProp.value=SelVal;
PowProp.NamesSel=NamesSel;
% Vi antar f.n att de aer lagrade radvis
pnr=1:(npst*npst);
mminj=ones(npst,1);
ij=knum2cpos(pnr,mminj);
PowProp.pnr=pnr;
PowProp.ij=ij;
set(HotBirdProp.handles.data_listbox,'userdata',PowProp);
