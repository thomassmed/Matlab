%@(#)   cystep.m 1.7	 98/04/20     08:29:44
%
function cystep(sign)
hmat=get(gcf,'userdata');
hvec=hmat(1,:);
htext=hmat(2,1:4);
ll=length(hvec)-2;
hwin=gcf;
hpar=hvec(ll+1);
hfil=hvec(ll+2);
hand=get(hpar,'userdata');
refdist=get(hand(51),'userdata');
for i=1:ll
  j(i)=get(hvec(i),'value');
end
dname=refdist(find(j),:);
filename=get(hfil,'string');
load('simfile')
s=size(filenames);
if length(bocfile)<s(2),bocfile=[bocfile setstr(32*ones(1,s(2)-length(bocfile)))];end
if length(bocfile)>s(2),filenames=[filenames setstr(32*ones(s(1),length(bocfile)-s(2)))];end
s=size(filenames);
filenames=[bocfile; filenames];
s=size(filenames);
ll=length(filename);
if s(2)>ll,filename=[filename setstr(32*ones(1,s(2)-ll))];end
slpos=find(filename=='/');
if isempty(slpos),slpos=0;end
slpos=slpos(length(slpos))+1;
if strcmp('BURNUP',dname)|strcmp('VHIST',dname)|strcmp('SSHIST',dname)|strcmp('EFPH',dname)
  d=0;
else
  d=1;
end
for j=1:s(1)
  i(j)=strcmp(filename(slpos:s(2)),filenames(j,slpos:s(2)));
end
i=find(i);
if ~isempty(i),i=i+sign;end
if i>0 & i<s(1)
  set(hfil,'string',filenames(i,:));
  set(hand(1),'string',filenames(i,:));
  efph=readdist(filenames(i,:),'efph');
  [dist,mminj,konrod,bb,hy]=readdist(filenames(i+1,:),dname);
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
end
