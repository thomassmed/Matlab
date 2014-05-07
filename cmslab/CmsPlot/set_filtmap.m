function set_filtmap(flag)
hfilt=gcf;
filt_prop=get(hfilt,'userdata');
hfig=filt_prop.hfig;       % get handle to cmsplot figure
cmsplot_prop=get(hfig,'userdata');
knum=cmsplot_prop.core.knum;
hbun=filt_prop.hbun;
for i=1:length(hbun)
  val(i)=get(hbun(i),'value');
end
ival=find(val);
switch filt_prop.filter_type,
    case 'nhyd'      
        nhyd_ref=unique(cmsplot_prop.filter.nhyd);
        cmsplot_prop.filter.filt_nhyd=zeros(1,cmsplot_prop.core.kan);
        for i=1:length(ival)
            i_nhyd=filt_prop.filtdat==nhyd_ref(ival(i));
            cmsplot_prop.filter.filt_nhyd(i_nhyd)=1;
        end
        if cmsplot_prop.if2x2 == 2
            cmsplot_prop.filter.filt_nhyd = fill2x2(cmsplot_prop.filter.filt_nhyd,cmsplot_prop.core.mminj,cmsplot_prop.core.knum,'full');
        end
        if flag==0,cmsplot_prop.filter.filt_nhyd=1-cmsplot_prop.filter.filt_nhyd;end
    case 'nfta'
        nfta_ref=unique(cmsplot_prop.filter.nfta);
        cmsplot_prop.filter.filt_nfta=zeros(1,cmsplot_prop.core.kan);
        for i=1:length(ival)
            i_nfta=filt_prop.filtdat==nfta_ref(ival(i));
            cmsplot_prop.filter.filt_nfta(i_nfta)=1;
        end
        if cmsplot_prop.if2x2 == 2
            cmsplot_prop.filter.filt_nfta = fill2x2(cmsplot_prop.filter.filt_nfta,cmsplot_prop.core.mminj,cmsplot_prop.core.knum,'full');
        end
        if flag==0,cmsplot_prop.filter.filt_nfta=1-cmsplot_prop.filter.filt_nfta;end   
    case 'bat'
        bat_ref=unique(cmsplot_prop.filter.bat);
        cmsplot_prop.filter.filt_bat=zeros(1,cmsplot_prop.core.kan);
        for i=1:length(ival)
            i_bat=filt_prop.filtdat==bat_ref(ival(i));
            cmsplot_prop.filter.filt_bat(i_bat)=1;
        end
        if cmsplot_prop.if2x2 == 2
            cmsplot_prop.filter.filt_bat = fill2x2(cmsplot_prop.filter.filt_bat,cmsplot_prop.core.mminj,cmsplot_prop.core.knum,'full');
        end
        if flag==0,cmsplot_prop.filter.filt_bat=1-cmsplot_prop.filter.filt_bat;end   
    case 'label'
        label_ref=unique(cmsplot_prop.fue_new.lab,'rows'); %% TODO: måste fixas, fue_new funkar ej..
        cmsplot_prop.filt_label=zeros(1,cmsplot_prop.kan);
        for i=1:length(ival)
            cmsplot_prop.filter.filt_label(strmatch(label_ref(ival(i),:),cmsplot_prop.fue_new.lab))=1;
        end
        if cmsplot_prop.if2x2 == 2
            cmsplot_prop.filter.filt_label = fill2x2(cmsplot_prop.filter.filt_nfta,cmsplot_prop.core.mminj,cmsplot_prop.core.knum,'full');
        end
        if flag==0,cmsplot_prop.filt_label=1-cmsplot_prop.filt_label;end    
    case 'crods'
        filtdat = filt_prop.filtdat;
        crods_ref = unique(filtdat);
        cmsplot_prop.filter.filt_crods=zeros(size(cmsplot_prop.filter.filt_crods));
        for i = 1:length(ival)
            cmsplot_prop.filter.filt_crods((crods_ref(ival(i)) == filtdat)) =1;
        end
        if flag==0,cmsplot_prop.filter.filt_crods=1-cmsplot_prop.filter.filt_crods;end 
end
cmsplot_prop.rescale='auto';
set(hfig,'userdata',cmsplot_prop);
figure(hfig);
cmsplot_now;