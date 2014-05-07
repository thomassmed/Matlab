function add_phasors(e_meas,e_mstab,hfig,ii)
if nargin<3,hfig=gcf;end
cmsplot_prop=get(hfig,'userdata');
%%
set_cmsplot_prop('detectors','black');
detpos=sort(cpos2knum(cmsplot_prop.jdet,cmsplot_prop.idet,cmsplot_prop.mminj));
xy=knum2cpos(detpos,cmsplot_prop.mminj);
x=xy(:,2);
y=xy(:,1);
X=nan(size(e_mstab,1),length(x));Y=X;
sca=max(abs(e_meas(:)))/5;
for i=1:length(x),
    X(:,i)=x(i);
    Y(:,i)=y(i);
end
%%
XX=[X(:) X(:)+real(e_mstab(:))/sca];XX=XX';
YY=[Y(:) Y(:)-imag(e_mstab(:))/sca];YY=YY';
h=line(XX,YY);
set(h,'color','black','LineWidth',3.0);
figure(gcf)
%%
XX=[X(:) X(:)+real(e_meas(:))/sca];XX=XX';
YY=[Y(:) Y(:)-imag(e_meas(:))/sca];YY=YY';
h=line(XX,YY);
set(h,'color',[1 1 1],'LineWidth',2.5);
figure(gcf)

if nargin>3
hold on;
plot(mean(XX(2,ii)),mean(YY(2,ii)),'*','erasemode','none','color','black','markersize',15,'LineWidth',2);
ax=axis;
pp=plot(ax(2)-9,ax(4)-1,'*','erasemode','none','color','black','markersize',15,'LineWidth',2);
tt=text(ax(2)-8,ax(4)-1,'- Normalized position');
hold off
end