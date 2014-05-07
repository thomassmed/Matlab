%@(#)   lagervalue3.m 1.2	 94/08/12     12:15:16
%
%function lagervalue(matfil,prifil,plotta)
%function lagervalue(matfil,fid,plotta)
%Computes the rest-value all fuel
%Input:
%       matfil   - Output from bunhist (cf. that m-file),
%                  default='/cm/fx/div/bunhist/utfil.mat'
%       prifil   - Print result on prifil/file-identifier,
%                  default='lagervalue.lis'
%       plotta   - if plotta==1, plot spectrum of burnup batch-wise
%                  default=0
function lagervalue(matfil,prifil,plotta)
reakdir=findreakdir;
if nargin<2
  prifil='lagervalue.lis';
  disp('Results will be printed on lagervalue.lis')
end
if isstr(prifil)
  fid=fopen(prifil,'w');
else
  fid=prifil;
end
if nargin<1,
  matfil=0;
end
if ~isstr(matfil),
  matfil=[reakdir,'div/bunhist/utfil.mat'];
end
if nargin<3, plotta=0;end
load(matfil);
ii=find(MASFIL=='/');
staton=upper(MASFIL(ii(2)+1:ii(3)-1));
nbu=length(ITOT);
batchfile=[reakdir,'div/bunhist/batch-data.txt'];
[eladd,garburn,antot,levyear,enr,buntot,weight,eta]=readbatch(batchfile);
batchcostfile=[reakdir,'fcc/batchcost.txt'];
[bunto,batchcost]=readcost(batchcostfile);
ierr=checkbuntot(buntot,bunto);
imax=size(buntot,1);
if ierr==0,
  bpc=batchcost./(antot+1e-30);
  irad=findeladd(OLDTYP,buntot,levyear);
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
  mulfree=((lastcyc<max(lastcyc)&kinf<.93)|kkinf<.93)&burnup/1000<garbun&ONSITE;
  mulfree=1-mulfree;
  restSEK=mulfree.*restburn.*bpcost;
%***************************  Bassang *****************************
  select=max(lastcyc)>lastcyc&ONSITE==1;
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n\n\t\t%s',' Bestr. i bass.');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid,staton);
%***************************  Hard *****************************
  select=max(lastcyc)==lastcyc&ONSITE==1;
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n\n\t\t%s',' H');ae(fid);fprintf(fid,'%s\n\n','rd');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid,staton);
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
  fprintf(fid,'\n\n\n\t\t%s',' Farskt');
  priclabavskrivn(buntot,anfresh,levyear,0*meanburn,garburn,0*uttag,garut,sekfresh,fid,staton);
%***************************  Clab *****************************
  select=ONSITE==0;
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n\n\t\t%s',' CLAB');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid,staton);
%***************************  Tot exkl. Clab *****************************
fprintf(fid,'\n%s\n','1');
  select=ONSITE;
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  garut=weight.*garburn.*antal*eta*2.4e-5;
  meanburn=meanburn.*antal./(antal+anfresh+1e-9);
  restsek=restsek+sekfresh;
  antal=antal+anfresh;
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n\n\t\t%s',' Totalt exklusive CLAB');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid,staton);
%***************************  Tot inkl. Clab *****************************
  select=ones(size(irad));
  [antal,restsek,meanburn,uttag]=sortcost(irad,select,restSEK,burnup,Uttag,imax);
  meanburn=meanburn.*antal./(antal+anfresh+1e-9);
  restsek=restsek+sekfresh;
  anbest=antal;
  antal=antal+anfresh;
  garut=weight.*garburn.*antal*eta*2.4e-5;
  fprintf(fid,'\n\n\n\t\t%s',' Totalt inklusive CLAB');
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fid,staton);
disp([batchfile,' and ',batchcostfile,' have been used']);
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
  priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restold,fid,staton);
fprintf('\n');
fclose(fid);
end
