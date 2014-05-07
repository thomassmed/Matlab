%@(#)   simbilaga.m 1.7	 99/01/29     13:00:34
%
%function simbilaga(infil,sskartfil,lhgrfil)
%Prepares plots and cr-maps from distr.-files
%Example: prepare an input file as /cm/f3/c9/dist/indata-sim.txt and type
%         simbilaga
%

% Revised: Thomas Smed 931005 includation of reffile and fix of TMOL-bug
% Revised: Thomas Smed 931006 includation of several TMOL-inputs
% Revised: Thomas Smed 931007 fix of printout text bug
% Revised: Thomas Smed 931008 includation of lhgr vs burnup plot
% Revised: Thomas Smed 931012 includation of penalty
%
%
%
function simbilaga(infil,sskartfil,lhgrfil)
if nargin<1,
  infil='indata-sim.txt';disp('Indata will be read from indata-sim.txt');
end
if nargin<2,
  sskartfil='sskarta.ss';disp('Control-maps will be printed on sskarta.ss');
end
if nargin<3,
  lhgrfil='lhgr.ss';disp('LHGR in cr-module will be printed on lhgr.ss');
end
[distfiler,efph,crpos,crstr,titel,typ,typer,tmolburn,tmollhgr,reffile,styp,straff,istraff]=...
readindatasim(infil);
printsskarta(distfiler,efph,titel,sskartfil);
if length(styp)<1
  strafflag=0;
else
  strafflag=1;
end
ndist=size(distfiler,1);
buntyp=readdist(distfiler(1,:),'buntyp');
[burnup,mminj,konrod]=readdist(distfiler(1,:),'burnup');
[kmax,kkan]=size(burnup);
ntyp=size(typ,1);
typnum=zeros(1,kkan);
for i=1:ntyp
  eval(['mult(i,:)=mfiltbun(buntyp,',remblank(typer(i,:)),');']);
  ityp=find(mult(i,:));
  typnum(ityp)=ones(size(ityp))*i;
end
sntyp=size(styp,1);
stypnum=ones(1,kkan);
for i=2:sntyp
  eval(['mults=mfiltbun(buntyp,',remblank(styp(i,:)),');']);
  ityp=find(mults);
  if length(ityp)>0,
    stypnum(ityp)=ones(size(ityp))*i;
  end
end
crnum=crpos2crnum(crpos,mminj);
% sort the crmodules s.t. the text will in the plot will match the
% curves
[cc,ic]=sort(crnum);
crpos=crpos(ic,:);
crstr=crstr(ic,:);
crnum=crnum(ic);
ncr=size(crpos,1);
crflagga=zeros(kmax,ncr);
if isstr(reffile),
  [d,d,konrod]=readdist(reffile);
  maxnod=kmax-floor(konrod(crnum)/40);
  for j=1:ncr,
    crflagga(:,j)=(1:kmax)'<=maxnod(j);
  end
else
  reffile=distfiler(1,:);
  maxnod=kmax*ones(size(crpos,1),1);
end
im0=find(maxnod==0);
if length(im0)>0, 
  maxnod(im0)=ones(size(im0));
  disp('Warning!')
  disp('The following control rods are completely withdrawn:')
  disp(crstr(im0,:));  
end
burnboc=readdist(reffile,'burnup');
konrod=0*konrod;
konrod(crnum)=10*ones(size(crnum));
ikan=filtcr(konrod,mminj,.5,1.5);
dburn=0*burnup;
burnold=burnboc;
for i=1:ndist,
  [burnup,dum,konrod]=readdist(distfiler(i,:),'burnup');
  krod=konrod(crnum);
  if strafflag==1,
    for j=1:ncr,
      crflag=[crflagga(:,j) crflagga(:,j) crflagga(:,j) crflagga(:,j)];
      dburn(:,ikan(j,:))=dburn(:,ikan(j,:))+crflag.*(burnup(:,ikan(j,:))-burnold(:,ikan(j,:)));
      crflagga(:,j)=(1:kmax)'<=kmax-floor(krod(j)/40);
    end
    [flpd,ikan,nod,burn,lhgr,straf,dbur]=crlhgr(distfiler(i,:),burnboc,crpos,tmolburn,tmollhgr,maxnod,mult,dburn,straff,istraff,stypnum);
  else
    [flpd,ikan,nod,burn,lhgr]=crlhgr(distfiler(i,:),burnboc,crpos,tmolburn,tmollhgr,maxnod,mult);
  end
  [FLPD(i,:),jf]=max(flpd');
  if strafflag==1,
    DBURN(i,:)=getspars(dbur,1:ncr,jf)';
    STRAFF(i,:)=getspars(straf,1:ncr,jf)';
  else
    STRAFF=0;
    DBURN=0;
  end
  LHGR(i,:)=getspars(lhgr,1:ncr,jf)';
  BURN(i,:)=getspars(burn,1:ncr,jf)';
  NOD(i,:)=getspars(nod,1:ncr,jf)';
  wchannel(i,:)=getspars(ikan,1:ncr,jf)';
  wtyp(i,:)=typnum(wchannel(i,:));
  shf=max(readdist(distfiler(i,:),'shf'));
  cpr=readdist(distfiler(i,:),'cpr');
  for j=1:ntyp,      
    SHF(i,j)=max(shf(find(mult(j,:)==1)));
    CPR(i,j)=min(cpr(find(mult(j,:)==1)));
  end  
  burnold=burnup;
end
prilhgr(lhgrfil,wchannel,mminj,wtyp,typ,buntyp,LHGR,BURN,NOD,FLPD,STRAFF,DBURN,crstr,efph,titel);
cpsh=figure('position',[0 0 560 840]);
subplot(211);
for j=1:ntyp,
  plot(efph,CPR(:,j));
  ind=min(ndist,3*j);
  text(efph(ind),CPR(ind,j),typ(j,:));
  if j==1,
    hold on
  end
end  
ax=axis;
text(.95*ax(1)+0.05*ax(2),0.9*ax(4)+0.1*ax(3),'CPRmin');
title(titel);
ht=get(gca,'title');
set(ht,'fontsize',20);
subplot(212)
for j=1:ntyp,
  plot(efph,SHF(:,j)/1e4);
  ind=min(ndist,j);
  text(efph(ind),SHF(ind,j)/1e4,typ(j,:));
  if j==1,
    hold on
  end
end  
ax=axis;
text(.95*ax(1)+0.05*ax(2),0.95*ax(4)+0.05*ax(3),'SHFmax (W/cm2)');
set(gcf,'papertype','A4');
set(gcf,'paperposition',[.25 2.5 20 25]);
clhg=figure('position',[300 0 560 840]);
nc=size(crpos,1);
subplot(211);
plottyp=['r- '
         'm--'
         'k: '
         'g-.'
         'b- '
         'r--'
         'm: '
         'k-.'
         'g- '
         'b--'
         'r: '
         'm-.'
         'k- '
         'g--'
         'b: '
         'r-.'];
for j=1:nc,
  plot(efph,FLPD(:,j),plottyp(j,:));
  ind=min(ndist,j);
  text(efph(ind),FLPD(ind,j),crstr(j,:));
  if j==1,
    hold on
  end
end  
ax=axis;
text(.95*ax(1)+0.05*ax(2),0.95*ax(4)+0.05*ax(3),'FLPD i styrstavsmodul');
title(titel);
ht=get(gca,'title');
set(ht,'fontsize',20);
subplot(212);
for j=1:nc,
  plot(efph,LHGR(:,j),plottyp(j,:));
  ind=min(ndist,j);
  text(efph(ind),LHGR(ind,j),crstr(j,:));
  if j==1,
    hold on
  end
end  
ax=axis;
text(.95*ax(1)+0.05*ax(2),0.95*ax(4)+0.05*ax(3),'LHGR i styrstavsmodul');
set(gcf,'papertype','A4');
set(gcf,'paperposition',[.25 2.5 20 25]);
lhbu=figure('position',[580 0 560 840]);
colvec=['y';'m';'c';'r';'g';'b';'w'];
plot(tmolburn',tmollhgr');
hold on
plottyp=['x';'o';'+';'*';'.'];
np=size(plottyp,1);
ind=1;
for i=1:nc
  [dum,im(i)]=max(FLPD(:,i));
  plot(BURN(im(i),i),LHGR(im(i),i),[colvec(wtyp(im(i),i)),plottyp(ind)]);
  ind=ind+1;
  if ind>np, ind=1;end
end
ax=axis;
ysta=0.1*ax(3)+.9*ax(4);
ysto=0.95*ax(3)+.05*ax(4);
xte= 1.05*ax(2)-.05*ax(1);
xmar=.99*ax(2)+.01*ax(1);
deltay=ysta-ysto;
if nc>2, deltay=deltay/(nc-1);end
ind=1;
for i=1:nc,
  plot(xmar,ysta-(i-1)*deltay,[colvec(wtyp(im(i),i)),plottyp(ind)]);
  text(xte, ysta-(i-1)*deltay,crstr(i,:));
  ind=ind+1;
  if ind>np, ind=1;end
end
text(.95*ax(1)+0.05*ax(2),0.95*ax(4)+0.05*ax(3),'LHGR vs BURNUP');
title(titel);
ht=get(gca,'title');
set(ht,'fontsize',20);
set(gcf,'papertype','A4');
set(gcf,'paperposition',[.25 2.5 20 25]);
