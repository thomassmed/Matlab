%@(#)   findss7.m 1.3	 06/03/22     09:24:59
%
%function [ierr,errtext]=findss7(infil,utfil,pool);
function [ierr,errtext]=findss7(infil,utfil,pool);
ierr=0;errtext='';
pool=remblank(pool);
load(infil)
lastc=max(lastcyc);
FILTER=zeros(size(ITOT));
if max(ONSITE)==0,
  disp('Warning! According to SKB-list, there are no CR ONSITE');
end
if strcmp(pool,'pool'),
  iskip=find(lastcyc<=lastc-1);
  FILTER(iskip)=ones(size(iskip));
  FILTER=FILTER.*ONSITE;
elseif strcmp(pool,'core'),
  iskip=find(lastcyc==lastc);
  FILTER(iskip)=ones(size(iskip));
elseif strcmp(pool,'clab'),
  FILTER=1-ONSITE;
elseif strcmp(pool,'full'),
  FILTER=ones(size(ITOT));
elseif strcmp(pool,'reuse'),
  [j,i]=find(diff(ICYC')>1);
  FILTER(i)=ones(size(i));
else
  eval(['FILTER=',pool,';']);
end
if ierr==0,
  ifilt=find(FILTER>0);
  ssavesubset7(infil,utfil,ifilt);
end
