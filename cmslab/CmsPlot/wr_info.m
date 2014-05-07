%
function wr_info

cmsplot_prop=get(gcf,'userdata');
handles=cmsplot_prop.handles;

cmax=cmsplot_prop.scale_max;
cmin=cmsplot_prop.scale_min;

epsi=1.0d-4*(cmax-cmin);
cmax=cmax+epsi;
cmin=cmin-epsi;

uiwait(msgbox('Left click to select, right click to quit'));

button=1;
plmat=get(handles(10,2),'cdata');
fprintf('\n')

readdata =  ReadCore(cmsplot_prop.coreinfo,{'thermal hyd','ASSEMBLY LABELS'},cmsplot_prop.state_point);
A_wr=readdata.thermalhyd.A_wr;
mminj=cmsplot_prop.core.mminj;
Ph_wr=readdata.thermalhyd.Ph_wr;
Dhy_wr=readdata.thermalhyd.Dhy_wr;
serial=readdata.assemblylabels.ser;
nhyd=readdata.thermalhyd.nhyd;
lab=readdata.assemblylabels.lab;
clmap=cmsplot_prop.colormap;
Kin_wr=readdata.thermalhyd.Kin_wr;
Kex_wr=readdata.thermalhyd.Kex_wr;
knum=cmsplot_prop.core.knum;
nod=eval([cmsplot_prop.node_plane,';']);
eval([clmap ';']);
ncol=size(colormap,1)-2;

if strcmp(cmsplot_prop.filetype,'.mat'),
    for j=1:length(A_wr),
        A_wr{j}=A_wr{j}*1e4;
        Ph_wr{j}=Ph_wr{j}*1e2;
        Dhy_wr{j}=Dhy_wr{j}*1e2;
    end
end


if cmin<=0,
  i=find(plmat==-1);
end
plmat=(cmax-cmin)/ncol*(plmat-2)+cmin;
if cmin<=0,
  plmat(i)=zeros(size(i));
end
i=0;
fprintf('%s','Nhyd  Serial   Label  ');
for j=1:length(A_wr),
    fprintf('%s%i%s%i%s%i%s%i%s%i','A_wr',j,'  Dh_wr',j,' Ph_wr',j,' Kin_wr',j,' Kex_wr',j)
end
fprintf('%s',' Position Channel  Plotvalue');
fprintf('\n')
while button==1
 [xx,yy,button]=ginput(1);
  if button==1
    i=i+1;
    if i>20,
      fprintf('\n');

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
      knm=knum==knm0;
%       knm=knm(1);
      ser=serial(knm);
      labl=lab(knm);
      if iscell(labl), labl = labl{1}; end
      if iscell(ser), ser = ser{1}; end
      fprintf('%3i %8s %8s',nhyd(knm),ser,labl);
      for j=1:length(A_wr),
        Awr=A_wr{j}(knm);
        Dhywr=Dhy_wr{j}(knm);
        Phwr=Ph_wr{j}(knm);
        Kinwr=Kin_wr{j}(knm);
        Kexwr=Kex_wr{j}(knm);
        fprintf('%6.2f %6.2f %6.2f  %6.1f %6.1f ',Awr,Dhywr,Phwr,Kinwr,Kexwr);
      end
      fprintf('%s%2i%s%2i%s%7i%11.4g','  (',ny,',',nx,')',knm,co);
      fprintf('\n')
    end
  end
end
disp(sprintf('\n'));

