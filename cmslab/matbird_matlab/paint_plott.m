function paint_plott(~,~,hfig)

HotBirdProp=get(hfig,'userdata');

scrsz = get(0,'ScreenSize');
dM=scrsz(3)*0.05;sidy=scrsz(4)/2;sidx=1.2*sidy;
hfig1 = figure('Position',[scrsz(1)+dM sidy-dM sidx sidy]);
set(hfig1,'Name','Plot');
set(hfig1,'color',[0.99 0.99 0.99]);
set(hfig1,'menubar', 'none');
set(hfig1,'numbertitle', 'off');


% h(1,1)=uimenu('label','Selection');
% h(1,2)=uimenu(h(1,1),'label','kinf', 'callback',{@plot_kinf,hfig1});
% h(1,3)=uimenu(h(1,1),'label','fint', 'callback',{@plot_fint,hfig1});
% h(1,4)=uimenu(h(1,1),'label','oldfint/fint', 'callback',{@plot_oldfint_fint,hfig1});
% h(1,5)=uimenu(h(1,1),'label','btfax', 'callback',{@plot_btf,hfig1});


h_plot(2,1)=uimenu('label','fint', 'callback',{@plot_fint,hfig1});
h_plot(3,1)=uimenu('label','kinf', 'callback',{@plot_kinf,hfig1});
h_plot(4,1)=uimenu('label','old/new fint', 'callback',{@plot_oldfint_fint,hfig1});
h_plot(5,1)=uimenu('label','old/new BTF', 'callback',{@plot_btf,hfig1});



HotBirdProp.plotmap = colormap(plot_jett);

% PlotProp = HotBirdProp;
% PlotProp.handles = h_plot;
HotBirdProp.handles = h_plot;
set(hfig1,'userdata',HotBirdProp);
% set(hfig1,'userdata',PlotProp);
plot_kinf([],[],hfig1);

end


function plot_kinf(~,~,hfig1)

HotBirdProp=get(hfig1,'userdata');

cla;
hold 'on';

set(gca,'LineWidth',2);
set(gca,'color',[0.99 0.99 0.99]);
set(gca,'Position',[0.08 0.08 0.90 0.90]);
set(gca,'FontSize',11);
set(gca,'FontWeight', 'bold');

for k=1:HotBirdProp.cs.cnmax
    plot(HotBirdProp.cs.s(k).burnup,HotBirdProp.cs.s(k).kinf, 'LineWidth',2,'color',HotBirdProp.plotmap(k,:) );
end

for k=1:HotBirdProp.cs.cnmax
    ce=strrep(HotBirdProp.cs.s(k).sim,'SIM','');
    ce=strrep(ce,'''','');
                text(0.85*max(get(gca,'XTick')), min(get(gca,'YTick'))+ (1-0.05*k)*( max(get(gca,'YTick')) -min(get(gca,'YTick')) ), ce,...   
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontWeight', 'bold',...
                    'Backgroundcolor', [0.99 0.99 0.99],...
                    'VerticalAlignment', 'middle',...
                    'color',HotBirdProp.plotmap(k,:),...
                    'HorizontalAlignment', 'left');
end

grid on;
xlabel('MWd/kgU')
ylabel('kinf')

end


function plot_fint(~,~,hfig1)

HotBirdProp=get(hfig1,'userdata');

cla;
hold 'on';

set(gca,'LineWidth',2);
set(gca,'color',[0.99 0.99 0.99]);
set(gca,'Position',[0.075 0.075 0.905 0.905]);
set(gca,'FontSize',11);
set(gca,'FontWeight', 'bold');

for k=1:HotBirdProp.cs.cnmax
    plot(HotBirdProp.cs.s(k).burnup,HotBirdProp.cs.s(k).fint, 'LineWidth',2,'color',HotBirdProp.plotmap(k,:) );
end

for k=1:HotBirdProp.cs.cnmax
    ce=strrep(HotBirdProp.cs.s(k).sim,'SIM','');
    ce=strrep(ce,'''','');
                text(0.85*max(get(gca,'XTick')), min(get(gca,'YTick'))+ (1-0.05*k)*( max(get(gca,'YTick')) -min(get(gca,'YTick')) ), ce,...   
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontWeight', 'bold',...
                    'Backgroundcolor', [0.99 0.99 0.99],...
                    'VerticalAlignment', 'middle',...
                    'color',HotBirdProp.plotmap(k,:),...
                    'HorizontalAlignment', 'left');
end

grid on;
xlabel('MWd/kgU')
ylabel('fint')

end








function plot_oldfint_fint(~,~,hfig1)

HotBirdProp=get(hfig1,'userdata');
cn=HotBirdProp.cn;

cla;
hold 'on';

for k=1:HotBirdProp.cs.cnmax
plot(HotBirdProp.cs.s(k).burnup,HotBirdProp.cs.s(k).oldfint, 'LineWidth',2,'LineStyle','--','color',HotBirdProp.plotmap(k,:));
plot(HotBirdProp.cs.s(k).burnup,HotBirdProp.cs.s(k).fint,'LineWidth',2,'color',HotBirdProp.plotmap(k,:));
end

for k=1:HotBirdProp.cs.cnmax
    ce=strrep(HotBirdProp.cs.s(k).sim,'SIM','');
    ce=strrep(ce,'''','');
                text(0.85*max(get(gca,'XTick')), min(get(gca,'YTick'))+ (1-0.05*k)*( max(get(gca,'YTick')) -min(get(gca,'YTick')) ), ce,...   
                    'Color', 'black',...
                    'FontSize', 10,...
                    'FontWeight', 'bold',...
                    'Backgroundcolor', [0.99 0.99 0.99],...
                    'VerticalAlignment', 'middle',...
                    'color',HotBirdProp.plotmap(k,:),...
                    'HorizontalAlignment', 'left');
end

grid on;
xlabel('MWd/kgU')
ylabel('fint')

end

function plot_btf(~,~,hfig1)

HotBirdProp=get(hfig1,'userdata');
cn=HotBirdProp.cn;

HotBirdProp.cs.calc_btfax();
HotBirdProp.cs.calc_btfax_env();

cla;
hold 'on';

% plot(PlotProp.cs.s(cn).burnup,PlotProp.cs.maxbtfax, 'LineWidth',2);
plot(HotBirdProp.cs.s(cn).burnup,HotBirdProp.cs.oldmaxbtfax, 'LineWidth',2,'LineStyle','--','color',HotBirdProp.plotmap(2,:));
plot(HotBirdProp.cs.s(cn).burnup,HotBirdProp.cs.maxbtfax,'LineWidth',2,'color',HotBirdProp.plotmap(2,:));



grid on;
xlabel('MWd/kgU')
ylabel('Bundle BTF')

end
