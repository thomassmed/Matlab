%@(#)   fullcore.m 1.7	 06/01/12     10:26:36
%
function fullcore
distfile=setprop(5);
[dist,mminj]=readdist7(distfile);
l=length(mminj);
x=[1 l];y=[1 l];
xl=fix(min(x));xu=fix(max(x))+1;yl=fix(min(y));yu=fix(max(y))+1;
axis([xl xu yl yu]);
axiss=['[',num2str(xl),' ',num2str(xu),' ',num2str(yl),' ',num2str(yu),']'];
setprop(10,axiss);
xtl=[' ' num2str(xl+1:2:xu-1,'%2i')];
xtlab=[xtl(1:2:length(xtl)-1)' xtl(2:2:length(xtl))'];
set(gca,'xticklabel',xtlab)
set(gca,'xtick',[xl+1.5:2:xu-0.5]);



% don't plot control rod withdrawal
% outside the axis domain

  % first, check which distribution is being plotted
  handles=get(gcf,'userdata');
  hpl=handles(2);
  if gca~=hpl, axes(hpl);end
  ud=get(hpl,'userdata');
  dname=ud(4,:);
  sdmval=(ud(14,:));

%  if ~strcmp(dname(1:3),'SDM')
  if ~findstr('SDM',dname)
    dispcr;
  elseif (strcmp(dname(1:3),'SDM') & ~strcmp(sdmval(1:2),'no'))
    dispsdm;
  end;
