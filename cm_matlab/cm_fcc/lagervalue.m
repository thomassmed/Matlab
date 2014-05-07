%@(#)   lagervalue.m 1.4	 97/01/10     12:41:44
%
%function lagervalue(titel,matfil,prifil,plotta,savefile)
%function lagervalue(titel,matfil,fid,plotta,savefile)
%Computes the rest-value all fuel
%Input:
%       matfil   - Output from bunhist (cf. that m-file),
%                  default='/cm/fx/div/bunhist/utfil.mat'
%       prifil   - Print result on prifil/file-identifier,
%                  default='lagervalue.lis'
%       plotta   - if plotta==1, plot spectrum of burnup batch-wise
%                  default=0
%     savefile   - If this argument is given, the individual bundle cost
%                  (the variable bpcost) is stored on this file
%
function lagervalue(titel,matfil,prifil,plotta,savefile)
reakdir=findreakdir;
if nargin<1,
  titel='Titel';
end
if nargin<3
  prifil='lagervalue.lis';
  disp('Results will be printed on lagervalue.lis')
end
if isstr(prifil)
  fid=fopen(prifil,'w');
else
  fid=prifil;
end
if nargin<2,
  matfil=0;
end
if ~isstr(matfil),
  matfil=[reakdir,'div/bunhist/utfil.mat'];
end
if nargin<4, plotta=0;end
idot=find(matfil=='.');if length(idot)==0;idot=length(matfil)+1;end
if nargin<5,
  savefile=[reakdir,'div/bunhist/',strip(matfil(1:idot-1)),'_lager.mat'];
  disp(['Results will be stored on ',savefile]);
end


load(matfil);
[dist,mminj,konrod,bb,hy,mz,ks,buntyp,bunref,...
distlist,staton]=readdist(DISTFIL(1,:));
nbu=length(ITOT);
batchfile=[reakdir,'div/bunhist/batch-data.txt'];
[eladd,garburn,antot,levyear,enr,buntot,weight,eta]=readbatch(batchfile);
batchcostfile=[reakdir,'fcc/batchcost.txt'];
[bunto,batchcost]=readcost(batchcostfile);
ierr=checkbuntot(buntot,bunto);
imax=size(buntot,1);
if ierr==0,
  bpc=batchcost./(antot+1e-30);
  irad=findeladd(BUNTYP,buntot,levyear);
  garbun=garburn(irad)';
  weibun=weight(irad)';
  bpcost=bpc(irad)';
  Uttag=weibun.*burnup*2.4e-8*eta;
  restburn0=(garbun-burnup/1000)./garbun;restburn=max(restburn0,0);
  kkinf=ones(size(kinf));
  [j,i]=find(diff(ICYC')>1);
  if length(j)>0,
    kkinf(i)=getspars(KINF,i,j);
  end
  mulfree=((lastcyc<max(lastcyc)&kinf<.93)|kkinf<.93)&burnup/1000<garbun|ONSITE==0;
  mulfree=1-mulfree;
  restSEK=mulfree.*restburn.*bpcost;
  savestrin='  BUIDNT CHTYP IPOS NCHTYP VHIST  ';
  savestrin=[savestrin,'BUNTYP CYCNAM  ITOT  OLDTYP  burnup  '];
  savestrin=[savestrin,'BURNUP DISTFIL KINF  ONSITE  kinf  '];
  savestrin=[savestrin,'BUSYM  ICYC MASFIL SSHIST  lastcyc  '];
  savestrin=[savestrin,'bpcost restburn mulfree kkinf garbun  restSEK  '];
  evsave=['save ',savefile,savestrin];
  eval(evsave);
%***************************  Bassang *****************************
  select=max(lastcyc)>lastcyc&ONSITE==1;
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n');;
  fprintf(fid,'\t%s','1) ');
  fprintf(fid,'%s%s%s%s',staton,'  ',titel,' - Bestr');
  aa(fid);fprintf(fid,'%s','lat i bass');ae(fid);fprintf(fid,'%s','ng');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid);
%***************************  Hard *****************************
  select=max(lastcyc)==lastcyc&ONSITE==1;
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n');;
  fprintf(fid,'\t%s','2) ');
  fprintf(fid,'\t%s%s%s%s',staton,' ',titel,' - ');
  fprintf(fid,'%s',' H');ae(fid);fprintf(fid,'%s\n\n','rd');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid);
%***************************  Farskt *****************************
  select=ones(size(irad));
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  anfresh=antot-antal;
  anfresh=anfresh.*(antal>0);
  if min(anfresh)<0,
    disp(['Warning, something is wrong. Probably the number of bundles in ',batchfile]);
  end
  sekfresh=batchcost./antot.*anfresh;
  garut=weight.*garburn.*anfresh*eta*2.4e-5; 
  fprintf(fid,'\n\n');;
  fprintf(fid,'\t%s','3) ');
  fprintf(fid,'\t%s%s%s%s',staton,' ',titel,' - ');
  fprintf(fid,'%s',' F');ae(fid);fprintf(fid,'%s\n\n','rskt');
  priclabavskrivn(buntot,anfresh,levyear,0*meanburn,garburn,0*uttag,garut,sekfresh,fid);
%***************************  Tot exkl. Clab *****************************
fprintf(fid,'\n%s\n','1');
  select=ONSITE;
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  meanburn=meanburn.*antal./(antal+anfresh+1e-9);
  restsek=restsek+sekfresh;
  antal=antal+anfresh;
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n');;
  fprintf(fid,'\t%s','4) ');
  fprintf(fid,'%s%s%s%s',staton,'  ',titel,' - Totalt exklusive CLAB');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid);
