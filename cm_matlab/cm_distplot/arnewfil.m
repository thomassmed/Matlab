%@(#)   arnewfil.m 1.4	 06/01/04     08:22:27
%
function arnewfil
p=get(gcf,'position');
z=get(gcf,'userdata');
harwin=gcf;
hpar=z(3);
hand=get(hpar,'userdata');
ud=get(hand(2),'userdata');
hdis=z(1);
hfil=z(2);
distfile=get(hfil,'string');
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist(distfile);
set(hdis,'string',distlist);
set(hdis,'value',1);
figure(hpar);
