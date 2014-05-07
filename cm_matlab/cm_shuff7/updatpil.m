%@(#)   updatpil.m 1.1	 05/07/13     10:29:43
%
%
function [Hpil,Hring]=updatpil(Hpil,Hring,gonu,mode,pnew);
if nargin<5,
  pnew=1;
end
if isequal(pnew,1),
  ip=find(Hpil>0);
  for jp=1:length(ip),
    farg=get(Hpil(ip(jp)),'color');
    xlyl1=get(Hpil(ip(jp)),'userdata');
    delete(Hpil(ip(jp)));
    Hpil(ip(jp))=line(xlyl1(:,1),xlyl1(:,2),'color',farg);
    set(Hpil(ip(jp)),'userdata',xlyl1);
    cf=get(Hring(ip(jp)),'userdata');
    delete(Hring(ip(jp)));
    Hring(ip(jp))=line(cf(2),cf(1),'marker','o','color',farg,'erasemode','none');
    set(Hring(ip(jp)),'userdata',cf);
  end
  handles=get(gcf,'userdata');
  sc=setprop(16);
  if strcmp(sc,'on'),
    psc=get(handles(34),'userdata');
    pscxp=psc(1:2,:); pscyp=psc(3:4,:);
    hsc=line(pscxp,pscyp,'color','black','erasemode','none');
  end
  pcn=get(handles(35),'userdata');
  pcntx=pcn(1:2,:); pcnty=pcn(3:4,:);
  hcont=line(pcntx,pcnty,'color','black','erasemode','none');
end
if isequal(mode,100),
  hp=find(Hpil.*gonu>0);
  hr=find(Hring.*gonu>0);
  set(Hpil(hp),'visible','on');
  set(Hring(hr),'visible','on');
elseif isequal(mode,0),
  hp=find(Hpil.*gonu>0);
  hr=find(Hring.*gonu>0);
  set(Hpil(hp),'visible','off');
  set(Hring(hr),'visible','off');
else
  hp=find(gonu==mode);
  htot=find(Hpil>0);
  set(Hpil(htot),'erasemode','normal');
  set(Hring(htot),'erasemode','normal');
  set(Hpil(htot),'visible','off');
  set(Hring(htot),'visible','off');
  set(Hpil(hp),'visible','on');
  set(Hring(hp),'visible','on');
end
