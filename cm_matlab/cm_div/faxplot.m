%@(#)   faxplot.m 1.3	 05/12/08     13:20:57
%
%function faxplot(filvec,limit) 
function faxplot(filvec,limit)
figure
for j=1:size(filvec,1);
  filename=filvec(j,:);
  [power,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(filename,'power');
  if j==1,bustart=bb(46);qnom=hy(1);wei=bb(29);end
  x(j)=(bb(46)-bustart)/qnom*wei*1e3*24;
  y(j)=mean(power(6,:));
end
plot(x,y)
hold on
hold off
xlabel('EFPH')
grid
t=sprintf('%s%s',staton,'   Fax (nod 6)');
title(t)
