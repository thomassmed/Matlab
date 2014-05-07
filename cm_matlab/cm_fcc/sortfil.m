%@(#)   sortfil.m 1.2	 94/08/12     12:15:44
%
%function sortfil(infil,utfil,sortindex);
function sortfil(infil,utfil,sortindex);
load(infil)
if length(sortindex)~=length(ITOT),
  disp('Error in sortfil, number of indices in sortindex<>number of elements in infil');
else
  kinf=kinf(sortindex);
  burnup=burnup(sortindex);
  lastcyc=lastcyc(sortindex);
  BUSYM=BUSYM(sortindex,:);
  BUNTYP=BUNTYP(sortindex,:);
  CHTYP=CHTYP(sortindex);
  OLDTYP=OLDTYP(sortindex,:);
  NCHTYP=NCHTYP(sortindex);
  ITOT=ITOT(sortindex);
  KINF=KINF(sortindex,:);
  BUIDNT=BUIDNT(sortindex,:);
  BURNUP=BURNUP(sortindex,:);
  ONSITE=ONSITE(sortindex);
  SSHIST=SSHIST(sortindex,:);
  VHIST=VHIST(sortindex,:);
  IPOS=IPOS(sortindex,:);
  ICYC=ICYC(sortindex,:);
  evsave=['save ',utfil,' BUIDNT BUNTYP BURNUP burnup VHIST SSHIST CYCNAM DISTFIL ICYC lastcyc '];
  evsave=[evsave,'IPOS BUSYM ITOT KINF kinf MASFIL ONSITE CHTYP NCHTYP OLDTYP'];
  eval(evsave);
end
