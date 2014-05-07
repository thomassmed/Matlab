%@(#)   defboc.m 1.1	 05/07/13     10:29:29
%
%
function plvec=defboc
hand=get(gcf,'userdata');   
bocfil=get(hand(2),'string');
delete(gcf);
figure(hand(1));
handles=get(gcf,'userdata');
set(get(handles(6),'userd'),'label','plvec');
setprop(4,'MATLAB:plvec');
curfil=setprop(5);
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton,masfil,rubrik,detpos,fu]=readdist7(curfil);
OK=ones(1,mz(14));
plvec=dramap(curfil,bocfil,OK);
mapprop;
ccplot(plvec);
hM=get(handles(6),'userdata');
set(hM,'userdata',plvec);
set(handles(91),'userdata',bocfil);
set(handles(92),'enable','on');
%set(handles(100),'enable','on');
%set(handles(94),'enable','on');
%set(handles(95),'enable','on');
set(handles(96),'enable','on');
set(handles(97),'enable','on');
set(handles(114),'enable','on');
