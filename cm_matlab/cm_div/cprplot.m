%@(#)   cprplot.m 1.3	 05/12/08     13:18:32
%
%function cprplot(filvec,limit) 
function cprplot(filvec,limit)
figure
for j=1:size(filvec,1);
  filename=filvec(j,:);
  [cpr,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(filename,'cpr');
  if j==1,bustart=bb(46);qnom=hy(1);wei=bb(29);end
  x(j)=(bb(46)-bustart)/qnom*wei*1e3*24;
  y(j)=min(cpr);
end
plot(x,y)
hold on
plot(x,limit,'--')
h=text(0,.999*limit(1),'Design limit');
hold off
xlabel('EFPH')
grid
t=sprintf('%s%s',staton,'   Min. CPR.');
title(t)
