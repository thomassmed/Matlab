%@(#)   cyplot.m 1.6	 98/04/20     08:29:42
%
function cyplot(pos)
hpar=gcf;
hand=get(gcf,'userdata');
defdist=setprop(4);
load('simfile');
if ~strcmp('BURNUP',defdist)|~strcmp('VHIST',defdist)|~strcmp('SSHIST',defdist)|~strcmp('EFPH',defdist)
  file=filenames(1,:);
else
  file=bocfile;
end
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist(file,defdist);
efph=readdist(bocfile,'efph');
%if dist(1,1)==-1
%  setprop(4,'BURNUP');
%  setprop(9,'auto');
%  setprop(10,'new');
%end
[dist,mminj,konrod,bb,hy,mz,ks]=readdist(bocfile,defdist);
dname=setprop(4);
if ~strcmp(setprop(3),'new'),eval(setprop(3)),end
winheight=10+size(distlist,1)*25;
if winheight<265,winheight=265;end
winbottom=870-winheight;
if nargin==0,pos=[5,winbottom,370,winheight];end
hcywin=figure('position',pos,'color',[1 1 1]*.8);
axes('visible','off')
ll=size(distlist,1);
for i=1:ll
  callstr=sprintf('%s%i%s','cycall(',i,')');
  hdis(i)=uicontrol('style','radiobutton','string',distlist(i,:),...
  'position',[25 winheight-30-25*(i-1) 90 20],'callback',callstr);
  if strcmp(dname,remblank(distlist(i,:))),set(hdis(i),'value',1);end
end
hdis(ll+1)=hpar;
hfil=uicontrol('style','edit','string',bocfile,'position',...
[140 10 200 30]);
hdis(ll+2)=hfil;
hpu(1)=uicontrol('style','pushbutton','string','show',...
'position',[140 45 90 30],'callback','cyshow');
hpu(2)=uicontrol('style','pushbutton','string','step fwd',...
'position',[140 80 90 30],'callback','cystep(1)');
hpu(3)=uicontrol('style','pushbutton','string','step bwd',...
'position',[140 115 90 30],'callback','cystep(-1)');
hpu(4)=uicontrol('style','pushbutton','string','movie fwd',...
'position',[140 150 90 30],'callback','cymovie');
hpu(5)=uicontrol('style','pushbutton','string','reset movie',...
 'position',[140 185 90 30],'callback','cyreset');
hpu(6)=uicontrol('style','pushbutton','string','exit',...
'position',[140 220 90 30],'callback','delete(gcf)');
hpu(7)=uicontrol('style','pushbutton','string','envelop-min',...
'position',[250 45 90 30],'callback','cyenv(''min'')');
hpu(8)=uicontrol('style','pushbutton','string','envelop-max',...
'position',[250 80 90 30],'callback','cyenv(''max'')');
htext(1)=text(0.7,0.4,sprintf('%s%8.2f','PPF_:',bb(56)),'color',[0 0 0],'fontname','courier');
htext(2)=text(0.7,0.5,sprintf('%s%8.2f','Void:',hy(86)*100),'color',[0 0 0],'fontname','courier');
htext(3)=text(0.7,0.6,sprintf('%s%8.5f','keff:',bb(51)),'color',[0 0 0],'fontname','courier');
htext(4)=text(0.7,0.7,sprintf('%s%8.1f','EFPH:',min(efph)),'color',[0 0 0],'fontname','courier');
figure(hpar)
setprop(5,bocfile);
set(hcywin,'userdata',hdis)
hmat(1,:)=hdis;
hmat(2,1:4)=htext;
set(hcywin,'userdata',hmat)
set(hand(1),'string',bocfile)
set(hand(51),'userdata',distlist)
opfile
%ccplot
