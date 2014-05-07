%@(#)   savesubset7.m 1.2	 06/02/10     13:53:34
%
%function  savesubset(infil,utfil,ifilt);
function  savesubset(infil,utfil,ifilt);
load(infil)
khot=khot(ifilt);
lastcyc=lastcyc(ifilt);
burnup=burnup(ifilt);
BUSYM=BUSYM(ifilt,:);
ASYTYP=ASYTYP(ifilt,:);
OLDTYP=OLDTYP(ifilt,:);
CHTYP=CHTYP(ifilt);
NCHTYP=NCHTYP(ifilt);
ITOT=ITOT(ifilt);
KHOT=KHOT(ifilt,:);
ASYID=ASYID(ifilt,:);
BURNUP=BURNUP(ifilt,:);
CRHIS=CRHIS(ifilt,:);
%ASYWEI=ASYWEI(ifilt,:);
%SSHIST=SSHIST(ifilt,:);
%VHIST=VHIST(ifilt,:);
IPOS=IPOS(ifilt,:);
ICYC=ICYC(ifilt,:);
ONSITE=ONSITE(ifilt);
%evsave=['save ',utfil,' ASYID ASYTYP BURNUP burnup VHIST SSHIST CYCNAM DISTFIL ICYC lastcyc '];
%evsave=[evsave,'IPOS BUSYM ITOT KHOT khot MASFIL ONSITE CHTYP NCHTYP OLDTYP'];
evsave=['save ',utfil,' ASYID ASYTYP BURNUP burnup CYCNAM DISTFIL ICYC lastcyc '];
evsave=[evsave,'IPOS BUSYM ITOT KHOT khot MASFIL ONSITE CHTYP NCHTYP OLDTYP CRHIS '];
eval(evsave);
