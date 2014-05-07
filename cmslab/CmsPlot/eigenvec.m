function ind_chan
hfig=gcf;

uiwait(msgbox('Left click to select, right click to plot'));

cmsplot_prop=get(hfig,'userdata');


handles=cmsplot_prop.handles;

hpl=handles(10,1);
if gca~=hpl, axes(hpl);end


clmap=cmsplot_prop.colormap;
dname=cmsplot_prop.dist_name;
Nod=cmsplot_prop.node_plane;
konrod=cmsplot_prop.konrod;
mminj=cmsplot_prop.mminj;
eigvec=cmsplot_prop.eigvec;


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
dist=cmsplot_prop.data;
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


col='bgrcmyk';
ph=cell(length(kan),1);
for i=1:length(kan),
    ph{i}=compass(eigvec(nod,kan(i)),col(mod(i-1,7)+1));
    hold on
end

chpostr=cell(ll,1);
xst='  ';
yst='  ';
for i=1:ll,
  chpostr{i}=[sprintf('%2i',fix(y(i))),',',sprintf('%2i',fix(x(i)))];
  PH(i)=ph{i}(1);
end

legend(PH,chpostr,'location','BestOutside');
hold off
title(dname)
grid
