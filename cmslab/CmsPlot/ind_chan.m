function ind_chan
% ind_chan plots the axial distribution for individual channels choosen by
% the user.
% See also ind_chan_s5
hfig=gcf;

cmsplot_prop=get(hfig,'userdata');
dist=cmsplot_prop.data;
% take care of S5 distributions
if strcmpi(cmsplot_prop.filetype,'.res') && cmsplot_prop.coreinfo.fileinfo.Sim == 5 && (strncmpi('MICRO ',cmsplot_prop.dist_name,6) || strncmpi('SUB ',cmsplot_prop.dist_name,4))
   ind_chan_s5; 
   return;
end
    
if length(size(dist))==3, %check if dist is a 3D variable rather than kmax by kan
    dist=cor3D2dis3(dist,mminj,knum,sym);
end

if min(size(dist))==1,
    msgbox('Axial plots not meaningful for 2-D disttribution','Cancel');
    return;
end

uiwait(msgbox('Left button to select, right to plot'));

handles=cmsplot_prop.handles;

hpl=handles(10,1);
if gca~=hpl, axes(hpl);end


if isfield(cmsplot_prop,'colormap'),
    clmap=cmsplot_prop.colormap;
else
    clmap='jett';
end
dname=cmsplot_prop.dist_name;
Nod=cmsplot_prop.node_plane;
konrod=cmsplot_prop.konrod;

knum=cmsplot_prop.core.knum;
sym=cmsplot_prop.core.sym;
if cmsplot_prop.core.if2x2 == 2
    mminj = cmsplot_prop.core.mminj2x2;
else
    mminj=cmsplot_prop.core.mminj;
end
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

kan=cpos2knum(fix(y),fix(x),mminj);
i=find(Nod==' ');Nod(i)='';
evno=['nod=(',Nod,');'];
eval(evno);
if size(dist,2)==length(konrod),
  x=fix((fix(x)+1)/2);y=fix((fix(y)+1)/2);
  kan=crpos2crnum(y,x,mminj);
  inod=1:length(nod);
  nod=nod(inod(length(nod):-1:1));
end
% TODO: Test for size
eval(['plotdata = dist(',Nod,',kan);']);
plot(plotdata,nod);
inchan_prop.savdat.plotdata = plotdata;
inchan_prop.savdat.plotxlab = kan;
inchan_prop.coreinfo = cmsplot_prop.coreinfo;
set(h_ind_chan,'userdata',inchan_prop);
% evpl=['plot(dist(',Nod,',kan),nod)'];eval(evpl);
eval([clmap,';'])
hold on
lax=axis;
xmin=lax(1)*ones(size(x));xspan=lax(2)-lax(1);
xmax=xmin+xspan/10*ones(size(x));
xx=[xmin xmax];
ymin=lax(3);yspan=lax(4)-ymin;
ymin=ymin+0.2*yspan;
yy=ymin+(0:ll-1)'*yspan*0.7/ll;
yy=[yy yy];
plot(xx',yy')
chpostr=zeros(ll,5);
xst='  ';
yst='  ';
if strcmp(cmsplot_prop.coordinates,'ij')
    for i=1:ll,
      chpostr(i,:)=[sprintf('%2i',fix(y(i))),',',sprintf('%2i',fix(x(i)))];
    end
    text(xx(:,2),yy(:,1),char(chpostr));
else 
    for i=1:ll,
        chpostr(i,:)=[strtrim(cmsplot_prop.axlabels.assemlabs.lab1{fix(y(i))}) ',' strtrim(cmsplot_prop.axlabels.assemlabs.lab2{fix(x(i))})];
    end
    text(xx(:,2),yy(:,1),char(chpostr));
end
hold off
title(dname)
grid
