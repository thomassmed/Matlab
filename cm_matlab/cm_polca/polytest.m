%@(#)   polytest.m 1.1	 94/09/02     12:45:41
%
%function [nymat,deltax,maxx,meann] =tipfkn(diskx,x,nod,aa)
function [nymat,deltax,maxx,meann] =tipfkn(diskx,x,nod,aa)
curf=gcf;
figure
if nargin==2,nod=[1:size(x,1)]';end
if size(nod,1)==1,nod=nod';end
for i=1:size(x,2)
xtemp=x(nod,i);
  poltot(i,:)=polyfit(nod,xtemp,9);
end
if size(x,2)>1,
  x=[mean(abs(x'))]';
end
if size(diskx,2)>1,
  diskx=[mean(abs(diskx'))]';
end
pol1=polyfit(nod,x(nod,:),11);
hold on
sss=polyval(pol1,nod);
%plot(sss,nod);
%plot(x(nod,:),nod,'y');
%nod=1:0.01:23;
%sss=polyval(pol1,nod);
%plot(sss,nod);

tt=100;
a=0;
if nargin==4,
  nodpar=aa';
else
  nodpar=nod;
end
%size(polyval(pol1,nod+a))
%size(diskx(nod))
for a=-1:0.01:1
   tempsum=sum(abs(polyval(pol1,nodpar+a)-diskx(nodpar)));
   if tt>tempsum,deltax=a;end
   tt=tempsum;
end
set(gca,'position',[0.11 0.2 0.85 0.74],'visible','on')
plot(abs(diskx(nod,:)-polyval(pol1,nod+deltax)),nod,'m');
plot(abs(diskx(nod,:)-x(nod,:)),nod,'--');
%plot(x(nod,:),nod,'c');
%plot(polyval(pol1,nod+deltax),nod,'m');

rubrik=['Absolutbelopp av differensen mellan polca-tip --'];
tx=text('string',rubrik,'position',[0,-0.1],'color','white','units','normalized');
deltaxstr=sprintf('%4.3f',deltax);
rubrik=['Absolutbelopp av differensen mellan polca-tip med deltax=',deltaxstr,' nod'];
tx=text('string',rubrik,'position',[0,-0.15],'color','white','units','normalized');
for i=1:size(poltot,1)
   nymat(:,i)=(polyval(poltot(i,:),nod+deltax));
end
%size(diskx(nod,:))
%size(nod)
%plot(diskx(nod,:),nod,'c');
%plot(mean(nymat(nod,:)'),nod,'m');
maxx=max(abs(polyval(pol1,nod+deltax)-diskx(nod)));
meann=mean(abs(polyval(pol1,nod+deltax)-diskx(nod)));
figure(curf);
