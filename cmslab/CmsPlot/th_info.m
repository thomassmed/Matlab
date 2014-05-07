%
function th_info

hfig=gcf;
cmsplot_prop=get(hfig,'userdata');
handles=cmsplot_prop.handles;

uiwait(msgbox('Left click to select, right click to quit'));

cmax=cmsplot_prop.scale_max;
cmin=cmsplot_prop.scale_min;

epsi=1.0d-4*(cmax-cmin);
cmax=cmax+epsi;
cmin=cmin-epsi;
button=1;
plmat=get(handles(10,2),'cdata');
fprintf('\n')
readdata =  ReadCore(cmsplot_prop.coreinfo,{'thermal hyd','ASSEMBLY LABELS'},cmsplot_prop.state_point);

afuel=readdata.thermalhyd.afuel;
mminj=cmsplot_prop.core.mminj;
dhfuel=readdata.thermalhyd.dhfuel;
phfuel=readdata.thermalhyd.phfuel;
serial=readdata.assemblylabels.ser;
nhyd=readdata.thermalhyd.nhyd;
lab=readdata.assemblylabels.lab;
clmap=cmsplot_prop.colormap;
Xcin=readdata.thermalhyd.Xcin;
vhifuel=readdata.thermalhyd.vhifuel;
vhofuel=readdata.thermalhyd.vhofuel;
orityp=readdata.thermalhyd.orityp;
nod=eval([cmsplot_prop.node_plane,';']);
knum=cmsplot_prop.core.knum;
eval([clmap,';']);
ncol=size(colormap,1)-2;

if strcmp(cmsplot_prop.filetype,'.mat'),
    afuel=afuel*1e4;
    dhfuel=dhfuel*100;
    phfuel=phfuel*100;
end


if cmin<=0,
  i=find(plmat==-1);
end
plmat=(cmax-cmin)/ncol*(plmat-2)+cmin;
if cmin<=0,
  plmat(i)=zeros(size(i));
end
i=0;
fprintf('%s','Nhyd  Serial   Label  Area  HydDia  HeatPer  Vhi   Vho   Xcin orityp Pos.  Channel  Plotvalue')
fprintf('\n')
while button==1
 [xx,yy,button]=ginput(1);
  if button==1
    i=i+1;
    if i>20,
      fprintf('\n');
      fprintf('%s','Nhyd  Serial   Label  Area  HydDia  HeatPer  Vhi  Vho  Xcin  orityp  Channel  Plotvalue');
      fprintf('\n');
      i=0;
    end
    nx=fix(xx);
    ny=fix(yy);
    co=plmat(ny,nx);
    if abs(co)<epsi/2, co=0;end
    knm0=cpos2knum(ny,nx,mminj);
    if knm0==0
      fprintf('%s%2i%s%2i%s','(',ny,',',nx,') is outside core')
      fprintf('\n')
    else
      [knm,jdum]=find(knum==knm0);knm=knm(1);
      Area=round(mean(afuel(nod,knm)));
      Hyddia=mean(dhfuel(nod,knm));
      HeatPer=round(mean(phfuel(:,knm)));
      ser=serial(knm,:);
      labl=lab(knm,:);
      if iscell(labl), labl = labl{1}; end
      if iscell(ser), ser = ser{1}; end
      Vhi=vhifuel(knm);
      Vho=vhofuel(knm);
      
      fprintf('%3i %8s %8s%5i %6.2f  %6i  %5.1f %5.1f %6.1f% 3i  %s%2i%s%2i%s%7i%11.4g',...
          nhyd(knm),ser,labl,Area,Hyddia,HeatPer,Vhi,Vho,Xcin(knm),orityp(knm),'  (',ny,',',nx,')',knm0,co);
      fprintf('\n')
    end
  end
end
disp(sprintf('\n'));

