%@(#)   setmode.m 1.1	 05/07/13     10:29:40
%
%
function setmode(mode,rbutton)

hw=gcf;
userdata=get(hw,'userdata');
oldmode=userdata(24);
userdata(24)=mode;
set(hw,'userdata',userdata);
hmain=userdata(23);
mainuserdata=get(hmain,'userdata');
kedja=get(userdata(2),'userdata');
mminj=get(userdata(3),'userdata');
lfrom=get(userdata(8),'userdata');
lto=get(userdata(9),'userdata');
gonu=get(userdata(11),'userdata');
from=get(userdata(12),'userdata');
to=get(userdata(13),'userdata');
ready=get(userdata(14),'userdata');
fuel=get(userdata(15),'userdata');
skyffett=get(userdata(16),'userdata');
Hpil=get(userdata(19),'userdata');
Hring=get(userdata(20),'userdata');
plmat=get(userdata(22),'userdata');
ncol=get(mainuserdata(26),'userdata');
hcpil=get(userdata(31),'userdata');
figure(hmain);
curfile=setprop(5);
cminstr=setprop(7);
cmaxstr=setprop(8);
cmin=str2num(cminstr);
cmax=str2num(cmaxstr);
if isequal(mode,4),
   
   %kinf=kinf2mlab(curfile);
   
   kinf = readdist7(curfile, 'khot');		%Uppdaterat
   
   skyffett=(kinf>1.14)'.*(1-ready);
   iskyff=find(skyffett==1);
   plvec=round((cmax-cmin)/ncol*(cor2vec(plmat,mminj)-2)+cmin);
   plvec(iskyff)=ones(size(iskyff'))*10;
   gonu(iskyff)=4*ones(size(iskyff));
   for k=1:length(iskyff),
     [ik(k),jk(k)]=find(kedja==iskyff(k));
     l=max(find(kedja(ik(k))>0));                
     for ll=jk(k)-1:-1:1,
       gonu(kedja(ik(k),ll))=4;     
     end
   end     
   ccplot(plvec);
   setlabels;
   scalelab;
elseif oldmode==4&mode~=-1,
   [kedja,gonu]=findchain(to,from,ready,fuel);
   iskyff=0;
end
hrbutton=userdata(1,rbutton);
value=get(hrbutton,'Value');
if value==1,
	set(hw,'pointer','watch');
	figure(hmain);
	[Hpil,Hring]=plotallchains(kedja,mminj,1);
	[Hpil,Hring]=updatpil(Hpil,Hring,gonu,mode);
        if lfrom~=-1,
	  hcpil=checkpilar(mode,kedja,mminj,lfrom,lto,hcpil);
        end;
	set(hw,'pointer','arrow');
end;

plmat=get(mainuserdata(3),'cdata');
set(userdata(22),'userdata',plmat);

set(userdata(2),'userdata',kedja);
set(userdata(11),'userdata',gonu);
set(userdata(16),'userdata',skyffett);
set(userdata(19),'userdata',Hpil);
set(userdata(20),'userdata',Hring);
set(userdata(31),'userdata',hcpil);


