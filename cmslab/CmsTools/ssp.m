%%
function ssp
load topo
mrksz=4;
linw=2;
hold off
topo1=[topo(:,190:360) topo(:,1:180)];
contour(-170:180,-89:90,topo1,[0 0],'k')
axis([-160 170 -60 90])
set(gca,'YTicklabel',[]);
set(gca,'XTicklabel',[]);
locE=[16.5  59.6 %Västerås
      16.46  57.27 %Oskarshamn
      10.7  60   %Oslo
      10.0  53.5 %Hamburg
      8.5   47.8 %Baden
      12.25 57.1];%Varberg
hold on
      
tt=plot(locE(:,1),locE(:,2),'rd');
set(tt,'markersize',mrksz);
set(tt,'linewidth',linw);
figure(gcf)
locA=[-72 42 %Boston
      -112 43.5 %Idaho Falls
      -78 34.22 %Wilmington
      -77.2 39.13 %Gaithersburg
      -64.18 -31.4 % Cordoba
      -68.5 -31.5];% San Juan
ttA=plot(locA(:,1),locA(:,2),'rd');
set(ttA,'markersize',mrksz);
set(ttA,'linewidth',linw);
locJ=[139.5 35.68]; % Tokyo
ttJ=plot(locJ(:,1),locJ(:,2),'md');
set(ttJ,'markersize',mrksz);
set(ttJ,'linewidth',linw);
set(gca,'position',[0.01 0.1 .98 .8]);
%set(gcf,'menubar','none');
drawnow
print -dpng sspmap
fprintf(1,'%s\n','The map is printed on the file sspmap.png');
fprintf(1,'%s\n','This file can be imported as a picture to Word, ppt etc');
    