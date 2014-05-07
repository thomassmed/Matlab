%@(#)   sshist7.m 1.3	 06/11/22     15:11:46
%
%function sshist7(infil,utfil,test)
%
% Input: infil - input file default='/cm/fx/div/bunhist/infil-ss.txt'
%        utfil - output file default='/cm/fx/div/bunhist/utfil-ss.mat'
%
% Adapted & modified version of the bunhist7 function, listing control
% rod histories instead of bundle histories.

% - Adaptation to P7 > v.4.5
% M. Dahlfors 2006/02/23 
%
% - Modification to max quarter exposure calculation for agreement with 
%   POLCA7 treatment
% - Number of nodes dynamically treated for average & max quarter
%   exposures
% - Minor cleanup
% M. Dahlfors 2006/11/22
%
function sshist7(infil,utfil,test)

%if test==1
%  testdir=findtestdir
%end
%if test==0 | nargin<3
%  testdir=findreakdir;
%end
if nargin<2,
  testdir=findtestdir
  budir=[testdir,'sshist/'];
  utfil=[budir,'utfil-ss.mat'];
  disp(['Output file:',utfil])
end
if nargin<1,
  infil=[budir,'infil-ss.txt'];
  disp(['Input  file:',infil])
end
totant=3000;
totcyc=6;
[DISTFIL,MASFIL,skbfil,CYCNAM]=readinfil(infil);
dfil=remblank(DISTFIL(1,:));
[CRID, mminj] = readdist7(dfil,'CRID');
CRTYP=readdist7(dfil,'CRTYP');
CRXP=readdist7(dfil,'CREXPO')';		%read in exposure distribution (CREXPO)
mxnd=min(find(sum(CRXP)==0))-1;		%number of nodes (with data)
segml=mxnd/4;				%quarter rod segment length
CRBO=readdist7(dfil,'CRBORO')';		%read in B-10 depletion distribution (CRBORO)
CRAX=(sum(CRXP')/mxnd)';			%calc average node burnup (CREXPO)
CRAB=(sum(CRBO')/mxnd)';			%calc average node burnup (CRBORO)
CRNX=CRXP(:,mxnd);			%top node (CREXPO)
CRNB=CRBO(:,mxnd);			%top node (CRBORO)
% calculation of max quarter exposures -- as opposed to top quarter in POLCA7
% NB! fixed quarters
% MWd/kgU
QX=zeros(size(CRXP,1),4);
for cr=1:size(CRXP,1)
  sidx=1;
  for nds=1:mxnd
    if nds < sidx*segml
      QX(cr,sidx)=QX(cr,sidx)+CRXP(cr,nds);
    else
      ndfr=sidx*segml+1-nds;
      QX(cr,sidx)=QX(cr,sidx)+ndfr*CRXP(cr,nds);
      sidx=sidx+1;
      QX(cr,sidx)=(1-ndfr)*CRXP(cr,nds);
    end
  end
end
MAXQX=max(QX'./segml)';
% %B-10
QB=zeros(size(CRBO,1),4);
for cr=1:size(CRBO,1)
  sidx=1;
  for nds=1:mxnd
    if nds < sidx*segml
      QB(cr,sidx)=QB(cr,sidx)+CRBO(cr,nds);
    else
      ndfr=sidx*segml+1-nds;
      QB(cr,sidx)=QB(cr,sidx)+ndfr*CRBO(cr,nds);
      sidx=sidx+1;
      QB(cr,sidx)=(1-ndfr)*CRBO(cr,nds);
    end
  end
end
MAXQB=max(QB'./segml)';
%
CRTX = readdist7(dfil,'CRTEXP')';	%read in distribution CRTEXP
CRTB = readdist7(dfil,'CRTBOR')';	%read in distribution CRTBOR
CRDP = readdist7(dfil,'CRDEPL')';
disp(CYCNAM(1,:))
kkan=length(CRXP);
ITOT=ones(kkan,1);
ICYC=ITOT;
IPOS=(1:kkan)';
ic=size(DISTFIL,1);
nbu=kkan;
CHTYP=zeros(kkan,1);
NCHTYP=CHTYP;
for i=2:ic,
  disp(CYCNAM(i,:))
  dfil=remblank(DISTFIL(i,:));
  crid=readdist7(dfil,'CRID');
  crtyp=readdist7(dfil,'CRTYP');
  crxp=readdist7(dfil,'CREXPO')';
  crbo=readdist7(dfil,'CRBORO')';
  crax=(sum(crxp')./(mxnd))';
  crab=(sum(crbo')./(mxnd))';
  crnx=crxp(:,mxnd);
  crnb=crbo(:,mxnd);
  qx=zeros(size(crxp,1),4);
  for cr=1:size(crxp,1)
    sidx=1;
    for nds=1:mxnd
      if nds < sidx*segml
        qx(cr,sidx)=qx(cr,sidx)+crxp(cr,nds);
      else
        ndfr=sidx*segml+1-nds;
        qx(cr,sidx)=qx(cr,sidx)+ndfr*crxp(cr,nds);
        sidx=sidx+1;
        qx(cr,sidx)=(1-ndfr)*crxp(cr,nds);
      end
    end
  end
  maxqx=max(qx'./segml)';
  qb=zeros(size(crbo,1),4);
  for cr=1:size(crbo,1)
    sidx=1;
    for nds=1:mxnd
      if nds < sidx*segml
        qb(cr,sidx)=qb(cr,sidx)+crbo(cr,nds);
      else
        ndfr=sidx*segml+1-nds;
        qb(cr,sidx)=qb(cr,sidx)+ndfr*crbo(cr,nds);
        sidx=sidx+1;
        qb(cr,sidx)=(1-ndfr)*crbo(cr,nds);
      end
    end
  end
  maxqb=max(qb'./segml)';
  crtx=readdist7(dfil,'CRTEXP')';
  crtb=readdist7(dfil,'CRTBOR')';
  crdp=readdist7(dfil,'CRDEPL')';
  nn=mbucatch(crid,CRID(1:nbu,:));
  in=find(nn==0);
  gam=find(nn>0);
  lin=length(in);
  if lin>0, nn(in)=(nbu+1:nbu+lin);nbu=nbu+lin;end
  ITOT=[ITOT;zeros(lin,1)];
  ITOT(nn)=ITOT(nn)+1;
  CRAX=setsparse(CRAX,nn,ITOT(nn),crax);
  CRAB=setsparse(CRAB,nn,ITOT(nn),crab);
  CRNX=setsparse(CRNX,nn,ITOT(nn),crnx);
  CRNB=setsparse(CRNB,nn,ITOT(nn),crnb);
  MAXQX=setsparse(MAXQX,nn,ITOT(nn),maxqx);
  MAXQB=setsparse(MAXQB,nn,ITOT(nn),maxqb);
  CRTX=setsparse(CRTX,nn,ITOT(nn),crtx);
  CRTB=setsparse(CRTB,nn,ITOT(nn),crtb);
  ICYC=setsparse(ICYC,nn,ITOT(nn),i*ones(size(nn)));
  IPOS=setsparse(IPOS,nn,ITOT(nn),(1:kkan)');
  CRID(nn(in),:)=crid(in,:);
  nngam=nn(gam);
  CRTYP(nn,:)=crtyp; 
end
  CRAX=setsparse(CRAX,nn,ITOT(nn),crax);
  CRAB=setsparse(CRAB,nn,ITOT(nn),crab);
  CRNX=setsparse(CRNX,nn,ITOT(nn),crnx);
  CRNB=setsparse(CRNB,nn,ITOT(nn),crnb);
  MAXQX=setsparse(MAXQX,nn,ITOT(nn),maxqx);
  MAXQB=setsparse(MAXQB,nn,ITOT(nn),maxqb);
  CRTX=setsparse(CRTX,nn,ITOT(nn),crtx);
  CRTB=setsparse(CRTB,nn,ITOT(nn),crtb);
  CRDP=setsparse(CRDP,nn,ITOT(nn),crdp);
crax=max(CRAX')';
crab=max(CRAB')';
crnx=max(CRNX')';
crnb=max(CRNB')';
maxqx=max(MAXQX')';
maxqb=max(MAXQB')';
crtx=max(CRTX')';
crtb=max(CRTB')';
crdp=max(CRDP')';
lastcyc=max(ICYC')';


BUIDCLAB=ssreadskbfil(skbfil);

% denna specialare rensar bort alla patronnummer som börjar på R eller S
% här kan det eventuellt bli strul om man gör om något format
tom = isspace(BUIDCLAB);
tomrad = sum(tom')';
pos = find(tomrad==6);
BUIDCLAB(pos,:)='';
BUIDCLABkol3=BUIDCLAB(:,3);
ejpatroner=find(BUIDCLABkol3=='R' | BUIDCLABkol3=='S' | BUIDCLABkol3=='D');
BUIDCLAB(ejpatroner,:)='';
BUIDCLAB=left_adjust(BUIDCLAB);
k=mbucatch(CRID,BUIDCLAB);
ONSITE=k>0;


evsave=['save ',utfil,' CRID CRTYP CRAX crax CRNX crnx MAXQX maxqx CRTX crtx '];
evsave=[evsave,'CRAB crab CRNB crnb MAXQB maxqb CRTB crtb CRDP crdp '];
evsave=[evsave,'CYCNAM DISTFIL ICYC lastcyc IPOS ITOT MASFIL ONSITE skbfil '];
eval(evsave);
disp('klar');
