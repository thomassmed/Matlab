%@(#)   axchan.m 1.4	 05/12/08     08:32:55
%
function axchan
handles=get(gcf,'userdata');
hpl=handles(2);
if gca~=hpl, axes(hpl);end
ud=get(hpl,'userdata');
axtyp=ud(1,:);
plottyp=ud(2,:);
clmap=ud(3,:);
dname=ud(4,:);
distfile=ud(5,:);
option=ud(6,:);
cminstr=ud(7,:);
cmaxstr=ud(8,:);
cmin=str2num(cminstr);
cmax=str2num(cmaxstr);
rescale=ud(9,:);
axiss=(ud(10,:));
bunstr=(ud(11,:));
crfiltstr=ud(12,:);
crods=(ud(13,:));
sdmval=(ud(14,:));
Nod=(ud(15,:));
superc=ud(16,:);
pinfo=ud(17,:);
ginfo=ud(18,:);
fprintf('\n%s\n\n','Left button to select, right to plot');
%hinstr=text('String','left button to select, right to plot','Position',[0.75 1.1],'units','normalized');
button=1;
i=0;
while button==1
 [xx,yy,button]=ginput(1);
 if button==1
   i=i+1;
   x(i,1)=xx;
   y(i,1)=yy;
   nx=fix(xx);
   ny=fix(yy);
   xl=[nx nx+1;
       nx+1 nx];
   yl=[ny ny;
       ny+1 ny+1];
   hcross(:,i)=line(xl,yl,'color','black','erasemode','none');
 end
end
%delete(hinstr)
ll=length(x);
h=figure;
if strcmp(dname(1:7),'MATLAB:')
  [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile);
  hM=get(handles(6),'userdata');
  dist=get(hM,'userdata');
else
  [dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
  staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile,dname);
end
kan=cpos2knum(fix(y),fix(x),mminj);
i=find(Nod==' ');Nod(i)='';
evno=['nod=(',Nod,');'];
eval(evno);
if size(dist,2)==mz(69)
  x=fix((fix(x)+1)/2);y=fix((fix(y)+1)/2);
  kan=crpos2crnum(y,x,mminj);
  inod=1:length(nod);
  nod=nod(inod(length(nod):-1:1));
end
evpl=['plot(dist(',Nod,',kan),nod)'];eval(evpl);
eval(clmap)
hold on
lax=axis;
xmin=lax(1)*ones(size(x));xspan=lax(2)-lax(1);
xmax=xmin+xspan/10*ones(size(x));
xx=[xmin xmax];
ymin=lax(3);yspan=lax(4)-ymin;
ymin=ymin+0.2*yspan;
yy=ymin+(0:ll-1)'*yspan*0.7/ll;
yy=[yy yy];
plot(xx',yy')
chpostr=zeros(ll,5);
xst='  ';
yst='  ';
for i=1:ll,
  chpostr(i,:)=[sprintf('%2i',fix(y(i))),',',sprintf('%2i',fix(x(i)))];
end
text(xx(:,2),yy(:,1),setstr(chpostr));
hold off
title(dname)
grid
