%@(#)   ccplot.m 1.25	 05/12/12     14:47:35
%
function ccplot(matvar)
set(gcf,'pointer','watch');
handles=get(gcf,'userdata');
hpl=handles(2);
if gca~=hpl, axes(hpl);end
ud=get(hpl,'userdata');
[iu,ju]=size(ud);
axtyp=ud(1,:);
plottyp=ud(2,:);
clmap=ud(3,:);
dname=ud(4,:);
distfile=ud(5,:);
option=ud(6,:);
cminstr=ud(7,:);
cmaxstr=ud(8,:);
cmin=str2num(cminstr);
cmax=str2num(cmaxstr);
epsi=1.0d-4*(cmax-cmin);
rescale=ud(9,:);
axiss=(ud(10,:));
bunstr=(ud(11,:));
crfiltstr=(ud(12,:));
crods=(ud(13,:));
sdmval=(ud(14,:));
nod=(ud(15,:));
superc=ud(16,:);
pinfo=ud(17,:);
ginfo=ud(18,:);
if ju>11, tippo=ud(19,1:12);else,tippo=ud(19,1:ju);end
axpl=ud(20,:);
if nargin ==1
  [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile);
  dist=matvar;
  hM=get(handles(6),'userdata');
  set(hM,'userdata',matvar);
%  dname(1:7)='MATLAB:';
elseif strcmp(dname,'MATLA')
         [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
    distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile);
    hM=get(handles(6),'userdata');
    dist=get(hM,'userdata');
elseif strcmp(dname(1:5),'TMOL*')
        pci=get(handles(271),'userdata');
        [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
        distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile,'LHGR');
        pcilim1=sscanf(get(pci(1),'string'),'%f');
        pcilim2=sscanf(get(pci(2),'string'),'%f');
        burn=readdist7(distfile,'burnup');
        flpd=readdist7(distfile,'flpd');
        ikan=filtcr(konrod,mminj,0,99);
        if size(ikan,2)>0
          ika=[ikan(:,1)',ikan(:,2)',ikan(:,3)',ikan(:,4)'];
          newlimit=dist(:,ika);
          newburn=burn(:,ika)/1000;
          nodal=find(newburn>42.9);
          newlimit(nodal)=pcilim2-0.2*(newburn(nodal)-42.9);
          nodal=find(newburn<=42.9);
          newlimit(nodal)=pcilim1-0.375*(newburn(nodal));
          newlimit=newlimit*1000;
         flpd(ika)=max(dist(:,ika)./newlimit(:,find(ika)));%
         dist=flpd;
       else
         dist=flpd;
       end
   
else
  [dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
  distlist,staton,masfil,rubrik,detpos,fu]=readdist7(distfile,deblank(dname));
end
if size(dist,1)>1,
  i=find(option==' ');option(i)='';
  i=find(nod==' ');nod(i)='';
  evop=['dis2d=',option,'(dist(',nod,',:));'];
  eval(evop);
  d2flag=0;
  if size(dis2d,2)==1,
     d2flag=1;
     evop=['dis2d=dist(',nod,',:);']';
     eval(evop);
  end     
else
  if size(dist,2)==mz(69)
    dis2d=cor2vec(cr2core(dist,mminj),mminj);
  else
    dis2d=dist;
  end
  d2flag=1;
end
filtvec1=get(handles(21),'userdata');
fi=get(handles(22),'userdata');
filtvec2=fi(1,:);
filtvec3=get(handles(24),'userdata');
filtvec=filtvec1.*filtvec2.*(filtvec3>0);
dis2d=dis2d.*filtvec;
if strcmp(rescale(1:4),'yes ')
  hskal=get(handles(14),'userdata');
  if hskal~=0
    sctest=get(hskal,'userdata');
    ctmp=get(sctest(2),'value');
    if sctest(3)==0
      cmin=ctmp;
      cminstr=num2str(cmin);
    else
      cmax=ctmp;
      cmaxstr=num2str(cmax);
    end
    delete(hskal)
    set(handles(14),'userdata',0);
  end
end
if strcmp(rescale(1:4),'auto')
   iscal=find(filtvec==0);
   if size(dist,2)==mz(69)
     iscal=[iscal,find(dis2d==0)];
   end
   disscal=dis2d;disscal(iscal)=[];
   cmin=min(disscal);
   cminstr= sprintf('%.6g',cmin);
   cmax=max(disscal);
   cmaxstr=sprintf('%.6g',cmax);
   if cmax==cmin, cmax=1.01*cmax+0.01;end
   epsi=1.0d-4*(cmax-cmin);
   cmax=cmax+epsi;
   cmin=cmin-epsi;
end
core=vec2core(dis2d,mminj);
if strcmp(pinfo(1:3),'on ')
  hw=handles(61);  
  hinf=get(hw,'userdata');
  if length(find(get(0,'ch')==hinf))>0,
    polcainfo
  else
    pinfo(1:3)='off';
  end
end
if strcmp(axpl(1:3),'yes')
  hax=get(handles(41),'userdata');
  if length(find(get(0,'ch')==hax))>0,
    axplot(hax);
  else
    axpl(1:3)='no ';
  end
end
lc=size(colormap,1);
cmin=cmin-epsi;
cmax=cmax+epsi;
ncol=get(handles(26),'userdata');
if cmin<=0,
  plmat=ncol*core/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
  i=find(core==0);
  plmat(i)=-ones(size(i));
else
  plmat=ncol*core/(cmax-cmin)-ncol*cmin/(cmax-cmin)+2;
end
if strcmp(ud(2,1:7),'contour')
  sm=length(mminj);
  sc=(sm+1)/sm;
  pllot=[plottyp,'(1:sc:sm+1,sm+1:-sc:1,plmat,5);'];
  eval(pllot);
  axis('ij')
else
  ymstr=sprintf('%f',length(mminj)+.5);
  xy=['([1.5 ',ymstr,'],[1.5 ',ymstr,'],'];
  pllot=['hima=',plottyp,xy,'plmat);'];
  eval(pllot);
  handles(3)=hima;
end
hplcol;
title(rubrik);
hstaton=text('String',staton,'position',[2 2],'color','black');
% Lägg till \ vid eventuella _
dna=dname;
i=find(dna=='_');
if ~isempty(i)
  for j=length(i):-1:1
    dna=[dna(1:i(j)-1) '\' dna(i(j):length(dna))];
  end
end
text('String',dna,'Position',[25 2],'color','black');
if d2flag==0,
  text('String',option,'Position',[25 3],'color','black');
end
text('String',sprintf('%s %s','Nod',nod),'Position',[2 3],'color','black');
eval(clmap);
ik=[];
if ~strcmp(crods(1:2),'no')&~strcmp(dname(1:3),'SDM')
  mpos=get(handles(31),'userdata');
  ik=find(konrod<1000);
  ll=length(ik);
  if ll>0
    ktext=zeros(ll,2);
    if ks(1)==0
      my=2*mpos(ik,1);mx=2*mpos(ik,2)-0.4;
      for i=1:ll,
        ktext(i,:)=sprintf('%2i',round(konrod(ik(i))/10));
      end
    else
      my=2*mpos(ik,1);mx=2*mpos(ik,2)-0.8;
      for i=1:ll,
        ktext(i,1:4)=sprintf('%4.1f',konrod(ik(i))/10);
      end
    end
    ktext=setstr(ktext);
    hcrtext=text(mx,my,ktext,'color',crods);
    handles(32)=hcrtext(1);
    set(hcrtext(1),'userdata',hcrtext);
  end
end
if ~strcmp(sdmval(1:2),'no')
  if strcmp(dname(1:3),'SDM')
    ll=length(dist);
    mpos=get(handles(31),'userdata');
    for i=1:ll,
      my(i)=2*mpos(i,1);mx(i)=2*mpos(i,2)-0.5;
      if round(dist(i)*10)/10>9.9,ktext(i,1:3)='>10';
      else
        if dist(i)>0,ktext(i,:)=sprintf('%3.1f',round(dist(i)*10)/10);
        else ktext(i,:)=sprintf('%3s','***');end
      end
    end
    hsdmtext=text(mx,my,ktext,'color',sdmval);
    handles(43)=hsdmtext(1);
    set(hsdmtext(1),'userdata',hsdmtext);
  end
end
psc=get(handles(34),'userdata');
pcn=get(handles(35),'userdata');
pscxp=psc(1:2,:); pscyp=psc(3:4,:);
pcntx=pcn(1:2,:); pcnty=pcn(3:4,:);
hsc=line(pscxp,pscyp,'color','black','erasemode','none','visible',ud(16,1:3));
hcont=line(pcntx,pcnty,'color','black','erasemode','none');
if strcmp(axiss(1:3),'new')
  al=axis;
  axiss=['[',num2str(al(1)),' ',num2str(al(2)),' ',num2str(al(3)),' ',num2str(al(4)),']'];
else
  alim=eval(axiss);
  axis(alim);
  xtl=num2str(alim(1)+1:2:alim(2)-1,'%2i');
  if alim(1)<10,xtl=[' ' xtl];end
  xtlab=[xtl(1:2:length(xtl)-1)' xtl(2:2:length(xtl))'];
  set(gca,'xticklabel',xtlab);
  set(gca,'xtick',[alim(1)+1.5:2:alim(2)-0.5]);
end
if strcmp(rescale(1:4),'yes ')|strcmp(rescale(1:4),'auto')
  dd=(cmax-cmin)/10;
  palv=(cmin-dd:dd:cmax)';
  palv1=palv;
  mp=length(palv);
  palv1(mp-1)=palv(mp-1)-2*epsi;
  hscale=handles(4);
  axes(hscale);
  x=[0 1]';
  hsurc=handles(5);
  delete(hsurc);
  hsurc=surface(x,palv1,[palv';palv']',[palv1';palv1']');
  set(gca,'ycolor','black','xtick',[]);
  ytick=(cmin:dd:cmax)';
  md=max(abs(cmin),abs(cmax));
  isca=floor(log10(md));
  set(gca,'ytick',ytick);
  yticklabel=zeros(length(ytick),5);
  ytick=ytick/10^isca;
  for i=1:length(ytick),
    yticklabel(i,:)=sprintf('%5.2f',ytick(i));
  end
  yticklabel=setstr(yticklabel);
  set(gca,'yticklabel',yticklabel);
  title(sprintf('1e%i',isca),'color','bla');
  handles(5)=hsurc;
  set(gcf,'userdata',handles);
  axis([0 1 cmin cmax])
  rescale='no  ';
  axes(hpl);
end;
if strcmp(axtyp(1:2),'AX'),
  setlabels;
end
ud=str2mat(axtyp,plottyp,clmap,dname,distfile,option,cminstr,cmaxstr,rescale,axiss);
ud=str2mat(ud,bunstr,crfiltstr,crods,sdmval,nod,superc,pinfo,ginfo,tippo,axpl);
set(hpl,'Userdata',ud);
set(gcf,'Userdata',handles);
if ~strcmp(tippo(1:2),'no');tippos;end


% don't plot control rod withdrawal
% outside the axis domain
  ll=length(ik);
  if ~strcmp(dname(1:3),'SDM')&ll>0
    dispcr;
  elseif (strcmp(dname(1:3),'SDM') & ~strcmp(sdmval(1:2),'no'))
    dispsdm;
  end;


set(gcf,'pointer','arrow');
