%@(#)   sdmplot.m 1.3	 95/05/08     10:39:36
%
%function sdmplot(filvec,limit)
function sdmplot(filvec,limit)
figure
for j=1:size(filvec,1);
  filename=filvec(j,:);
  [sdm,mminj,konrod,bb,hy,mz,ks]=dist2mlab(filename,'sdm');
  efph=min(dist2mlab(filename,'efph'));
  if j==1,bustart=efph;end
  x(j)=(efph-bustart);
  y(j)=min(sdm);
end
plot(x,y)
hold on
plot(x,limit,'--')
h=text(0,.95*limit(1),'Design gräns');
hold off
xlabel('EFPH')
ylabel('%')
grid
t=sprintf('%s%s','Min avstängningsmarginal');
title(t)
