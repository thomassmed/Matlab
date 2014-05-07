%@(#)   tripmovie.m 1.2	 94/08/12     12:11:08
%
pow=readdist('/cm/tools/source/mlab/hctrip','POWER');
powupd=readdist('/cm/tools/source/mlab/hctrip','POWUPD');
powok=readdist('/cm/tools/source/mlab/efthctrip','POWER');
updok=readdist('/cm/tools/source/mlab/efthctrip','POWUPD');
kvot=powupd./updok./(pow./powok);
kvplan=100*kvot(25,:);
distplot('/cm/tools/source/mlab/hctrip','kvplan',upright,kvplan);
setprop(7,'97.5');
setprop(8,'102.5');
setprop(9,'yes');
ccplot(kvplan);
M=moviein(25);
for j=1:25
    kvplan=kvot(26-j,:)*100;
    ccplot(kvplan);
    h=get(gcf,'userdata');
    plmat=get(h(3),'cdata');
    plmat(j+2)=11.5;
    set(h(3),'cdata',plmat);
    text(1.05,j+2.5,num2str(26-j));
    M(:,j)=getframe;
end
movie(M,-2);
