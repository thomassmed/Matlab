% nhydfilt
%
function nhydfilt
hfig=gcf;
cmsplot_prop=get(gcf,'userdata');
nhyd=cmsplot_prop.fue_new.nhyd;
nhyd_ref=unique(nhyd);
winheight=100+size(nhyd_ref,1)*25;
winbottom=870-winheight;
hfilt=figure('position',[5,winbottom,120,winheight]);
%eval(ud(3,:))
for i=1:size(nhyd_ref,1)
  hbun(i)=uicontrol('style','checkbox','string',sprintf('%2i',nhyd_ref(i)),'position',[25 winheight-70-25*i 70 20]);
end
hbut1=uicontrol('style','pushbutton','position',[10 winheight-60 40 30],'string','show','callback','setbunfiltmap(1)');
hbut2=uicontrol('style','pushbutton','position',[70 winheight-60 40 30],'string','hide','callback','setbunfiltmap(0)');

set(handles(22),'userdata',wud)
nhydfilt_prop.filt_hbun=hbun; % Handles to filter-values per nhyd
nhydfilt_prop.hfig=hfig;      % Handle to main cmsplot figure
set(hfilt,'userdata',nhydfilt_prop)
