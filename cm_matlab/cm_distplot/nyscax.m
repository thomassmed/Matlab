%@(#)   nyscax.m 1.3	 05/12/12     16:04:42
%
handles=get(gcf,'userdata');
dname=setprop(4);
distfile=setprop(5);
psc=get(handles(34),'userdata');
pcn=get(handles(35),'userdata');
mpos=get(handles(31),'userdata');
curf=gcf;
f=figure;
pscxp=psc(1:2,:); pscyp=psc(3:4,:);
pcntx=pcn(1:2,:); pcnty=pcn(3:4,:);
hsc=plot(pscxp,pscyp,'white');
hcont=line(pcntx,pcnty,'erasemode','none','color','white');
if strcmp(dname(1:4),'MATL')
  [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile);
  hM=get(handles(6),'userdata');
  dist=get(hM,'userdata');
else
  [dist,mminj,konrod,bb,hy,mz,ks]=readdist7(distfile,dname);
end
konr=ones(length(konrod),1);
[ikan,ikancr]=filtcr(konr,mminj,0,100);
for i=1:length(konrod), mdist(:,i)=sum(dist(:,ikan(i,:))')';end
pmax=max(max(mdist));
ik=find(konrod<1000);
ll=length(ik);
if ll>0
  ktext=zeros(ll,2);
  my=2*mpos(ik,1);mx=2*mpos(ik,2)-0.4;
  for i=1:ll,
    ktext(i,:)=sprintf('%2i',round(konrod(ik(i))/10));
  end
  hcrtext=text(mx,my,ktext);
end
for i=1:length(konrod)
  k=2*crnum2crpos(i,mminj);
  xx=k(2)-1;yy=k(1)+1;
  y=(yy:-1/12:yy-2);
  h(i)=line(xx+mdist(:,i)/pmax*2,y,'erasemode','none');
end
axis([15 31 1 31]);
tit=sprintf('%4i%s%6i%s%7i%s%6i%s',round(hy(1)*100),'%',round(hy(2)),' kg/s keff=',round(bb(96)*1e5),' ssum',bb(18),'%');
tit=[tit,sprintf('%s%4i','  Xenon ',round(bb(70)/1e12))];
title(tit);
set(gcf,'papertype','a4');
set(gcf,'paperpos',[0.1 1 9 10]);
set(gca,'ydir','reverse');
