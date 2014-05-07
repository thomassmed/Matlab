function cms_setscale(typ)
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');

cmin=cmsplot_prop.scale_min;
cmax=cmsplot_prop.scale_max;
hwin=figure('position',[900,700,200,170],'menubar','none');
axes('visible','off')

if isfield(cmsplot_prop,'colormap'),
    clmap=cmsplot_prop.colormap;
else
    clmap='jett';
end
eval(['colormap(',clmap,');']);

hp1=uicontrol('style','pushbutton','position',[10 130 60 30],'string','apply','callback','cms_applyscale');
hp2=uicontrol('style','pushbutton','position',[130 130 60 30],'string','cancel','callback',...
   'h3=get(gcf,''userdata'');cmsplot_prop=get(h3(4),''userdata'');cmsplot_prop.rescale=''no'';delete(gcf)');

switch typ
    case 'min'
        min_slide=cmin-(cmax-cmin);
        max_slide=cmax-0.1*(cmax-cmin);
        minmax_flag=-1;
        start_value=cmin;
        label='Scale min';
    case 'max'
        min_slide=cmin+0.1*(cmax-cmin);
        max_slide=cmax+(cmax-cmin);
        minmax_flag=1;
        start_value=cmax;
        label='Scale max';
end

htext=uicontrol('style','edit','position',[10 80 90 30],'string',num2str(start_value),...
   'callback','hs=get(gcf,''userdata'');htext=hs(1);hsc=hs(2);set(hsc,''value'',str2num(get(htext,''string'')))');
hsc=uicontrol('style','slider','min',min_slide,'max',max_slide,'value',start_value,'position',[10 10 180 30],...
   'callback','hs=get(gcf,''userdata'');htext=hs(1);hsc=hs(2);set(htext,''string'',num2str(get(hsc,''value'')))');
text(0,.2,sprintf('%5.2f',min_slide));
text(0.7,.2,sprintf('%5.2f',max_slide));
hs=[htext hsc minmax_flag hfig]';

set(hwin,'name',label,'numbertitle','off')
cmsplot_prop.rescale='ScaleThenHold';

set(hwin,'userdata',hs)
set(hfig,'userdata',cmsplot_prop);
