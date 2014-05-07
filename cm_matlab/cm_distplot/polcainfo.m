%@(#)   polcainfo.m 1.6	 05/12/12     15:50:34
%
function polcainfo
hpar=gcf;
handles=get(hpar,'userdata');
hpl=handles(2);
ud=get(hpl,'userdata');
distfile=ud(5,:);
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile);
hw=handles(61);
h=get(hw,'userdata');
figure(h);
set(h,'name',ud(5,:))
set(h,'numbertitle','off')
ht=get(h,'userdata');
delete(ht)
n=11;
infotext=sprintf('%11s','POLCA start:');
ht(19)=text(-.05,11/n,infotext);
infovalue=sprintf('%4i%s%2i%s%2i%2s%2i%s%2i%s%2i',ks(139),'-',ks(138),'-',ks(137),'  ',ks(136),':',ks(135),':',ks(134));
ht(20)=text(0.5,11/n,infovalue);
infotext=sprintf('%6s','Power:');
ht(21)=text(-0.05,10/n,infotext);
infovalue=sprintf('%5.1f%2s',hy(11)*100,'%');
ht(22)=text(0.5,10/n,infovalue);
infotext=sprintf('%8s','HC-flow:');
ht(1)=text(-0.05,9/n,infotext);
infovalue=sprintf('%5.0f%5s',hy(2),'kg/s');
ht(2)=text(0.5,9/n,infovalue);
infotext=sprintf('%11s','Cr-pattern:');
ht(11)=text(-0.05,8/n,infotext);
infovalue=sprintf('%5i%2s',bb(18),'%');
ht(12)=text(0.5,8/n,infovalue);
infotext=sprintf('%14s','Temp. low. p.:');
ht(9)=text(-0.05,7/n,infotext);
infovalue=sprintf('%6.2f%2s',hy(14),'C');
ht(10)=text(0.5,7/n,infovalue);
infotext=sprintf('%13s','Aver. burnup:');
ht(7)=text(-0.05,6/n,infotext);
infovalue=sprintf('%7.1f%7s',1e3*bb(46),'MWd/TU');
ht(8)=text(0.5,6/n,infovalue);
infotext=sprintf('%8s','Min CPR:');
ht(17)=text(-0.05,5/n,infotext);
infovalue=sprintf('%5.3f',hy(179));
ht(18)=text(0.5,5/n,infovalue);
infotext=sprintf('%6s','F-rad:');
ht(23)=text(-0.05,4/n,infotext);
infovalue=sprintf('%5.3f',bb(104));
ht(24)=text(0.5,4/n,infovalue);
infotext=sprintf('%9s','Max LHGR:');
ht(15)=text(-0.05,3/n,infotext);
infovalue=sprintf('%4.1f%5s',hy(176)/1e3,'kW/m');
ht(16)=text(0.5,3/n,infovalue);
infotext=sprintf('%4s','PPF:');
ht(13)=text(-0.05,2/n,infotext);
infovalue=sprintf('%5.3f',bb(105));
ht(14)=text(0.5,2/n,infovalue);
infotext=sprintf('%11s','Aver. void:');
ht(3)=text(-0.05,1/n,infotext);
infovalue=sprintf('%5.2f%2s',hy(134)*100,'%');
ht(4)=text(0.5,1/n,infovalue);
infotext=sprintf('%6s','k-eff:');
ht(5)=text(-0.05,0/n,infotext);
infovalue=sprintf('%7.5f',bb(96));
ht(6)=text(0.5,0/n,infovalue);
set(h,'userdata',ht)
figure(hpar)
