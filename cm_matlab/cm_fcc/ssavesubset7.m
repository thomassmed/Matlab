%@(#)   ssavesubset7.m 1.1	 06/03/22     09:12:21
%
%function  ssavesubset(infil,utfil,ifilt);
function  ssavesubset(infil,utfil,ifilt);
load(infil)
%khot=khot(ifilt);
lastcyc=lastcyc(ifilt);
%burnup=burnup(ifilt);
crax=crax(ifilt);
crab=crab(ifilt);
crnx=crnx(ifilt);
crnb=crnb(ifilt);
maxqx=maxqx(ifilt);
maxqb=maxqb(ifilt);
crtx=crtx(ifilt);
crtb=crtb(ifilt);
%BUSYM=BUSYM(ifilt,:);
%ASYTYP=ASYTYP(ifilt,:);
CRTYP=CRTYP(ifilt,:);
%OLDTYP=OLDTYP(ifilt,:);
%CHTYP=CHTYP(ifilt);
%NCHTYP=NCHTYP(ifilt);
ITOT=ITOT(ifilt);
%KHOT=KHOT(ifilt,:);
CRID=CRID(ifilt,:);
%BURNUP=BURNUP(ifilt,:);
CRAX=CRAX(ifilt,:);
CRAB=CRAB(ifilt,:);
CRNX=CRNX(ifilt,:);
CRNB=CRNB(ifilt,:);
MAXQX=MAXQX(ifilt,:);
MAXQB=MAXQB(ifilt,:);
CRTX=CRTX(ifilt,:);
CRTB=CRTB(ifilt,:);
%ASYWEI=ASYWEI(ifilt,:);
%SSHIST=SSHIST(ifilt,:);
%VHIST=VHIST(ifilt,:);
IPOS=IPOS(ifilt,:);
ICYC=ICYC(ifilt,:);
ONSITE=ONSITE(ifilt);
%evsave=['save ',utfil,' ASYID ASYTYP BURNUP burnup VHIST SSHIST CYCNAM DISTFIL ICYC lastcyc '];
%evsave=[evsave,'IPOS BUSYM ITOT KHOT khot MASFIL ONSITE CHTYP NCHTYP OLDTYP'];
evsave=['save ',utfil,' CRID CRTYP CRAX crax CRNX crnx MAXQX maxqx CRTX crtx '];
evsave=[evsave,'CRAB crab CRNB crnb MAXQB maxqb CRTB crtb CYCNAM DISTFIL '];
evsave=[evsave,'ICYC lastcyc IPOS ITOT MASFIL ONSITE '];
eval(evsave);