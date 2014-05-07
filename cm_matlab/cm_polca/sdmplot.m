%@(#)   sdmplot.m 1.3	 08/09/01     15:33:02
%
%function sdmplot(filvec,limit)
function sdmplot(filvec,limit)
figure
for j=1:size(filvec,1);
  filename=filvec(j,:);
  [sdm,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(filename,'sdm3d');
  efph=readdist7(filename,'efph');
  x(j)=min(efph);
%  if x(j)>3900,limit(j)=limit(j)+.2;end
  y(j)=min(sdm);
end
plot(x,y)
hold on
plot(x,limit,'--')
h=text(x(1),.95*limit(1),'Design grans');
hold off
xlabel('EFPH')
ylabel('%')
grid
t=sprintf('%s%s','Min avstängningsmarginal');
title(t)
