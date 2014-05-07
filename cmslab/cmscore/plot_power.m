function plot_power(~,~,hfig)


CmsCoreProp=get(hfig,'userdata');



axes(CmsCoreProp.handles.axial_plot_axes);
cla;
hold 'on';

global knum;
global cn;
set(gca,'LineWidth',2);
set(gca,'color',[0.99 0.99 0.99]);
set(gca,'Position',[0.10 0.08 0.85 0.80]);
set(gca,'FontSize',11);
set(gca,'FontWeight', 'bold');

if(get(CmsCoreProp.handles.axial_channel,'value'))
    cc=sprintf('Channel nr %6.0f',knum);
    CmsCoreProp.handles.knum_textbox = annotation(CmsCoreProp.hfig1,'textbox',[.10 .95 .30 .03], ...
        'string',cc,'fontweight','bold','LineStyle','none', 'FontSize', 11);
    set(CmsCoreProp.handles.knum_textbox,'BackgroundColor', [0.97,0.97,0.97]);
    plot(CmsCoreProp.core.s(knum).power(:,:,cn),(1:25)', 'LineWidth',2 );
else
    cc=sprintf('average');
    CmsCoreProp.handles.knum_textbox = annotation(CmsCoreProp.hfig1,'textbox',[.10 .95 .30 .03], ...
        'string',cc,'fontweight','bold','LineStyle','none', 'FontSize', 11);
    set(CmsCoreProp.handles.knum_textbox,'BackgroundColor', [0.97,0.97,0.97]);
    plot(CmsCoreProp.core.power(:,:,cn),(1:25)', 'LineWidth',2 );
    
end

grid on;
xlabel('POW')
ylabel('Axial Node')

end