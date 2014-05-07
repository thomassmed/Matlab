%@(#)   bunhist7.m 1.6	 06/02/07     15:04:00
%
%function bunhist7(infil,utfil)
%
% Input: infil - input file default='/cm/fx/div/bunhist/infil.txt'
%        utfil - output file default='/cm/fx/div/bunhist/utfil.mat'
%
function bunhist7(infil,utfil)
if nargin<2,
  reakdir=findreakdir;
  budir=[reakdir,'div/bunhist/'];
  utfil=[budir,'utfil.mat'];
  disp(['Output file:',utfil])
end
if nargin<1,
  infil=[budir,'infil.txt'];
  disp(['Input  file:',infil])
end
totant=3000;
totcyc=6;
[DISTFIL,MASFIL,skbfil,CYCNAM]=readinfil(infil);
dfil=remblank(DISTFIL(1,:));
[ASYID,mminj]=readdist7(dfil,'asyid');
[right,left]=knumhalf(mminj);
BUSYM(right,1:16)=ASYID(left,:);
BUSYM(left,1:16)=ASYID(right,:);
OLDTYP=readdist7(dfil,'asytyp');
ASYTYP=OLDTYP;
BURNUP=mean(readdist7(dfil,'burnup'))'*1000;
%ASYWEI=readdist7(dfil,'asywei')';
CRHIS=readdist7(dfil,'crhis');
CRHIS=mean(CRHIS)';
disp(CYCNAM(1,:))
KHOT=readdist7(dfil,'khot')';
kkan=length(BURNUP);
ITOT=ones(kkan,1);
ICYC=ITOT;
IPOS=(1:kkan)';
ic=size(DISTFIL,1);
nbu=kkan;
BUSYM=comprebu(BUSYM);
CHTYP=zeros(kkan,1);
NCHTYP=CHTYP;
for i=2:ic,
  disp(CYCNAM(i,:))
  dfil=remblank(DISTFIL(i,:));
  asyid=readdist7(dfil,'asyid');
  asytyp=readdist7(dfil,'asytyp');
  burnup=mean(readdist7(dfil,'burnup'))'*1000;
  %asywei=readdist7(dfil,'asywei')';
  crhis=mean(readdist7(dfil,'crhis'))';
  %sshist=mean(readdist7(dfil,'sshist'))';
  %vhist=mean(readdist7(dfil,'vhist'))';
  %kinf=kinf2mlab(dfil,'AUTBURC',MASFIL)';
  khot=readdist7(dfil,'khot')';
  nn=mbucatch(asyid,ASYID(1:nbu,:));
  in=find(nn==0);
  gam=find(nn>0);
  lin=length(in);
  if lin>0, nn(in)=(nbu+1:nbu+lin);nbu=nbu+lin;end
  ITOT=[ITOT;zeros(lin,1)];
  ITOT(nn)=ITOT(nn)+1;
  BURNUP=setsparse(BURNUP,nn,ITOT(nn),burnup);
  %KINF=setsparse(KINF,nn,ITOT(nn),kinf);
  KHOT=setsparse(KHOT,nn,ITOT(nn),khot);
  %ASYWEI=setsparse(ASYWEI,nn,ITOT(nn),asywei);
  CRHIS=setsparse(CRHIS,nn,ITOT(nn),crhis);
  %SSHIST=setsparse(SSHIST,nn,ITOT(nn),sshist);
  %VHIST=setsparse(VHIST,nn,ITOT(nn),vhist);
  ICYC=setsparse(ICYC,nn,ITOT(nn),i*ones(size(nn)));
  IPOS=setsparse(IPOS,nn,ITOT(nn),(1:kkan)');
  nnb=[nn(right);nn(left)];ibb=comprebu([asyid(left,:);asyid(right,:)]);
  BUSYM=setsparse(BUSYM,nnb,ITOT(nnb),ibb);
  ASYID(nn(in),:)=asyid(in,:);
  OLDTYP(nn(in),:)=asytyp(in,:);
  nngam=nn(gam);
  id=find(max(abs(abs(ASYTYP(nngam,:))-abs(asytyp(gam,:)))'));
  CHTYP(nngam(id))=i*ones(size(id));
  NCHTYP(nngam(id))=NCHTYP(nngam(id))+1;
  NCHTYP=[NCHTYP;zeros(lin,1)];
  CHTYP=[CHTYP;zeros(lin,1)];
  ASYTYP(nn,:)=asytyp; 
end
burnup=max(BURNUP')';
lastcyc=max(ICYC')';
%kinf=getspars(KINF,(1:nbu),ITOT);
khot=getspars(KHOT,(1:nbu),ITOT);
BUSYM=decomprebu(BUSYM);


BUIDCLAB=readskbfil(skbfil);
  
% Rensa bort poster som ej är bränslepatroner
ejpatroner=['  R005';' DUMMY';'  R001';'  R003';'  R007';'  R213';'  R002';'DUMMY1'];
ejpatroner=[setstr(32*ones(size(ejpatroner,1),10)) ejpatroner];
a=mbucatch(ejpatroner,BUIDCLAB);
pos = find(a);
a=a(pos);
BUIDCLAB(a,:)='';

tom = isspace(BUIDCLAB);
tomrad = sum(tom')';
pos = find(tomrad==6);
BUIDCLAB(pos,:)='';
BUIDCLAB=left_adjust(BUIDCLAB);
k=mbucatch(ASYID,BUIDCLAB);
ONSITE=k>0;


%evsave=['save ',utfil,' ASYID ASYTYP BURNUP burnup VHIST SSHIST CYCNAM DISTFIL ICYC lastcyc '];
%evsave=[evsave,'IPOS BUSYM ITOT KINF kinf MASFIL ONSITE CHTYP NCHTYP OLDTYP skbfil'];
evsave=['save ',utfil,' ASYID ASYTYP BURNUP burnup CYCNAM DISTFIL ICYC lastcyc '];
evsave=[evsave,'IPOS BUSYM ITOT KHOT khot MASFIL ONSITE CHTYP NCHTYP OLDTYP skbfil '];
evsave=[evsave,'CRHIS']; 
%evsave=[evsave,'ASYWEI']; 
eval(evsave);
disp('klar');
