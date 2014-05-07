%@(#)   ssortfil7.m 1.1	 06/03/22     09:09:30
%
%function ssortfil7(infil,utfil,sortindex);
function ssortfil7(infil,utfil,sortindex);
load(infil)
if length(sortindex)~=length(ITOT),
  disp('Error in ssortfil7, number of indices in sortindex<>number of elements in infil');
else
  %khot=khot(sortindex);
  %burnup=burnup(sortindex);
  crax=crax(sortindex);
  crab=crab(sortindex);
  crnx=crnx(sortindex);
  crnb=crnb(sortindex);
  maxqx=maxqx(sortindex);
  maxqb=maxqb(sortindex);
  crtx=crtx(sortindex);
  crtb=crtb(sortindex);
  %avxp=avxp(sortindex);
  %avbo=avbo(sortindex);
  lastcyc=lastcyc(sortindex);
  %BUSYM=BUSYM(sortindex,:);
  %ASYTYP=ASYTYP(sortindex,:);
  CRTYP=CRTYP(sortindex,:);
  %CHTYP=CHTYP(sortindex);
  %OLDTYP=OLDTYP(sortindex,:);
  %NCHTYP=NCHTYP(sortindex);
  ITOT=ITOT(sortindex);
  %KHOT=KHOT(sortindex,:);
  CRID=CRID(sortindex,:);
  %BURNUP=BURNUP(sortindex,:);
  CRAX=CRAX(sortindex);
  CRAB=CRAB(sortindex);
  CRNX=CRNX(sortindex);
  CRNB=CRNB(sortindex);
  MAXQX=MAXQX(sortindex);
  MAXQB=MAXQB(sortindex);
  CRTX=CRTX(sortindex);
  CRTB=CRTB(sortindex);
  ONSITE=ONSITE(sortindex);
  %ASYWEI=ASYWEI(sortindex,:);
  %SSHIST=SSHIST(sortindex,:);
  %VHIST=VHIST(sortindex,:);
  IPOS=IPOS(sortindex,:);
  ICYC=ICYC(sortindex,:);
  evsave=['save ',utfil,' CRID CRTYP CRAX crax CRNX crnx MAXQX maxqx CRTX crtx '];
  evsave=[evsave,'CRAB crab CRNB crnb MAXQB maxqb CRTB crtb CYCNAM DISTFIL '];
  evsave=[evsave,'ICYC lastcyc IPOS ITOT MASFIL ONSITE'];
  eval(evsave);
end
