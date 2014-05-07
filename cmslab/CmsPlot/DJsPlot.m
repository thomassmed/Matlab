function DJsPlot(opt)
hfig=gcf;
if nargin==0, opt=1;end
cmsplot_prop=get(hfig,'userdata');
dname=cmsplot_prop.dist_name;
cor2d=cmsplot_prop.plotdata;

[ic,jc]=size(cor2d);

figure;
if opt==1, % surf plot with staples
    [x,y,R]=sqblock(cor2d);
    surf(x, y, R');
    title(['surf (staples) for ',dname]);
else
    % surf plot
    surf(cor2d');
    title(['surf (smooth) for ',dname])
end

xlim([0 ic]);
ylim([0 jc]);
colorbar

view(70, 70);