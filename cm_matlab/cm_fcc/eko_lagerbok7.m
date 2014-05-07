%@(#)   eko_lagerbok7.m 1.4	 06/02/16     12:13:41
%

%
%function eko_lagerbok
%
%
%*************************     MENYVAL    *******************************
%*								     	*
%*    databasfile    =>   databasfil från bunhist eller annan     	*
%*                           (ur sortprint,freedata osv)             	*
%*    batches        =>   batchnamn tex 50,10                        	*
%*    location       =>   pool,core,all,clab                         	*
%*    asyid         =>   patron identiteter                         	*
%*    cycles         =>   C2,C7,C17 osv                              	*
%*    sorton         =>   khot,asyid,burnup,eladd                    	*
%*                        eladd ger lagervärde för var ersättnings-	*
%*			  laddning. Dessutom kan, om eladd anges först,	*
%*		    =>	  ytterligare ett sorteringsvilkor anges.	*
%*    condition now  =>   en sträng som evalueras, logiska tecken    	*
%*                        "&" ger "och" , "|" ger "eller" ,	     	*
%*                        "==" ger  "lika med"                       	*
%*                        parenteser kan användas t.ex               	*
%*                        burnup>45000                               	*
%*                        burnup>45000&khot>0.88&ONSITE&lastcyc==15	*
%*                        burnup>45000|(khot>0.88&ONSITE&lastcyc==15)	*
%*                        följande storheter finns för patronerna:	*
%*                        burnup=utbränning nu 				*
%*                        ONSITE=på stationen  nu			*
%*                        khot=khot nu	                                *
%*                        garpat=garanterad patronutbränning		*
%*			  reuse=återanvänt bränsle			*
%*                        lastcyc=väljer patroner vars sista cykel 	*
%*                        är lastcyc t.ex   4				*
%*                        dessa kan kombineras godtyckligt enl 		*
%* 			  teckenförklaringen ovan.			*
%*									*
%*                        condition cycle  =>   ej implementerad	*
%*									*
%*									*
%*                        Två listor skapas lagerbok.lis och 		*
%*                        khotlist.pri. Dessa är av ekonomisk 		*
%*                        och bränslerelaterad art.			*
%*									*
%*									*
%*       OBS Vid bokslut ska:					 	*
%*	 Sort on  	=>   eladd,asyid				*
%*	 Condition now	=>   onsite					*
%*									*
%*       OBS Vid avskrivning ska:				 	*									
%*	 Condition now	=>   avskrivning				*
%*									*
%************************************************************************
function eko_lagerbok7(datum,matfil,prifil,plotta)
%%h=get(gcf,'userdata');
%%matfil=remblank(get(h(2),'string'));
%%batchesw=remblank(get(h(3),'string'));
%%asyidw=get(h(5),'string');
%%cyclesw=upper(remblank(get(h(6),'string')));
%%location=lower(remblank(get(h(4),'string')));
%%condition=lower(remblank(get(h(8),'string')));
%%condition2='none';
%%sortemp=remblank(get(h(7),'string'));
%%batchdata=remblank(get(h(302),'string'));
%%batchcost=remblank(get(h(303),'string'));
%%avskrivfil=remblank(get(h(305),'string'));  
%%prifil=remblank(get(h(9),'string'));  
reakdir=findreakdir;
matfil=[reakdir,'div/bunhist/utfil.mat'];
load(matfil);
batchesw='all';
asyidw='all';
cyclesw=CYCNAM(length(CYCNAM),:);
location='all';
condition='onsite';
condition2='none';
sortemp='eladd,asyid';
batchfile=[reakdir,'div/bunhist/batch-data.txt'];
batchcostfile=[reakdir,'div/bunhist/fcc/batchcost.txt'];
avskrivfil=[reakdir,'div/bunhist/bufreefil.mat'];
prifil='lagerbok7.pri';

ib=find(sortemp==',');
if ~isempty(ib);
  sorton=sortemp(1:ib(1)-1);
  sortemp=remblank(sortemp(ib(1)+1:length(sortemp)));
else
  sorton=sortemp;
end

reakdir=findreakdir;
if isstr(prifil)
  fid=fopen(prifil,'w');
  disp(['Results will be printed on ',prifil])
else
  fid=prifil;
end
plotta=0;

if exist('skbfil','var')

  BUIDCLAB=readskbfil(skbfil);
  
  % städning
  BUIDCLAB=left_adjust(BUIDCLAB);
  ejpatroner=char('R005            ','DUMMY','R001','R003','R213','R002','DUMMY1','DUMMY3');        
  
  for i=1:size(ejpatroner,1);
  a=strmatch(ejpatroner(i,:),BUIDCLAB);
  	if ~isempty(a), BUIDCLAB(a,:)=setstr(32*ones(length(a),size(BUIDCLAB,2)));, end
  end
  % slut städning
  
  tom = isspace(BUIDCLAB);
  tomrad = sum(tom')';
  pos = find(tomrad==16); 
  BUIDCLAB(pos,:)='';
  BUIDCLAB=left_adjust(BUIDCLAB);
  k=mbucatch(BUIDCLAB,ASYID);
  newbun=find(k==0);
  newbun=BUIDCLAB(newbun,:);
  else
  newbun=[];
end  
  rundate=now;



%***********************  ALLMÄN INFO OM fileR  *********************
fprintf(fid,'\n');
fprintf(fid,'%s',' DATABASENS UNDERLAG:');
fprintf(fid,'\n');
for iii=1:size(DISTFIL,1)
  fprintf(fid,'%s',DISTFIL(iii,:));
  fprintf(fid,'\n');
end
fprintf(fid,'\n');
%fprintf(fid,'%s%s','MASTERFIL: ',MASFIL(1,:));
fprintf(fid,'%s','MASTERFIL: ');
fprintf(fid,'\n');
if exist('skbfil')
  fprintf(fid,'%s','SAFEGUARDFIL: ');
  fprintf(fid,'%s',skbfil(1,:));
end
fprintf(fid,'\n');
fprintf(fid,'\n');
for iii=1:size(rundate,1);
  fprintf(fid,'%s',rundate(iii,:));
  fprintf(fid,'\n');
end
ii=find(reakdir=='/');
staton=upper(reakdir(ii(2)+1:ii(3)-1));
nbu=length(ITOT);

[eladd,garburn,antot,levyear,enr,buntot,weight,eta,typ,stav]=readbatch(batchfile);
khotlimit=0.93;

[bunto,batchcost]=readcost(batchcostfile);

ev=['unix(''','ls -l ',batchfile,''')'];
[ss file]=eval(ev);
fprintf(fid,'\n');
fprintf(fid,'%s%s','batch-datafil: ',file(1,:));
fprintf(fid,'\n');
ev=['unix(''','ls -l ',batchcostfile,''')'];
[ss file]=eval(ev);
fprintf(fid,'\n');
fprintf(fid,'%s%s','batchcost-fil: ',file(1,:));
fprintf(fid,'\n');
fprintf(fid,'%s',' ** The weight is  a meanvalue for specified batch! **');
fprintf(fid,'\n');
fprintf(fid,'%s%f','khotlimit: ',khotlimit);

%fprintf(fid,'\n%s',setstr(12));nästa sida
%*********************   SLUT INFO  ****************************


irad=findeladd(ASYTYP,buntot,levyear);



if strcmp(condition,'none')
  condition='ones(size(irad))';
end
if strcmp(condition2,'none')
  condition2='ones(size(irad))';
end



%*********************    LÄGGA SORTERINGEN I SORTPRINT/SORTFIL ?  ***********************
  isort=(1:length(ITOT));
  if strcmp(sortemp,'khot'),
    [x,sortindex]=sort(khot);
    sortindex(length(sortindex):-1:1)=sortindex;
  elseif strcmp(sortemp,'burnup'),
    [x,sortindex]=sort(burnup);
  elseif strcmp(sortemp,'asyid'),
    [x,sortindex]=ascsort(ASYID);
  elseif strcmp(sortemp,'eladd'),
    [x,sortindex]=ascsort(ASYID);
  elseif ~strcmp(sortemp,'eladd'),
    disp('Error in sortprint unknown value for argument sorton')
    ierr=2;
  end
if length(sortindex)~=length(ITOT),
  disp('Error in sortfil, number of indices in sortindex<>number of elements in infil');
else
  irad=irad(sortindex);
  khot=khot(sortindex);
  burnup=burnup(sortindex);
  lastcyc=lastcyc(sortindex);
  BUSYM=BUSYM(sortindex,:);
  ASYTYP=ASYTYP(sortindex,:);
  CHTYP=CHTYP(sortindex);
  OLDTYP=OLDTYP(sortindex,:);
  NCHTYP=NCHTYP(sortindex);
  ITOT=ITOT(sortindex);
  KHOT=KHOT(sortindex,:);
  ASYID=ASYID(sortindex,:);
  BURNUP=BURNUP(sortindex,:);
  ONSITE=ONSITE(sortindex);
  IPOS=IPOS(sortindex,:);
  ICYC=ICYC(sortindex,:);

  if strcmp(sorton,'eladd'),
    [x,sortindex]=ascsort(irad);
    irad=irad(sortindex);
    khot=khot(sortindex);
    burnup=burnup(sortindex);
    lastcyc=lastcyc(sortindex);
    BUSYM=BUSYM(sortindex,:);
    ASYTYP=ASYTYP(sortindex,:);
    CHTYP=CHTYP(sortindex);
    OLDTYP=OLDTYP(sortindex,:);
    NCHTYP=NCHTYP(sortindex);
    ITOT=ITOT(sortindex);
    KHOT=KHOT(sortindex,:);
    ASYID=ASYID(sortindex,:);
    BURNUP=BURNUP(sortindex,:);
    ONSITE=ONSITE(sortindex);
    IPOS=IPOS(sortindex,:);
    ICYC=ICYC(sortindex,:);
  end
end
onsite=ONSITE;

%***************************  SLUT SORTERING ************************************


eladdind=0;
index=zeros(nbu,2);
asyidind=0;

if ~strcmp(batchesw,'all')
  [a b]=find(batchesw==',');
  for i=1:length(b)
    batchesw(b(i))=' ';
  end
  rad=batchesw;
  k=0;
  for j=1:100,
    [A,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%s',1);
    if length(A)==0, break;end
    k=k+1;
    eladdtemp=str2num(A);
    rad=rad(NEXTINDEX:length(rad));
    [a1 b1]=find(eladd==eladdtemp);
    eladdind=[eladdind; b1];
  end
  eladdind=eladdind(2:length(eladdind));
  for i=1:length(eladdind)
    [a b]=find(irad==eladdind(i));
    index(a,1)=ones(size(a));
  end
else
  index(1:length(irad),1)=ones(size(irad));
end

if ~strcmp(asyidw,'all')
  [a b]=find(asyidw==',');
  for i=1:length(b)
    asyidw(b(i))=' ';
  end
  k=0;
  rad=asyidw;
  for j=1:100,
    [A,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%6s',1);
 if length(A)==0|A==[], break;end
    k=k+1;
    asyidtemp=sprintf('%6s',A);
    rad=rad(NEXTINDEX:length(rad));
    a1=bucatch(asyidtemp,ASYID);
    asyidind=[asyidind; a1];
  end
  asyidind=asyidind(2:length(asyidind'));
  index(asyidind,2)=ones(size(asyidind));
else
  asyidind=1:length(ASYID);
  index(1:length(irad),2)=ones(size(irad));
end
  
%*************  LOCATION  ****************
ierr=0;errtext='';
if ~strcmp(location,'all')
  ifilt=zeros(size(irad));
lastc=max(lastcyc);
FILTER=zeros(size(ITOT));
if max(ONSITE)==0,
  disp('Warning! According to SKB-list, there are no fuel ONSITE');
end
if strcmp(location,'pool'),
  iskip=find(lastcyc<=lastc-1);
  FILTER(iskip)=ones(size(iskip));
  FILTER=FILTER.*ONSITE;
end
if strcmp(location,'core'),
  iskip=find(lastcyc==lastc);
  FILTER(iskip)=ones(size(iskip));
end
if strcmp(location,'clab'),
  FILTER=1-ONSITE;
end
if strcmp(location,'full'),
  FILTER=ones(size(ITOT));
end
if strcmp(location,'reuse'),
  [j,i]=find(diff(ICYC')>1);
  FILTER(i)=ones(size(i));
end
if ierr==0,
  ifilt=find(FILTER>0);
end
index(ifilt,3)=ones(size(ifilt));
else
  ifilt=ones(size(irad));
end

%*************  SLUT LOCATION  ****************

if ~strcmp(cyclesw,'NONE')
  [a b]=find(cyclesw==',');
  for i=1:length(b)
    cyclesw(b(i))=' ';
  end
  rad=cyclesw;
  k=0;
  cyclesnam='   ';
  for j=1:100,
    [A,COUNT,ERRMSG,NEXTINDEX]=sscanf(rad,'%s',1);
    if length(A)==0, break;end
    k=k+1;
    cycletemp=A;
    rad=rad(NEXTINDEX:length(rad));
    cyclesnam=str2mat(cyclesnam,cycletemp);
  end
  cyclesnam=cyclesnam(2:size(cyclesnam,1),:);

 
  for ind=1:size(cyclesnam,1)
    cycles(ind)=mbucatch(cyclesnam(ind,:),CYCNAM);
  end
  cycles=cycles';
else
   ICYC=lastcyc;
   cycles=1:size(CYCNAM,1);
   cycles=cycles';
end
cyclesrad=[];
cycleskol=[];
BURNCYC=zeros(length(irad),length(cycles));
KHOTtemp=zeros(length(irad),length(cycles));

for i=1:length(cycles)
 [cyclesrad1 cycleskol1]=find(ICYC==cycles(i));
  for ij=1:length(cyclesrad1)
    BURNCYC(cyclesrad1(ij),i)=BURNUP(cyclesrad1(ij),cycleskol1(ij));
    KHOTtemp(cyclesrad1(ij),i)=KHOT(cyclesrad1(ij),cycleskol1(ij));
  end
end

%*******************    select cycle  ***************
if size(BURNCYC,2)>1
  BURNUP=max(BURNCYC')';
end
KHOT=KHOTtemp;
KHOT=min(KHOT')';

indextot=prod(index')';
[a b]=find(indextot>0);

ierr=checkbuntot(buntot,bunto);
imax=size(buntot,1);

if ierr==0,
  bpc=batchcost./(antot+1e-30);

  garpat=garburn(irad)';
  weipat=weight(irad)';
  bpcost=bpc(irad)';
  eladdpat=eladd(irad);
  antotpat=antot(irad);
  levyearpat=levyear(irad);
  enrpat=enr(irad);

  Uttag=weipat.*burnup*2.4e-8*eta;
  restburn0=(garpat-burnup/1000)./garpat;restburn=max(restburn0,0);
  kkhot=ones(size(khot));
  [j,i]=find(diff(ICYC')>1);
  if length(j)>0,
    kkhot(i)=getspars(KHOT,i,j);
  end
lastc=max(lastcyc);

%avskrivet bränsle får värdet 0
load(avskrivfil);
avskrivfuel=bufree;
mulfree=ones(size(burnup));
[dum,dum,freenumavs]=find(mbucatch(avskrivfuel,ASYID));
mulfree(freenumavs)=zeros(size(freenumavs));
%slut
restSEK=mulfree.*restburn.*bpcost;
 for i=1:length(cycles) 
  restburncyc0(:,i)=(garpat-BURNCYC(:,i)/1000)./garpat;restburncyc(:,i)=max(restburncyc0(:,i),0);
  cycSEK(:,i)=restburncyc(:,i).*bpcost;
  [rad]=find(BURNCYC(:,i)==0);
  cycSEK(rad,i)=-ones(size(rad))./1000000;
end

%**************      Freshfuel      *****************
 select=ones(size(irad));
[antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
anfresh=antot-antal;
if min(anfresh)<0,
   disp(['   ']);
   disp(['   ']);
   disp(['*******************************************************************************']);
   disp(['~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~']);
   disp(['Warning, something is wrong. Probably the number of bundles in ',batchfile]);
   disp(['Or asytyp in the distributionfile']);
   disp(['_______________________________________________________________________________']);
   disp(['*******************************************************************************']);
   disp(['   ']);
   disp(['   ']);
   disp(['   ']);
end
sekfresh=batchcost./antot.*anfresh;
garut=weight.*garburn.*anfresh*eta*2.4e-5; 

%*************************************************************
if ~strcmp(condition,'avskrivning')
  select=eval(condition)&eval(condition2)&indextot==1; 
end
ival=find(select);

if ~strcmp(cyclesw,'NONE')
  if length(cyclesw)>32,disp('* ERROR  antalet valda cykler är för stort (max=8) *');return;end
end
fprintf(fid,'\n%s',setstr(12));%nästa sida
fprintf(fid,'\n\n\n\n\n');

nbu=size(newbun,1);
if nbu>0
  fprintf(fid,'%s\n','Fresh fuel ');
  fprintf(fid,'%s\n','ASYID');
end
k=0;
if sum(anfresh)~=nbu
  disp('*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_');
  disp('VARNING antalet färska i batch-data är ej samma som i SAFEGUARD-filen');
  disp('Kontrollera att det är rätt SAFEGUARD-fil/rätt antal i batch-data-filen.');
  disp('*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_');  
end
while k<nbu
  for j=1:5,
    if k<nbu
      k=k+1;
      fprintf(fid,'%8s;       ',newbun(k,:));
    end
  end
  fprintf(fid,'\n');
end
fprintf(fid,'\n');
fprintf(fid,'\n');
if nargin==2
  restSEK(ival)=zeros(size(ival));
  cycSEK(ival,:)=zeros(size(cycSEK(ival,:)));
  bpcost(ival)=zeros(size(ival));
  sekfresh=zeros(size(sekfresh));
end
if max(onsite)>0&~strcmp(condition,'avskrivning')
   eko_priclabavskrivn(eladd,buntot,anfresh,levyear,0*meanburn,garburn,0*uttag,garut,sekfresh,fid,staton);
else
  sekfresh=zeros(size(sekfresh));
end
eko_prilagerbok3(ival,burnup(ival)./1000,eladdpat(ival),antotpat(ival),levyearpat(ival),enrpat(ival),weipat(ival),garpat(ival),restSEK(ival),fid,staton,ASYID(ival,1:8),ASYTYP(ival,:),BURNUP(ival,:)./1000,CYCNAM,ICYC(ival,:),ITOT(ival,:),lastcyc(ival,:),ONSITE(ival),lastc,cycSEK(ival,:),cycles,bpcost(ival),condition,condition2,sorton,sekfresh,khot(ival));

  disp('Results will be printed on lagerbok7.pri')

%%special
  fid=fopen('special.pri','w');
 
eko_prilagerutbr(ival,burnup(ival)./1000,eladdpat(ival),antotpat(ival),levyearpat(ival),enrpat(ival),weipat(ival),garpat(ival),restSEK(ival),fid,staton,ASYID(ival,1:8),ASYTYP(ival,:),BURNUP(ival,:)./1000,CYCNAM,ICYC(ival,:),ITOT(ival,:),lastcyc(ival,:),ONSITE(ival),lastc,cycSEK(ival,:),cycles,bpcost(ival),condition,condition2,sorton,sekfresh,khot(ival));
  disp('Results will be printed on special.pri')
%%slut special

%  fid=fopen('khotlist.pri','w');
%
%eko_prilagerboktrend(ival,burnup(ival)./1000,eladdpat(ival),antotpat(ival),levyearpat(ival),enrpat(ival),weipat(ival),garpat(ival),KHOTtemp(ival,:),fid,staton,ASYID(ival,1:8),ASYTYP(ival,:),BURNUP(ival,:)./1000,CYCNAM,ICYC(ival,:),ITOT(ival,:),lastcyc(ival,:),ONSITE(ival),lastc,BURNCYC(ival,:)./1000,cycles,bpcost(ival),condition,condition2,khot(ival));
end
disp('Ready!')
