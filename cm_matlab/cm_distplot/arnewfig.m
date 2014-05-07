%@(#)   arnewfig.m 1.4	 05/12/08     13:36:15
%
function arnewfig(fignr)
if nargin<1, fignr=1;end
p=5+215*(fignr-1);
hpar=gcf;
hand=get(gcf,'userdata');
ud=setprop;
distfile=setprop(5);
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile);
winheight=250;
winbottom=870-winheight;
harwin=figure('position',[p(1),winbottom,190,winheight]);
eval(ud(3,:))
hfil=uicontrol('style','edit','string',distfile,'position',...
[5 5 180 30],'callback','arnewfil');
hdis=uicontrol('parent',harwin,'style','listbox','string',distlist,...
'position',[5 40 100 200],'backgroundcolor',[.9 .9 .9]);
oplist=['+'
        '-'
        '*'
        '/'];
if fignr==1
  hop=zeros(4,1);
  nr=4;
  for i=1:4,
     hop(i)=uicontrol('style','radiobutton','string',oplist(i),...
    'position',[140 25+i*25 40 20],'callback','opecall');
  end
  set(hand(48),'userdata',harwin);
else
  nr=1;
  hop=uicontrol('style','pushbutton','string','=',...
  'position',[140 50 40 20],'callback','arithmetics');
end
%use=[ll;zeros(ll,1);hdis;hfil;hpar;zeros(nr,1);hop];
use=[hdis;hfil;hpar;zeros(nr,1);hop];
set(harwin,'userdata',use);
figure(hpar);
