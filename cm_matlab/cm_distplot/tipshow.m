%@(#)   tipshow.m 1.3	 05/12/12     15:57:12
%
function tipshow
hvec=get(gcf,'userdata');
valfil=get(hvec(length(hvec)),'userdata');
nfiles=size(valfil,1);
hfil=hvec(length(hvec)-nfiles+1:length(hvec));
hand=get(hvec(length(hvec)-nfiles),'userdata');
ll=length(hvec)-nfiles-1;
hwin=gcf;
hpar=hvec(ll+1);
hand=get(hpar,'userdata');
ud=get(hand(2),'userdata');
use=get(hand(51),'userdata');
hfil=hvec(ll+2);
dname=use(5,1:6);
filename=get(hfil,'string');
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist7(filename);
winheight=35+size(distlist,1)*25;
if winheight<265,winheight=265;end
winbottom=870-winheight;
l=size(distlist,1);
if l<ll,for i=l:ll,delete(hvec(i)),end,end
clear hvec;
p=get(hwin,'position');
set(hwin,'position',[p(1),p(2),260,winheight])
for i=1:l
  hvec(i)=uicontrol('style','radiobutton','string',distlist(i,:),...
  'position',[25 winheight-i*25 90 20],'callback','cycall');
  if dname==distlist(i,1:6)
    set(hvec(i),'value',1);
    use(4,1:length(num2str(i)))=num2str(i);
  end
end
set(hand(1),'string',filename);
set(hand(51),'userdata',use);
hvec(l+1)=hpar;
hvec(l+2)=hfil;
set(hwin,'userdata',hvec);
ud(5,1:length(filename))=filename;
set(hand(2),'userdata',ud);
figure(hpar);
opfile;
init(dname);
