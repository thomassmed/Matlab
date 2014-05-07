%@(#)   monitor.m 1.2	 10/09/09     10:48:09
%
%
%function plvec=monitor(infil,plvec);
%eller monitor(infil);
function plvec=monitor(infil,plvec);
if nargin<1, 
  hand=get(gcf,'userdata');
  infil=get(hand(2),'string');
  delete(gcf);
  figure(hand(1));
end
handles=get(gcf,'userdata');
hM=get(handles(6),'userdata');
curfile=setprop(5);
cminstr=setprop(7);
cmaxstr=setprop(8);
cmin=str2num(cminstr);
cmax=str2num(cmaxstr);
epsi=1.0d-4*(cmax-cmin);
ncol=get(handles(26),'userdata');
bocfile=get(handles(91),'userdata');
[buid,mminj,konrod,bb,hy,mz,ks,buntyp]=readdist7(curfile,'asyid');
buid0=buid;
OK=ones(1,mz(14));
if nargin<2,
  plvec=dramap(curfile,bocfile,OK);
end
[tot,lbuidt,lline,cr]=sfg2mlab(infil);
to=tot(find(cr==0),:);[it,jt]=size(to);if it<3&jt>2, to=to';end
lbuid=lbuidt(find(cr==0),:);
lto=cpos2knum(to,mminj);
[il,jl]=size(lto);if il==1,lto=lto';end
maxop=length(lto);
for i=1:maxop
  if i>1,
    j1=strmatch(lbuid(i,:),lbuid(1:i-1,:));
  else 
    j1=[];
  end
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
    end
  end
end
buidboc=readdist7(bocfile,'asyid');
ikan=filtcr(ones(size(konrod)),mminj,0,2);
[from,to,ready,fuel]=initvec(buid,buidboc,OK);
to0=to;from0=from;ready0=ready;
[allfrom,allto]=findmove([15 15],OK,from,to,fuel,mminj);
if length(allfrom)>0,
  if ~(length(allfrom)==1&allfrom==0)
    plvec(allfrom)=6*ones(size(allfrom));
  end
end
ii=find(plvec==7&from'==0);
plvec(ii)=8*ones(size(ii));
[kedja,gonu]=findchain(to,from,ready,fuel);
goon=1;
hp=[];
hcross=[];
skyffett=[];
nrop=0;lastoper=0;
outerloop=1;
ccplot(plvec);
setlabels;
hand=get(gcf,'userdata');
plmat=get(hand(3),'cdata');
mode=2;
while outerloop==1,
 fprintf('%s\n','Valj mellan foljande optioner:');
 fprintf('%s\n','     0 - Visa inga pilar');
 fprintf('%s\n','     1 - Visa pilar for bransle som inte kan skyfflas utan urladdning');
 fprintf('%s\n','     2 - Visa pilar for bransle som  kan skyfflas utan urladdning');
 fprintf('%s\n','     4 - Visa kedjor med ettaringar');
 fprintf('%s\n','   100 - Visa alla pilar');
 fprintf('%s\n\n','    -1 - Avsluta');
 stmode=input('Option <Default=-1>: ','s');
 oldmode=mode;
 if length(stmode)==0,
   mode=-1;
   goon=0;outerloop=0;
 else
   mode=str2num(stmode);
   if mode==-1,
     goon=0;outerloop=0;
   else
     goon=1;
   end
 end
 % Find once burnt-fuel to be shuffled
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
 elseif oldmode==4,
   [kedja,gonu]=findchain(to,from,ready,fuel);
   iskyff=0;
 end; %mode=4
 if goon>0,
   [Hpil,Hring]=plotallchains(kedja,mminj);
   [Hpil,Hring]=updatpil(Hpil,Hring,gonu,mode);
   fprintf('\n%s\n','Vanster knapp: Stega Framat');
   fprintf('%s\n','Mittenknapp:   Stega Bakat');
   fprintf('%s\n','Mittenknapp utanfor hard:   Uppdatera skarm');
   fprintf('%s\n','Hoger knapp:   Till huvudmeny');
   hand=get(gcf,'userdata');
   plmat=get(hand(3),'cdata');
 end
 icount=1;
 while goon>0,
  [xx,yy,button]=ginput(1);
  nx=fix(xx);
  ny=fix(yy);
  knum=cpos2knum(ny,nx,mminj);
  if button==1
    if nrop<maxop,
      nrop=nrop+1;
      newmove=0;
      fram=1;
      if lto(nrop)>0,
        if fuel(lto(nrop))>0,
          cto=knum2cpos(lto(nrop),mminj);
          tostr=cpos2axis(cto);
          disp(['Error when trying to move ',lbuid(nrop),' to ',tostr]);
          disp('To-position not empty');
        end          
      end
      if lfrom(nrop)>0,
        if fuel(lfrom(nrop))==0,
          cto=knum2cpos(lfrom(nrop),mminj);
          tostr=cpos2axis(cto);
          disp(['Error when trying to move ',lbuid(nrop),' from ',tostr]);
          disp('No fuel found in from-position');
        end          
      end
      [gonu,from,to,ready,fuel,plmat]=updscreen(lfrom,lto,nrop,lbuid,...
      fram,newmove,skyffett,kedja,mode,mminj,ikan,to0,from0,ready0,gonu,from,to,ready,fuel,plmat);
      if lfrom(nrop)>0,kk=lfrom(nrop);else,kk=lto(nrop);end
      cpo=knum2cpos(kk,mminj);
      nx=cpo(2);ny=cpo(1);      
      xl=[nx nx+1;
          nx+1 nx];
      yl=[ny ny;
          ny+1 ny+1];
      hc=line(xl,yl,'color','black','erasemode','none');
      if length(hcross)==0, hcross=hc;else hcross=[hcross;hc];end
      if mode==0,
        if lfrom(nrop)>0&lto(nrop)>0,  
          farg=get(Hpil(lfrom(nrop)),'color');
          xl=get(Hpil(lfrom(nrop)),'xdata');
          yl=get(Hpil(lfrom(nrop)),'ydata');
          hp0=line(xl,yl,'color',[0.9000    0.9000    0.2000],'erasemode','none');
          hp=[hp;hp0];
        end 
      end
%     [Hpil,Hring]=ritascr(Hpil,Hring,gonu,mode,plmat);
    else
      disp('Detta ar den sista operationen, hoger knapp for att avsluta');
    end
    disp(lline(icount,:));if icount< length(cr), icount=icount+1;end;
    while cr(icount)==1   
      disp(lline(icount,:));icount=icount+1;
    end
  elseif button==2,
    if knum>0,
      if nrop>0,
        newmove=0;
        fram=-1;
        [gonu,from,to,ready,fuel,plmat,ssto]=updscreen(lfrom,lto,nrop,lbuid,...
        fram,newmove,skyffett,kedja,mode,mminj,ikan,to0,from0,ready0,gonu,from,to,ready,fuel,plmat);
        lhc=length(hcross);
        if lhc>0,
          set(hcross(lhc),'erasemode','normal');delete(hcross(lhc));
          lhc=lhc-1;
          set(hcross(lhc),'erasemode','normal');delete(hcross(lhc));
          hcross=hcross(1:lhc-1);
        end
        lhp=length(hp);
        if lhp>0,
          set(hp(lhp),'erasemode','normal');delete(hp(lhp));
          hp=hp(1:length(hp)-1);
        end
%       [Hpil,Hring]=ritascr(Hpil,Hring,gonu,mode,plmat);
        nrop=nrop-1;
      else
        disp('Detta ar den forsta operationen');
      end
      disp(lline(icount,:));
      if icount>1,
        icount=icount-1;
        while cr(icount)==1   
          disp(lline(icount,:));if icount>1, icount=icount-1;end
        end
      end
    else
      if length(hcross)>0, delete(hcross);hcross=[];end
      [Hpil,Hring]=ritascr(Hpil,Hring,gonu,mode,plmat);
    end
  elseif button==3,
    goon=0;
  end; % button==1
 end; %while goon>0
end
if nargout>0, 
   plvec=round((cmax-cmin)/ncol*(cor2vec(plmat,mminj)-2)+cmin);
end
