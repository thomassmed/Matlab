function Seg_Plot
% Seg_Plot is used to plot the segment of an assembly

% Mikael Andersson 2011-11-28
%% get data from pinplot
pinfig=gcf;
pinplot_prop=get(pinfig,'userdata');
coreinfo = pinplot_prop.coreinfo;
knumuse = pinplot_prop.knumuse;
%% read data needed 
lib = ReadRes(coreinfo,'Library',pinplot_prop.st_pt);
if coreinfo.core.if2x2 == 2
    subnums = convert2x2('2subnum',coreinfo.core.knum,coreinfo.core.mminj,'full');
    [knumuse ~] = find(knumuse == subnums); 
end
segnum1 = lib.Core_Seg{1}(:,knumuse);
segnum2 = lib.Core_Seg{2}(:,knumuse);
Seg_w = lib.Seg_w{1}(:,knumuse);
Segnam = lib.Segment;
%% create new or use current segment plot
scrsz = get(0,'ScreenSize');
dM=scrsz(3)*0.2;
sidy=scrsz(4)/1.7;
sidx=1.2*sidy;
if max(strcmp(fieldnames(pinplot_prop),'hsegplot')) && max(pinplot_prop.hsegplot == findall(0,'type','figure'))
    figure(pinplot_prop.hsegplot)
    segfig = pinplot_prop.hsegplot;
else
    segfig = figure('Position',[scrsz(3)/2 sidy-dM sidx*0.8 sidy*0.7]);
    pinplot_prop.hsegplot = segfig;
    segplot_prop.hsegplot = segfig;
    set(segfig,'userdata',segplot_prop);
end

%% plot the segments
PlotSegData(segnum1,segnum2,Seg_w);
%% create legend
segplot_prop=get(segfig,'userdata');
uni = unique([segnum1 ; segnum2]);
if min(uni) == 0
    uni= uni(2:end);
end
lgstr1 = num2str(Segnam(uni,:));
segleg = legend(lgstr1,'Location','EastOutside');
segplot_prop.segleg = segleg;
set(segfig,'userdata',segplot_prop);
set(gca,'XTick',[0.25 0.75 1.2],'XTickLabel',{'Segment 1','Segment 2', 'Seg. 1 Weight'});
axis([0 1.4 0.5 length(segnum1)+0.5])
%% save data to pinplot
set(pinfig,'userdata',pinplot_prop);

end

