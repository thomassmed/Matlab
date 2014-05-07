%@(#)   cyshow.m 1.6	 98/06/16     12:42:04
%
function cyshow
load simfile
s=size(filenames);
if length(bocfile)<s(2),bocfile=[bocfile setstr(32*ones(1,s(2)-length(bocfile)))];end
if length(bocfile)>s(2),filenames=[filenames setstr(32*ones(s(1),length(bocfile)-s(2)))];end
s=size(filenames);
filenames=[bocfile; filenames];
%filenames=filenames(1:s(1),:);
hmat=get(gcf,'userdata');
hvec=hmat(1,:);
htext=hmat(2,1:4);
ll=length(hvec)-2;
hwin=gcf;
hpar=hvec(ll+1);
hand=get(hpar,'userdata');
refdist=get(hand(51),'userdata');
hfil=hvec(ll+2);
hdis=hvec(1:ll);
filename=get(hfil,'string');
lf=length(filename);
s=size(filenames);
if s(2)>lf,filename=[filename setstr(32*ones(1,s(2)-lf))];end
if s(2)<lf,flienames=[filenames setstr(32*ones(s(1),lf-s(2)))];end
for i=1:ll
  j(i)=get(hdis(i),'value');
end
dname=refdist(find(j),:);
if strcmp('BURNUP',dname)|strcmp('VHIST',dname)|strcmp('SSHIST',dname)|strcmp('EFPH',dname)
  d=0;
else
  d=1;
end
i=strmatch(filename,filenames);
efph=readdist(filename,'efph');
[dd,mminj,konrod,bb,hy]=readdist(filenames(i+1,:));
dist=readdist(filenames(i+d,:),dname);
for j=1:4,delete(htext(j));end
htext(1)=text(0.7,0.4,sprintf('%s%8.2f','PPF_:',bb(56)),'color',[0 0 0],'fontname','courier');
htext(2)=text(0.7,0.5,sprintf('%s%8.2f','Void:',hy(86)*100),'color',[0 0 0],'fontname','courier');
htext(3)=text(0.7,0.6,sprintf('%s%8.5f','keff:',bb(51)),'color',[0 0 0],'fontname','courier');
htext(4)=text(0.7,0.7,sprintf('%s%8.1f','EFPH:',min(efph)),'color',[0 0 0],'fontname','courier');
hmat(2,1:4)=htext;
set(gcf,'userdata',hmat);
figure(hpar);
setprop(5,filenames(i+1,:));
init(dname,dist);
