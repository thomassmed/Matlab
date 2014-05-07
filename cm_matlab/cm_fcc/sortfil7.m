%@(#)   sortfil7.m 1.2	 06/02/10     13:54:17
%
%function sortfil7(infil,utfil,sortindex);
function sortfil7(infil,utfil,sortindex);
load(infil)
if length(sortindex)~=length(ITOT),
  disp('Error in sortfil7, number of indices in sortindex<>number of elements in infil');
else
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
  CRHIS=CRHIS(sortindex,:);
  %ASYWEI=ASYWEI(sortindex,:);
  %SSHIST=SSHIST(sortindex,:);
  %VHIST=VHIST(sortindex,:);
  IPOS=IPOS(sortindex,:);
  ICYC=ICYC(sortindex,:);
  evsave=['save ',utfil,' ASYID ASYTYP BURNUP burnup CYCNAM DISTFIL ICYC lastcyc '];
  evsave=[evsave,'IPOS BUSYM ITOT KHOT khot MASFIL ONSITE CHTYP NCHTYP OLDTYP CRHIS'];
  eval(evsave);
end
