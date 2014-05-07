%@(#)   scaxplot.m 1.3	 05/12/12     15:52:57
%
function scaxplot
set(gcf,'pointer','watch')
dname=setprop(4);
distfile=setprop(5);
if strcmp(dname(1:3),'MAT')
  [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile);
  handles=get(gcf,'userdata');
  hM=get(handles(6),'userdata');
  dist=get(hM,'userdata');
else
  [dist,mminj,konrod]=readdist7(distfile,dname);
end
konrod=ones(length(konrod),1);
[ikan,ikancr]=filtcr(konrod,mminj,0,100);
for i=1:length(konrod), mdist(:,i)=sum(dist(:,ikan(i,:))')';end
pmax=max(max(mdist)); 
for i=1:length(konrod)
  k=2*crnum2crpos(i,mminj);
  xx=k(2)-1;yy=k(1)+1;
  y=(yy:-1/12:yy-2);
  h(i)=line(xx+mdist(:,i)/pmax*2,y,'color','black');
end
hand=get(gcf,'userdata');
set(hand(53),'userdata',h);
set(gcf,'pointer','arrow')
