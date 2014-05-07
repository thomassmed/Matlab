%@(#)   mcalc.m 1.2	 10/09/09     10:49:15
%

%
function mcalc(int,hmm)

if nargin<2,hmm=gcf;end;
userdata=get(hmm,'userdata');
hmain=userdata(23);
handles=get(hmain,'userdata');
set(hmm,'pointer','watch');
hM=get(handles(6),'userdata');
plvec=get(hM,'userdata');
figure(hmain);
curfile=setprop(5);
bocfile=get(handles(91),'userdata');
[buid,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist7(curfile,'asyid');
[crid,crmminj,crkonrod,crbb,crhy,crmz,crks,crbuntyp]=readdist7(curfile,'crid');
buidboc=readdist7(bocfile,'asyid');
cridboc=readdist7(bocfile,'crid');
ikan=filtcr(ones(size(konrod)),mminj,0,2);
if int==1,
%-------------------
%Data fran infilen>>
%-------------------
infil=get(userdata(29),'string');
[tot,lbuidnt,lline,typ]=sfg2mlab(infil);
lbuid=[];
lcrid=[];
lto=[];
lcrtoo=[];  
for i=1:length(typ),
  if typ(i)==1,
    tot(i,1)=cpos2knum(tot(i,:),mminj);
    lbuid=[lbuid;lbuidnt(i,:)];
    lto=[lto;tot(i,1)];
  elseif typ(i)==2,
    tot(i,1)=crpos2crnum(tot(i,1),tot(i,2),mminj);
    lcrid=[lcrid;lbuidnt(i,:)];
    lcrto=[lcrto;tot(i,1)];
  end;
end;
tot=tot(:,1); 
buid0=buid;
crid0=crid;
maxop=length(tot);
psmaxop(1)=length(lto);
psmaxop(2)=length(lcrto);
%--------------------
%"lfrom" tillverkas>>
%--------------------
bnrop=length(find(typ==1));
for i=1:bnrop,
  if i>1,
    j1=strmatch(lbuid(i,:),lbuid(1:i-1,:));
  else 
    j1=[];
  end;
  if length(j1)>0,
    disp(['Varning! BP tidigare flyttad: ',lbuid(i,:)]);
    lfrom(i)=lto(j1(length(j1)));
  else
    j=strmatch(lbuid(i,:),buid0);
    if length(j)==0,
      lfrom(i)=0;
    elseif length(j)==1,
      lfrom(i)=j;
    elseif length(j)>1,
      disp(['Something is wrong, ',lbuid(i,:),' exists in many positions in ',curfile,':']);
      disp(j);
    end;%length(j)==0
  end;%
end;%for i=1:bnrop
%---------------------- 
%"lcrfrom" tillverkas>>
%----------------------
cnrop=length(find(typ==2));
for i=1:cnrop,
  if i>1,
    j1=strmatch(lcrid(i,:),lcrid(1:i-1,:));
  else 
    j1=[];
  end;
  if length(j1)>0,
    disp(['Varning! CR tidigare flyttad: ',lcrid(i,:)]);
    lcrfrom(i)=lcrto(j1(length(j1)));
  else
    j=strmatch(lcrid(i,:),crid0);
    if length(j)==0,
      lcrfrom(i)=0;
    elseif length(j)==1,
      lcrfrom(i)=j;
    elseif length(j)>1,
      disp(['Something is wrong, ',lbuid(i,:),' exists in many positions in ',curfile,':']);
      disp(j);
    end;%length(j)==0
  end;%
end;%for i=1:cnrop
%---------------------------------------------
%"fromt" tillverkas av "lfrom" och "lcrfrom">>
%---------------------------------------------
ib=1;icr=1;
for i=1:length(typ),
  if typ(i)==1, fromt(i)=lfrom(ib); ib=ib+1;
  elseif typ(i)==2, fromt(i)=lcrfrom(icr); icr=icr+1;
  elseif typ(i)==0, fromt(i)=-1;
  end;
end;
end;%if int==1
OK=ones(1,mz(14));
crOK=ones(1,mz(69));
[from,to,ready,fuel]=initvec(buid,buidboc,OK);
[crfrom,crto,crready,crod]=initvec(crid,cridboc,crOK);
to0=to;
from0=from;
ready0=ready;
[allfrom,allto]=findmove([15 15],OK,from,to,fuel,mminj);
if length(allfrom)>0&allfrom(1)>0,
	plvec(allfrom)=6*ones(size(allfrom));
end
ii=find(plvec==7&from'==0);
plvec(ii)=8*ones(size(ii));
[kedja,gonu]=findchain(to,from,ready,fuel);
ccplot(plvec);
setlabels;
scalelab;
hand=get(gcf,'userdata');
plmat=get(hand(3),'cdata');
skyffett=[];
Hpil=[];
Hring=[];
mode=-1;
goon=1;
hp=[];
hcrcross=[];
hcross=[];
nrop=0;
hri=[];
sstom=[];
hcpil=[];
lp=[];
op=[];
bnrop=0;
cnrop=0;
psop=[-1 -1];
if int==1,
 set(userdata(1),'userdata',lbuid);
 set(userdata(8),'userdata',lfrom);
 set(userdata(9),'userdata',lto);
 set(userdata(44),'userdata',lcrid);
 set(userdata(45),'userdata',lcrfrom);
 set(userdata(46),'userdata',lcrto);
 set(userdata(49),'userdata',psmaxop);
 set(userdata(50),'userdata',psop);
 set(userdata(51),'userdata',typ);
 set(userdata(53),'userdata',lline);
 set(userdata(56),'userdata',lbuidnt);
 set(userdata(57),'userdata',tot);
 set(userdata(58),'userdata',fromt);
end;
%Specialare for att "setmode" skall upptacka att "mcalc(2)" korts:
if int==2,
  set(userdata(8),'userdata',-1);
  set(userdata(9),'userdata',-1);
end;
set(userdata(2),'userdata',kedja);
set(userdata(3),'userdata',mminj);
set(userdata(4),'userdata',to0);
set(userdata(5),'userdata',from0);
set(userdata(6),'userdata',nrop);
set(userdata(7),'userdata',maxop);
set(userdata(10),'userdata',ready0);
set(userdata(11),'userdata',gonu);
set(userdata(12),'userdata',from);
set(userdata(13),'userdata',to);
set(userdata(14),'userdata',ready);
set(userdata(15),'userdata',fuel);
set(userdata(16),'userdata',skyffett);
set(userdata(17),'userdata',ikan);
set(userdata(18),'userdata',hcross);
set(userdata(19),'userdata',Hpil);
set(userdata(20),'userdata',Hring);
set(userdata(21),'userdata',hp);
set(userdata(22),'userdata',plmat);
set(userdata(25),'userdata',hri);
set(userdata(26),'userdata',buid);
set(userdata(27),'userdata',buid0);
set(userdata(28),'userdata',buidboc);
set(userdata(30),'userdata',sstom);
set(userdata(31),'userdata',hcpil);
set(userdata(32),'userdata',lp);
set(userdata(33),'userdata',crid0);
set(userdata(38),'userdata',crid);
set(userdata(39),'userdata',crfrom);
set(userdata(40),'userdata',crto);
set(userdata(41),'userdata',crready);
set(userdata(42),'userdata',crod);
set(userdata(43),'userdata',cridboc);
set(userdata(47),'userdata',cnrop);
set(userdata(52),'userdata',bnrop);
set(hmm,'pointer','arrow');
