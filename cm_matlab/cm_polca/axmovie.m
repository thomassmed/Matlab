%@(#)   axmovie.m 1.2	 94/08/12     12:09:47
%
function axmovie
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
if strcmp(dname(1:7),'MATLAB:')
  [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist(distfile);
  hM=get(handles(6),'userdata');
  dist=get(hM,'userdata');
else
  [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist(distfile,dname);
end
M=moviein(25);
for j=1:25
    ccplot(dist(26-j,:));
    h=get(gcf,'userdata');
    plmat=get(h(3),'cdata');
    plmat(j+2)=11.5;
    set(h(3),'cdata',plmat);
    text(1.05,j+2.5,num2str(26-j));
    M(:,j)=getframe;
end
movie(M,-2);
