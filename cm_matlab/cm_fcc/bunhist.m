%@(#)   bunhist.m 1.5	 98/12/07     15:30:07
%
%function bunhist(infil,utfil)
%
% Input: infil - input file default='/cm/fx/div/bunhist/infil.txt'
%        utfil - output file default='/cm/fx/div/bunhist/utfil.mat'
%
function bunhist(infil,utfil)
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
[BUIDNT,mminj]=readdist(dfil,'buidnt');
[right,left]=knumhalf(mminj);
BUSYM(right,1:6)=BUIDNT(left,:);
BUSYM(left,1:6)=BUIDNT(right,:);
OLDTYP=readdist(dfil,'buntyp');
BUNTYP=OLDTYP;
BURNUP=mean(readdist(dfil,'burnup'))';
SSHIST=mean(readdist(dfil,'sshist'))';
VHIST=mean(readdist(dfil,'vhist'))';
disp(CYCNAM(1,:))
KINF=kinf2mlab(dfil,'AUTBURC',MASFIL)';
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
  buidnt=readdist(dfil,'buidnt');
  buntyp=readdist(dfil,'buntyp');
  burnup=mean(readdist(dfil,'burnup'))';
  sshist=mean(readdist(dfil,'sshist'))';
  vhist=mean(readdist(dfil,'vhist'))';
  kinf=kinf2mlab(dfil,'AUTBURC',MASFIL)';
  nn=mbucatch(buidnt,BUIDNT(1:nbu,:));
  in=find(nn==0);
  gam=find(nn>0);
  lin=length(in);
  if lin>0, nn(in)=(nbu+1:nbu+lin);nbu=nbu+lin;end
  ITOT=[ITOT;zeros(lin,1)];
  ITOT(nn)=ITOT(nn)+1;
  BURNUP=setsparse(BURNUP,nn,ITOT(nn),burnup);
  KINF=setsparse(KINF,nn,ITOT(nn),kinf);
  SSHIST=setsparse(SSHIST,nn,ITOT(nn),sshist);
  VHIST=setsparse(VHIST,nn,ITOT(nn),vhist);
  ICYC=setsparse(ICYC,nn,ITOT(nn),i*ones(size(nn)));
  IPOS=setsparse(IPOS,nn,ITOT(nn),(1:kkan)');
  nnb=[nn(right);nn(left)];ibb=comprebu([buidnt(left,:);buidnt(right,:)]);
  BUSYM=setsparse(BUSYM,nnb,ITOT(nnb),ibb);
  BUIDNT(nn(in),:)=buidnt(in,:);
  OLDTYP(nn(in),:)=buntyp(in,:);
  nngam=nn(gam);
  id=find(max(abs(abs(BUNTYP(nngam,:))-abs(buntyp(gam,:)))'));
  CHTYP(nngam(id))=i*ones(size(id));
  NCHTYP(nngam(id))=NCHTYP(nngam(id))+1;
  NCHTYP=[NCHTYP;zeros(lin,1)];
  CHTYP=[CHTYP;zeros(lin,1)];
  BUNTYP(nn,:)=buntyp; 
end
disp('klar');
burnup=max(BURNUP')';
lastcyc=max(ICYC')';
kinf=getspars(KINF,(1:nbu),ITOT);
BUSYM=decomprebu(BUSYM);
BUIDCLAB=readskbfil(skbfil);
k=mbucatch(BUIDNT,BUIDCLAB);
ONSITE=k>0;
evsave=['save ',utfil,' BUIDNT BUNTYP BURNUP burnup VHIST SSHIST CYCNAM DISTFIL ICYC lastcyc '];
evsave=[evsave,'IPOS BUSYM ITOT KINF kinf MASFIL ONSITE CHTYP NCHTYP OLDTYP skbfil'];
eval(evsave);

