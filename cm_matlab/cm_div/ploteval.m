%@(#)   ploteval.m 1.5	 06/05/31     15:22:54
%
%function ploteval(unit,cycles,yc,efphc,y,efph,ylab,ax)
%Plots the result of output from evalpolca
%
%
function ploteval(unit,cycles,yc,efphc,y,efph,ylab,ax)
ic=length(efphc);
if nargin<7, ylab=' ';end
figure;
efphc=[efphc,max(efph)];
plot(efph,y,'x');
hold on
if ~(length(yc)==1&yc==0),
  stairs(efphc,[yc(:,1);yc(ic,1)]);
end
set(gcf,'papertype','A4');
set(gcf,'paperposition',[0.62 .62 25  20]);
set(gcf,'paperor','landscape');
if nargin>7,
  axis(ax);
end
a=axis;
yt=.95*a(3)+.05*a(4);
for i=1:ic,
  plot([efphc(i) efphc(i)],[a(3) a(4)],':');
  text(.8*efphc(i)+.2*efphc(i+1),yt,remblank(cycles(i,:)));
end
axis(a);
yt=get(gca,'ytick');
for i=1:length(yt),
  plot(a(1:2),[yt(i) yt(i)],':');
end
ylabel(ylab);
xlabel('EFPH');
hold off
title([upper(unit),'  CASMO4/POLCA7'])
set(get(gca,'title'),'fontsize',14);
