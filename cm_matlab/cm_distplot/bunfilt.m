%@(#)   bunfilt.m 1.3	 05/12/08     08:32:55
%
function bunfilt
hpar=gcf;
handles=get(gcf,'userdata');
hpl=handles(2);
if gca~=hpl, axes(hpl);end
ud=get(hpl,'userdata');
ud(11,1:3)='yes';
set(hpl,'userdata',ud);
distfile=ud(5,:);
[dist,mminj,konrod,bb,hy,mz,ks,asytyp,asyref,distlist,...
staton,masfil,rubrik,detpos,fu,op,au,flopos,soufil]=readdist7(distfile);
winheight=100+size(asyref,1)*25;
winbottom=870-winheight;
hfilt=figure('position',[5,winbottom,120,winheight]);
eval(ud(3,:))
for i=1:size(asyref,1)
  hbun(i)=uicontrol('style','checkbox','string',asyref(i,:),'position',[25 winheight-70-25*i 70 20]);
end
hbut1=uicontrol('style','pushbutton','position',[10 winheight-60 40 30],'string','show','callback','setbunfiltmap(1)');
hbut2=uicontrol('style','pushbutton','position',[70 winheight-60 40 30],'string','hide','callback','setbunfiltmap(0)');
temp=size(asyref,1);
wud=zeros(3,mz(14));
wud(2,1:size(asyref,1))=hbun;
wud(3,1)=hfilt;
set(handles(22),'userdata',wud)
udvec=[hfilt hpar];
set(hfilt,'userdata',udvec)
