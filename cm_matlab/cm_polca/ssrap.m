%@(#)   ssrap.m 1.4	 08/02/20     15:25:14
%
%
%function ssrap(distfil,utfil,sorton,inv,qspec)
%
%Get CR data from distribution file, calculate, sort and print
%CR depletion parameters. Distributions CRBORO, CRTBOR, CREXPO
%and CRTEXP need be present in the distribution file to be read. 
%Output data matches that of POLUT's CONSEG (308) option, except
%for CR top quarter segment depletion. Instead max quarter 
%depletion is given by ssrap. Only fixed quarters are considered
%in this version.
%
%options:
%  sorton - 'none'   CR channel order (default)
%         - 'crid'   ASCII sort on CR identities
%         - 'crtb'   tip burnup order
%         - 'crab'   average burnup order
%         - 'crab'   max node burnup order
%         - 'maxqb'  max quarter burnup order
%  inv    - 0 ascending order (low->high) or 
%           1 descending order (default, high->low)
%  qspec  - 0 (default) or 
%           1 (specify for which quarter max is found)
%
%Ex:
%>> ssrap('dist/eoc.dat','sstjosan.txt','maxqb',1)
%

% M. Dahlfors 2007/11/05 (P7 > v.4.5)
%
% 2008/02/20:
%   	- added qspec option for optional output of max quarter 
%	  location (4 - top quarter)
%	- modified inv option: default is now to print highest
%	  depletion values first (descending order)
function ssrap(distfil,utfil,sorton,inv,qspec)
if nargin<5,
  qspec=0;
end
if nargin<4,
  inv=1;
end
if nargin<3,
  sorton='none';
end
if nargin<2,
  budir=pwd
  utfil=[budir,'/ssrap.txt'];
  disp(['Distribution file: ',distfil])
  disp(['Output file: ',utfil])
else
  budir=pwd;
  disp(['Distribution file: ',budir,'/',distfil])
  disp(['Output file: ',budir,'/',utfil])
end
if nargin<1,
  disp(['No input file name given! Must be specified.'])
  return
end
[dum,dum,dum,dum,dum,dum,dum,dum,dum,dum,staton]=readdist(distfil(1,:));
[CRID, mminj] = readdist7(distfil,'CRID');
CRTYP=readdist7(distfil,'CRTYP');
CRXP=readdist7(distfil,'CREXPO')';	%read in exposure distribution (CREXPO)
mxnd=min(find(sum(CRXP)==0))-1;		%number of nodes (with data)
segml=mxnd/4;				%quarter rod segment length
CRBO=readdist7(distfil,'CRBORO')';	%read in B-10 depletion distribution (CRBORO)
crax=(sum(CRXP')/mxnd)';		%calc average node burnup (CREXPO)
crab=(sum(CRBO')/mxnd)';		%calc average node burnup (CRBORO)
crnx=CRXP(:,mxnd);			%top node (CREXPO)
crnb=CRBO(:,mxnd);			%top node (CRBORO)

%
% calculation of max quarter exposures -- as opposed to top quarter in P4 & P7 POLUT
% NB! fixed quarters (as opposed to a "sliding quarter")
%

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
maxqx=max(QX'./segml)';
% Added feature: keep track of which quarter segment is max
for cr=1:length(maxqx)
  wqx(cr)=find(maxqx(cr)==QX(cr,:)./segml);
end

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
maxqb=max(QB'./segml)';
%
crtx = readdist7(distfil,'CRTEXP')';	%read in distribution CRTEXP (P7 pseudo-P4 model)
crtb = readdist7(distfil,'CRTBOR')';	%read in distribution CRTBOR (P7 pseudo-P4 model)
%read in distribution CRDEPL (alternate native P7 depletion model, for potential future implementation)
%CRDP = readdist7(distfil,'CRDEPL')';
%Debug option below:
%save ssrap_var.mat

%
% Sorting
%

if strcmp(sorton,'none'),
  srtstr=['location order'];
  isort=[1:length(CRID)];
else
  isort=(1:length(crab));
  if strcmp(sorton,'crid'),
    [x,isort]=ascsort(CRID);
    srtstr=['identity order'];
  elseif strcmp(sorton,'crab'),
    [x,isort]=sort(crab);
    srtstr=['average burnup order'];
  elseif strcmp(sorton,'crnb'),
    [x,isort]=sort(crnb);
    srtstr=['node burnup order'];
  elseif strcmp(sorton,'maxqb'),
    [x,isort]=sort(maxqb);
    srtstr=['max quarter burnup order'];
  elseif strcmp(sorton,'crtb'),
    [x,isort]=sort(crtb);
    srtstr=['tip burnup order'];
  else
    disp('Error in ssortprint7 unknown value for argument sorton')
    ierr=2;
  end
  if inv==1,
    isort(length(isort):-1:1)=isort;
  end
  CRTYP=CRTYP(isort,:);
  CRID=CRID(isort,:);
  crax=crax(isort);
  crab=crab(isort);
  crnx=crnx(isort);
  crnb=crnb(isort);
  maxqx=maxqx(isort);
  maxqb=maxqb(isort);
  crtx=crtx(isort);
  crtb=crtb(isort);
  wqx=wqx(isort);
end
%Debug option below:
%save ssrap_var_after.mat

%
% Output to file
%

[prg,ver,rdate]=p7_version(distfil);
titel=['CR inventory, sorted in ',srtstr];
fil=['File: ',budir,'/',distfil];
nbu=length(crab);
fid=fopen(utfil,'w');
onpage=41;
ipage=fix(nbu/onpage)+1;
pagenr=0;
irun=1;
tid=datestr(now,31);
for i=1:ipage,
  pagenr=pagenr+1;
  if pagenr==1,
    fprintf(fid,'%s','  ');
  else
    fprintf(fid,'%s','1 ');
  end
  fprintf(fid,'%s%s%s\t%s%s\t%s%2i',staton,'  ',titel,'  ',tid,'      Page ',pagenr);
  fprintf(fid,'\n\n');
  fprintf(fid,'%s','  ');
  fprintf(fid,'%s\t%s %s   %s',fil,deblank(prg),deblank(ver),rdate);
  fprintf(fid,'\n\n');
  fprintf(fid,'%s','      ');
  if qspec==0    % Standard output
    fprintf(fid,'%s','  Control rod              Depletion       Depletion       Depletion       Depletion        ');
    fprintf(fid,'\n');
    fprintf(fid,'%s','                                 in rod tip     in top node    in max quarter    in average ');
    fprintf(fid,'\n\n');
    fprintf(fid,'%s%s%s','  Nr CRID      CRTYP   Coord   MWd/kgU  %B-10  MWd/kgU  %B-10  MWd/kgU  %B-10  MWd/kgU  %B-10 ');
    fprintf(fid,'\n');
    for j=irun:min(irun+onpage-1,nbu)
       fprintf(fid,'%4i%9s%6s  %6s  %8.3f%8.2f%8.3f%8.2f%8.3f%8.2f%8.3f%8.2f%7s      %s',isort(j),CRID(j,1:8),CRTYP(j,:),crpos2axis(crnum2crpos(isort(j),mminj),0),crtx(j),crtb(j),crnx(j),crnb(j),maxqx(j),maxqb(j),crax(j),crab(j));
       fprintf(fid,'\n');
    end
  else           % Output of max quarter segment location
    fprintf(fid,'%s','  Control rod              Depletion       Depletion       Depletion      Max quarter   Depletion        ');
    fprintf(fid,'\n');
    fprintf(fid,'%s','                                 in rod tip     in top node    in max quarter    location     in average ');
    fprintf(fid,'\n\n');
    fprintf(fid,'%s%s%s','  Nr CRID      CRTYP   Coord   MWd/kgU  %B-10  MWd/kgU  %B-10  MWd/kgU  %B-10               MWd/kgU  %B-10 ');
    fprintf(fid,'\n');
    for j=irun:min(irun+onpage-1,nbu)
       fprintf(fid,'%4i%9s%6s  %6s  %8.3f%8.2f%8.3f%8.2f%8.3f%8.2f        %d    %8.3f%8.2f%7s      %s',isort(j),CRID(j,1:8),CRTYP(j,:),crpos2axis(crnum2crpos(isort(j),mminj),0),crtx(j),crtb(j),crnx(j),crnb(j),maxqx(j),maxqb(j),wqx(j),crax(j),crab(j));
       fprintf(fid,'\n');
    end
  end
  irun=irun+onpage;
end
fclose(fid);
