function set_filter(filter_type)
hfig=gcf;
cmsplot_prop=get(gcf,'userdata');
asmnam = [];
switch filter_type
    case 'nhyd' 
        filtdat=cmsplot_prop.filter.nhyd;
        nhyd_ref=unique(filtdat);
        filt_ref=char(zeros(length(nhyd_ref),2));
        for i=1:length(nhyd_ref),
            filt_ref(i,:)=sprintf('%2i',nhyd_ref(i));
        end
     case 'nfta'
         filtdat=cmsplot_prop.filter.nfta;
         nfta_ref=unique(filtdat);
         filt_ref=char(zeros(length(nfta_ref),2));
         for i=1:length(nfta_ref),
             filt_ref(i,:)=sprintf('%2i',nfta_ref(i));
         end
    case 'bat'
        filtdat=cmsplot_prop.filter.bat;
        bat_ref=unique(filtdat);
        filt_ref=char(zeros(length(bat_ref),2));
        for i=1:length(bat_ref),
            filt_ref(i,:)=sprintf('%2i',bat_ref(i));
        end
    case 'label' % TODO: check this how it should work
        filt_ref=unique(cmsplot_prop.coreinfo.core.lab,'rows');
    case 'crods'
        konrod = cmsplot_prop.konrod;
        crmminj = cmsplot_prop.crmminj;
        mminj = cmsplot_prop.core.mminj;
        crvec = cor2vec(cr2core(konrod,mminj,crmminj,max(max(konrod))),mminj);
        filtdat = crvec;
        unicr = unique(crvec);
        for i = 1:length(unicr)
            filt_ref{i} = num2str(unicr(i));
        end
        filt_ref=char(filt_ref);
end


winheight=100+size(filt_ref,1)*25;
winbottom=870-winheight;
pos_hfig=get(hfig,'position');
offset=-190-length(cmsplot_prop.filter.filt_handles)*155;
posy0=pos_hfig(2)+pos_hfig(4)-winheight+10;
posy0=max(0,posy0);
hfilt=figure('position',[pos_hfig(1)+offset,posy0,170,winheight],'menubar','none');
cmsplot_prop.filter.filt_handles=[cmsplot_prop.filter.filt_handles hfilt];
i_filt=length(cmsplot_prop.filter.filt_handles);
cmsplot_prop.filter.filter_type{i_filt}=filter_type;
set(hfilt,'name',upper(filter_type),'numbertitle','off');
%eval(ud(3,:))
dy=1/(size(filt_ref,1)+3);
for i=1:size(filt_ref,1)
  hbun(i)=uicontrol('style','checkbox','string',filt_ref(i,:),'units','normalized','position',[.1 1-2*dy-dy*i .8 dy]);
end
hbut1=uicontrol('style','pushbutton','units','normalized','position',[.1 1-1.75*dy .3 1.5*dy],'string','show','callback','set_filtmap(1)');
hbut2=uicontrol('style','pushbutton','units','normalized','position',[.6 1-1.75*dy .3 1.5*dy],'string','hide','callback','set_filtmap(0)');

filt_prop.filtdat = filtdat;
filt_prop.hbun=hbun; % Handles to filter-values per nhyd
filt_prop.hfig=hfig;      % Handle to main cmsplot figure
filt_prop.filter_type=filter_type;
set(hfig,'userdata',cmsplot_prop);
set(hfilt,'userdata',filt_prop)
