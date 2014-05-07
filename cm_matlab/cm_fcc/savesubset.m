%@(#)   savesubset.m 1.3	 97/10/31     10:50:19
%
%function  savesubset(infil,utfil,ifilt);
function  savesubset(infil,utfil,ifilt);
load(infil)
kinf=kinf(ifilt);
lastcyc=lastcyc(ifilt);
burnup=burnup(ifilt);
BUSYM=BUSYM(ifilt,:);
BUNTYP=BUNTYP(ifilt,:);
OLDTYP=OLDTYP(ifilt,:);
CHTYP=CHTYP(ifilt);
NCHTYP=NCHTYP(ifilt);
ITOT=ITOT(ifilt);
KINF=KINF(ifilt,:);
BUIDNT=BUIDNT(ifilt,:);
BURNUP=BURNUP(ifilt,:);
SSHIST=SSHIST(ifilt,:);
VHIST=VHIST(ifilt,:);
IPOS=IPOS(ifilt,:);
ICYC=ICYC(ifilt,:);
ONSITE=ONSITE(ifilt);
evsave=['save ',utfil,' BUIDNT BUNTYP BURNUP burnup VHIST SSHIST CYCNAM DISTFIL ICYC lastcyc '];
evsave=[evsave,'IPOS BUSYM ITOT KINF kinf MASFIL ONSITE CHTYP NCHTYP OLDTYP'];
eval(evsave);
