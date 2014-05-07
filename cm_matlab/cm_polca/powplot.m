%@(#)   powplot.m 1.2	 05/12/08     10:31:36
%
%function powplot(filvec,distname)
function powplot(filvec,distname)
if nargin==1,distname='power';end
ll=size(filvec,1);
nw=ceil(ll/4);
for i=1:nw
  figure
  for j=1:4
    if ll>(i-1)*4+j-1
      subplot(2,2,j)
      filename=filvec((i-1)*4+j,:);
      power=readdist7(filename,distname);
      plot(mean(power'),1:25)
      axis([0 1.5 0 25])
      set(gca,'xtick',[0 .25 .5 .75 1 1.25 1.5])
      set(gca,'xtickmode','manual')
      set(gcf,'paperposition',[.3 .5 8 9])
      grid
      title(rubrik)
    end
  end
end