%***************************  Tot exkl. CLAB Ekodetaljer  ***********************
  fprintf(fid,'\n\n');;
  fprintf(fid,'\t%s','5) ');
  fprintf(fid,'\t%s%s%s%s',staton,'  ',titel,' - Totalt exklusive CLAB');
  pribokslut(buntot,antal,levyear,bpc.*antal,restsek,fid);
%***************************  Clab *****************************
fprintf(fid,'\n%s\n','1');
  select=ONSITE==0;
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n');;
  fprintf(fid,'\t%s','6) ');
  fprintf(fid,'\t%s%s%s%s',staton,'  ',titel,' - CLAB');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid);
%***************************  Tot inkl. Clab *****************************
  select=ones(size(irad));
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  meanburn=meanburn.*antal./(antal+anfresh+1e-9);
  restsek=restsek+sekfresh;
  anbest=antal;
  antal=antal+anfresh;
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n');;
  fprintf(fid,'\t%s','7) ');
  fprintf(fid,'\t%s%s%s%s',staton,'  ',titel,' - Totalt inklusive CLAB');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid);
disp([batchfile,' and ',batchcostfile,' have been used']);
%***************************  Tot inkl. CLAB Ekodetaljer  ***********************
  fprintf(fid,'\n\n');;
  fprintf(fid,'\t%s','8) ');
  fprintf(fid,'\t%s%s%s%s',staton,'  ',titel,' - Totalt inklusive CLAB');
  pribokslut(buntot,antal,levyear,bpc.*antal,restsek,fid);
%***************************  Gammal modell *****************************
fprintf(fid,'\n%s\n','1');
  select=ONSITE;
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  meanburn=meanburn.*antal./(antal+anfresh+1e-9);
  restsek=restsek+sekfresh;
  restold=(1-meanburn./garburn).*batchcost.*(antal+anfresh)./(antot+1e-29);
  antal=antal+anfresh;
  restold=max(restold,0);
  restold=restold.*(anbest>0);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n\n%12s\n','Lagervarde enl. gammal modell:');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restold,fid);
fprintf('\n');
fclose(fid);
end
