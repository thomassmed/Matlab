function ind_chan_s5
% ind_chan_s5 has the same properties as ind_chan but for S5 files with
% differents size nodes.
% 
% See also ind_chan

% Mikael Andersson 2012-01-11


%% get data from cmsplot
hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
subgeom = cmsplot_prop.subgeom;
core = cmsplot_prop.coreinfo.core;
if core.if2x2 == 2
    mminj = core.mminj2x2;
    knum = core.knum2x2;
else
    mminj = core.mminj;
    knum = core.knum;
end
kmax = cmsplot_prop.core.kmax;

%% loop to choose channels
uiwait(msgbox('Left button to select, right to plot'));
button=1;
i=0;
while button==1
    [xx,yy,button]=ginput(1);
    if button==1
        i=i+1;
        x(i,1)=xx;
        y(i,1)=yy;
        nx=fix(xx);
        ny=fix(yy);
        xl=[nx nx+1;
        nx+1 nx];
        yl=[ny ny;
        ny+1 ny+1];
        hcross(:,i)=line(xl,yl,'color','black','erasemode','none');
    end
end
ll=length(x);
h_ind_chan=figure;
uimenu('label','Export Data','callback','SavedataGUI(0);');
%% get data for choosen channels
knums=cpos2knum(fix(y),fix(x),mminj);
if ~strcmp(cmsplot_prop.coreinfo.core.sym,'full')
    dist = check_dist(cmsplot_prop.data,mminj,knum,core.sym,5);
    datas = dist(knums);
else
    dist = cmsplot_prop.data;
    datas = dist(knums);
end

geoms = subgeom(knums);
indchan_prop.savdat.plotxvar = geoms;
indchan_prop.savdat.plotdata = datas;
indchan_prop.savdat.plotxlab = knums;
indchan_prop.coreinfo = cmsplot_prop.coreinfo;
lengths = cell2mat(cellfun(@length,datas,'UniformOutput',0));
unils = unique(lengths);
%% plot data
xlen = 0;
for i = 1:length(unils)
    logi = unils(i) == lengths; 
    xvar = [datas{logi}];
    yvar = cumsum([geoms{logi}]);
    if max(xvar(:)) < 1
        xlen = max([(max(xvar(:))) xlen]);
    else
        xlen = max([round(max(xvar(:))) xlen]);
    end
    if i == length(unils)
        
        xlen = max([round(max(xvar(:))) xlen]) + xlen/10;
        Xnod = [(zeros(1,kmax))' (ones(1,kmax)*xlen)'];
        Ynod = [(1:kmax)' (1:kmax)']*yvar(end)/kmax;
        [AX,dum,H2] = plotyy(xvar,yvar,Xnod',Ynod');
    else
        plot(xvar,yvar);
    end

    hold all
end
%% fix axes and legends
axtick1 = get(AX(1),'Ytick');
set(AX,'Ytick',[]);
set(AX(1),'Box','Off');
set(AX(1),'Ytick',axtick1);
numm = round(kmax/5);
set(AX(2),'YTick',yvar(end)/numm*(1:numm)-yvar(end)/50)
for i = 1:numm
   tickcell{i} = num2str(5*i);
end
set(AX(2),'YTickLabel',tickcell)
axis(AX,[0 xlen 0 axtick1(end)])
ylabel(AX(1),'Core Heigth');
ylabel(AX(2),'Node Planes');
set(H2,'LineStyle',':','color','b')
for i = 1:length(x), coms(i,:) = ','; end
legend([num2str(fix(x)) coms num2str(fix(y))],'Location','EastOutside')
set(h_ind_chan,'userdata',indchan_prop)












