%@(#)   brprog7.m 1.6	 10/09/23     15:11:09
%
%function brprog7('val')
% funktion för brdnslekostnadsprognos.
% körs från /cm/fx/div/bunhist/fcc
% använder indata från /cm/fx/div/bunhist/fcc/inbrprog7.txt som default
% resultatfil: brprog7.lis
% val kan vara antingen EFPH eller GWh eller fil
% Om val=efph beräknas produktionen med hjälp av efph och verkningsgrad från infil
% Om val=gwh berdknas EFPH med hjälp av gwh och verkningsgrad från infil
% Om val=fil tas efph och produktion från infil

function brprog7(val);

val=upper(val)
utfil='brprog7.lis';
fid=fopen(utfil,'w');
reakdir=findreakdir;
ii=find(reakdir=='/');
staton=upper(reakdir(ii(2)+1:ii(3)-1));
a=date;
%start inläsning av indatafil

infil=[reakdir,'div/bunhist/fcc/inbrprog7.txt'];
fidin=fopen(infil,'r');
tx=readtextfile(infil);
s=size(tx);
nyear=((s(1)-14)/13)-1;


%radnr=strmatch('CYKELAR',tx(:,1:7));
%for i=1:nyear;
%yearv(i,:)=deblank(tx(radnr+i,(1:4)));
%yearh(i,:)=deblank(tx(radnr+i,(6:end)));
%end
% Används för närvarande inte av koden

radnr=strmatch('CYKLER',tx(:,1:6));
for i=1:nyear;
cykelv(i,:)=deblank(tx(radnr+i,(1:4)));
cykelh(i,:)=deblank(tx(radnr+i,(5:end)));
end

radnr=strmatch('REVTID',tx(:,1:6));
for i=1:nyear;
rastart(i,:)=deblank(tx(radnr+i,(1:9)));
rastopp(i,:)=deblank(tx(radnr+i,(10:end)));
end

radnr=strmatch('PROGNOSBRANSLEPREFIX',tx(:,1:20));
for i=1:nyear;
progtyp(i,:)=deblank(tx(radnr+i,(1:4)));
progid(i,:)=deblank(tx(radnr+i,(6:end)));
end

radnr=strmatch('BRANSLEVIKTER',tx(:,1:13));
for i=1:nyear;
progvikt(i,:)=deblank(tx(radnr+i,(1:end)));
end

radnr=strmatch('LADDMANGD',tx(:,1:9));
for i=1:nyear;
laddmangd(i,:)=deblank(tx(radnr+i,(1:end)));
end

radnr=strmatch('PROGNOSPROD',tx(:,1:11));
for i=1:nyear;
GWHV(i,:)=deblank(tx(radnr+i,(1:4)));
GWHH(i,:)=deblank(tx(radnr+i,(6:end)));
end

radnr=strmatch('CYKELLANGD',tx(:,1:11));
for i=1:nyear;
EFPHV(i,:)=deblank(tx(radnr+i,(1:4)));
EFPHH(i,:)=deblank(tx(radnr+i,(6:end)));
end

radnr=strmatch('NOMPOW',tx(:,1:6));
for i=1:nyear;
nompow(i,:)=deblank(tx(radnr+i,(1:4)));
end

radnr=strmatch('VERKNINGSGRAD',tx(:,1:13));
for i=1:nyear;
verknv(i,:)=deblank(tx(radnr+i,(1:4)));
verknh(i,:)=deblank(tx(radnr+i,(6:end)));
end

radnr=strmatch('POW',tx(:,1:3));
for i=1:nyear;
powv(i,:)=deblank(tx(radnr+i,(1:4)));
powh(i,:)=deblank(tx(radnr+i,(5:end)));
end

radnr=strmatch('FLOW',tx(:,1:4));
for i=1:nyear;
flowv(i,:)=deblank(tx(radnr+i,(1:5)));
flowh(i,:)=deblank(tx(radnr+i,(6:end)));
end

radnr=strmatch('TLOWP',tx(:,1:5));
for i=1:nyear;
tlowpv(i,:)=deblank(tx(radnr+i,(1:5)));
tlowph(i,:)=deblank(tx(radnr+i,(6:end)));
end

radnr=strmatch('RANKFIL',tx(:,1:7));
for i=1:nyear;
rankfil(i,:)=deblank(tx(radnr+i,(1:end)));
end

radnr=strmatch('EOCFIL',tx(:,1:6));
eocfil(1,:)=deblank(tx(radnr+1,(1:end)));

radnr=strmatch('ASYIDFIL',tx(:,1:8));
asyidold(1,:)=deblank(tx(radnr+1,(1:end)));

radnr=strmatch('BUNDLE_BASSFIL',tx(:,1:14));
bundlebassold(1,:)=deblank(tx(radnr+1,(1:end)));

radnr=strmatch('CR_BASSFIL',tx(:,1:10));
crbassold(1,:)=deblank(tx(radnr+1,(1:end)));
%slut inläsning av indatafil


% formatbyte string -> tal
progvikt=str2num(progvikt);
laddmangd=str2num(laddmangd);
verknv=str2num(verknv);
verknh=str2num(verknh);
GWHV=str2num(GWHV);
GWHH=str2num(GWHH);
EFPHV=str2num(EFPHV);
EFPHH=str2num(EFPHH);
nompow=str2num(nompow);

% Raknar ut EFPH om man bara vet GWH
if strncmp('GWH',val,3)==1;
for j=1:length(GWHV);
gwh2efphv(j)=1e5/(verknv(j)*nompow(j));
gwh2efphh(j)=1e5/(verknh(j)*nompow(j));
EFPHV(j)=gwh2efphv(j)*GWHV(j);
EFPHH(j)=gwh2efphh(j)*GWHH(j);
end
end
% Raknar ut GWH om man bara vet EFPH
if strncmp('EFPH',val,4)==1;
for j=1:length(EFPHV);
gwh2efphv(j)=1e5/(verknv(j)*nompow(j));
gwh2efphh(j)=1e5/(verknh(j)*nompow(j));
GWHV(j)=EFPHV(j)/gwh2efphv(j);
GWHH(j)=EFPHH(j)/gwh2efphh(j);
end
end

%skapar indata till skyffel (asytyp.txt och asyid.txt skapas för nya cykeln)
for i=1:nyear;
rankbyt(eocfil(1,:),rankfil(i,:),3,progid(i,:),progtyp(i,:),progvikt(i),laddmangd(i));
asytypfil=['pol/asytyp.txt'];
asyidfil=['refu/asyid.txt'];
ramsa1=['!cp pol/asytyp.txt pol/asytyp-',cykelh(i,:),'.txt'];
ramsa2=['!cp refu/asyid.txt refu/asyid-prog-',cykelh(i,:),'.txt'];
eval(ramsa1)
eval(ramsa2)

%skriver till sky-inp-fil
sky_inpfil=['refu/sky-inp-',cykelh(i,:),'.txt'];
skyfid=fopen(sky_inpfil,'w');
fprintf(skyfid,['TITLE   Refuelling to progcycle ',cykelh(i,:)]);
fprintf(skyfid,'\n');
fprintf(skyfid,['IDENT   ',staton]);
fprintf(skyfid,'\n');
fprintf(skyfid,['PRIFIL   refu/print-sky-prog-',cykelh(i,:),'.txt']);
fprintf(skyfid,'\n');
fprintf(skyfid,['ATPNEW   pol/asytyp.txt']);
fprintf(skyfid,'\n');
fprintf(skyfid,['AIDOLD  ',asyidold]);
fprintf(skyfid,'\n');
fprintf(skyfid,['AIDNEW   refu/asyid-prog-',cykelh(i,:),'.txt']);
fprintf(skyfid,'\n');
fprintf(skyfid,['FUSOLD  ',bundlebassold]);
fprintf(skyfid,'\n');
fprintf(skyfid,['FUSNEW   bass/bundle-prog-',cykelh(i,:),'.txt']);
fprintf(skyfid,'\n');
fprintf(skyfid,['CRSOLD  ',crbassold]);
fprintf(skyfid,'\n');
fprintf(skyfid,['CRSNEW   bass/cr-prog-',cykelh(i,:),'.txt']);
fprintf(skyfid,'\n');
fprintf(skyfid,['EOCDIS  ',eocfil]);
fprintf(skyfid,'\n');
fprintf(skyfid,['BOCDIS   dist/bo',cykelh(i,:),'-prog.dat']);
fprintf(skyfid,'\n');
fprintf(skyfid,['SHUTD   ',rastart(i,1:4),' ',rastart(i,5:6),' ',rastart(i,7:8)]);
fprintf(skyfid,'\n');
fprintf(skyfid, ['START   ',rastopp(i,1:4),' ',rastopp(i,5:6),' ',rastopp(i,7:8)]);
fprintf(skyfid,'\n');

% kör skyffel (bocfil skapas)
runskyffelramsa=['!skyffel refu/sky-inp-',cykelh(i,:),'.txt'];
eval(runskyffelramsa)

% skapar comp-fil för att få in KHOT i bocfilen
compfil=['off/comp-khot.txt']; kcomp=fopen(compfil,'w');
fprintf(kcomp,['TITLE        KHOT, KCOLD Calc']);
fprintf(kcomp,'\n');
fprintf(kcomp,['SOUFIL    pol/source-prog.txt']);
fprintf(kcomp,'\n');
fprintf(kcomp,['PRIFIL    off/print-khot.txt']);
fprintf(kcomp,'\n');
fprintf(kcomp,['IDENT     ',staton]);
fprintf(kcomp,'\n');
fprintf(kcomp,['OPTION    POWER,NOPOST,TLOWP']);
fprintf(kcomp,'\n');
fprintf(kcomp,['ITERA     1, 10, 0.5, 1.01000, 0']);
fprintf(kcomp,'\n');
fprintf(kcomp,['INIT       dist/bo',cykelh(i,:),'-prog.dat =HISTORY,BASIC']);
fprintf(kcomp,'\n');
fprintf(kcomp,['SAVE       dist/bo',cykelh(i,:),'-prog.dat = HISTORY,BASIC,KHOT,KCOLD']);
fprintf(kcomp,'\n'); fprintf(kcomp,['SYMME     1']);
fprintf(kcomp,'\n'); fprintf(kcomp,['PRINT']); fprintf(kcomp,'\n');
fprintf(kcomp,['SUMFIL']);
fprintf(kcomp,'\n');
fprintf(kcomp,['INCLUD    ',reakdir,'pol/fyrgrp.txt = MANGRP']);
fprintf(kcomp,'\n');
fprintf(kcomp,['POWER     ',powh(i,:)]);
fprintf(kcomp,'\n');
fprintf(kcomp,['FLOW      ',flowh(i,:)]);
fprintf(kcomp,'\n');
fprintf(kcomp,['PRESS     70.0']);
fprintf(kcomp,'\n');
fprintf(kcomp,['XCU           ']);
fprintf(kcomp,'\n');
fprintf(kcomp,['TABLE      0.3']);
fprintf(kcomp,'\n');
fprintf(kcomp,['TLOWP    ',tlowph(i,:)]);
fprintf(kcomp,'\n');
fprintf(kcomp,['CONROD    ALL=100']);
fprintf(kcomp,'\n');
fprintf(kcomp,['END']);
fprintf(kcomp,'\n');
fclose(kcomp);

% kör polca på comp-khot
runpolcaramsa=['!polca off/comp-khot.txt'];
eval(runpolcaramsa)

%avskrivning (avskrivning mellan eoc och boc)
bocfil=['dist/bo',cykelh(i,:),'-prog.dat']; % definierar ny bocfil
[iut,restval]=restvalue7(eocfil,bocfil,0.93,0);
n=size(iut);
sparramsa=['!cp restvalue7.lis rest-',cykelv(i,:),'.lis'];eval(sparramsa);

% skriver filhuvud i utfilen (i=1).
if i==1;
fprintf(fid,'\n');
fprintf(fid,[staton,'   ',a(1,:),'    bränslekostnadsprognos']); 	fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,[rastart(i,1:4)]);
fprintf(fid,'\n');
fprintf(fid,['====']);
fprintf(fid,'\n');
fprintf(fid,'\n');
end
% skriver ut info EFTER REV i utfilen (i=1 och i>1)
fprintf(fid,['Bytesmängd vid RA-',rastart(i,1:4),'                       ',num2str(n(1),3),' Färska patroner']);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,['Avskrivningskostnad vid RA-',rastart(i,1:4),'              ',num2str(restval,3),' MSEK']);
fprintf(fid,'\n');
fprintf(fid,'\n');

% Fixar till en compfil boc-eoy
initfil=['dist/bo',cykelh(i,:),'-prog.dat'];
savefil=['dist/eoy',rastart(i,1:4),'-prog.dat'];
compfil=['off/comp-',cykelh(i,:),'-h.txt'];
hcomp=fopen(compfil,'w');
fprintf(hcomp,['TITLE      BOC TILL EOY',cykelh(i,:)]);
fprintf(hcomp,'\n');
fprintf(hcomp,['SOUFIL    pol/source-prog.txt']);
fprintf(hcomp,'\n');
fprintf(hcomp,['PRIFIL    off/output.txt']);
fprintf(hcomp,'\n');
fprintf(hcomp,['IDENT     ',staton]);
fprintf(hcomp,'\n');
fprintf(hcomp,['OPTION    TLOWP,BURNUP']);
fprintf(hcomp,'\n');
fprintf(hcomp,['SYMME     1']);
fprintf(hcomp,'\n');
fprintf(hcomp,['INIT      ',initfil,'= HISTORY,BASIC']);
fprintf(hcomp,'\n');
fprintf(hcomp,['SAVE      ',savefil,'= HISTORY,BASIC,EFPH,KHOT']);
fprintf(hcomp,'\n');
fprintf(hcomp,['INCLUD    ',reakdir,'pol/fyrgrp.txt = MANGRP']);
fprintf(hcomp,'\n');
fprintf(hcomp,['SUMFIL']);
fprintf(hcomp,'\n');
fprintf(hcomp,['PRINT']);
fprintf(hcomp,'\n');
fprintf(hcomp,['CONROD    ALL=100']);
fprintf(hcomp,'\n');
fprintf(hcomp, ['BURNUP     ',num2str(EFPHH(i),4),',5']);
fprintf(hcomp,'\n');
fprintf(hcomp,['POWER     ',powh(i,:)]);
fprintf(hcomp,'\n');
fprintf(hcomp,['FLOW      ',flowh(i,:)]);
fprintf(hcomp,'\n');
fprintf(hcomp,['PRESS     70.0']);
fprintf(hcomp,'\n')
fprintf(hcomp,['XCU           ']);
fprintf(hcomp,'\n');
fprintf(hcomp,['TABLE      0.3']);
fprintf(hcomp,'\n');
fprintf(hcomp,['TLOWP     ',tlowph(i,:)]);
fprintf(hcomp,'\n');
fprintf(hcomp,['END']);
fprintf(hcomp,'\n');
fclose(hcomp);
runpolcaramsa=['!polca off/comp-',cykelh(i,:),'-h.txt'];
eval(runpolcaramsa)
%brdnslekostnad boc-->eoy
[TWh,orekWhtot,kostnad]=fuelcost7(initfil,savefil,GWHH(i)/1000,0,0,0);
kostnad=sum(kostnad);
sparramsa=['!cp fuelcost7.lis fuelcosth-',cykelh(i,:),'.lis']; eval(sparramsa);

% skriver ut info EFTER REV i utfil
fprintf(fid,['Fulleffekttimmar efter revision              ',num2str(EFPHH(i),4),' EFPH']);
fprintf(fid,'\n');
fprintf(fid,['Produktion efter revision                    ',num2str(GWHH(i),4),' GWh']);
fprintf(fid,'\n');
fprintf(fid,['Bränslekostnad efter revision:               ',num2str(kostnad,4),' MSEK']);
fprintf(fid,'\n');
fprintf(fid,['Specifik Bränslekostnad efter revision:      ',num2str(orekWhtot,3),' öre/kWh']);
fprintf(fid,'\n');

% avslutar sista cykeln.
if i==nyear
disp(['Sammanställning finns på fil: brprog7.lis']);
break
end
% om det inte är sista cykeln så fortsätter vi...

fprintf(fid,'\n');
fprintf(fid,[rastart(i+1,1:4)]);
fprintf(fid,'\n');
fprintf(fid,[ '====']);
fprintf(fid,'\n');
fprintf(fid,'\n');

% tillverkning av comp-fil eoy till eoc
initfil=savefil;
savefil=['dist/eo',cykelv(i+1,:),'-prog.dat'];
compfil=['off/comp-',cykelv(i+1,:),'-v.txt'];
vcomp=fopen(compfil,'w');
fprintf(vcomp,['TITLE      EOY TILL EOC',cykelv(i+1,:)]); 
fprintf(vcomp,'\n');
fprintf(vcomp,['SOUFIL    pol/source-prog.txt']);
fprintf(vcomp,'\n'); 
fprintf(vcomp,['PRIFIL    off/output.txt']);
fprintf(vcomp,'\n'); 
fprintf(vcomp,['IDENT     ',staton]); 
fprintf(vcomp,'\n');
fprintf(vcomp,['OPTION    TLOWP,BURNUP']);
fprintf(vcomp,'\n');
fprintf(vcomp,['SYMME     1']);
fprintf(vcomp,'\n');
fprintf(vcomp,['INIT      ',initfil,'= HISTORY,BASIC']);
fprintf(vcomp,'\n');
fprintf(vcomp,['SAVE      ',savefil,'= HISTORY,BASIC,EFPH,KHOT']); fprintf(vcomp,'\n');
fprintf(vcomp,['INCLUD    ',reakdir,'pol/fyrgrp.txt = MANGRP']);
fprintf(vcomp,'\n');
fprintf(vcomp,['SUMFIL']);
fprintf(vcomp,'\n');
fprintf(vcomp,['PRINT']);
fprintf(vcomp,'\n');
fprintf(vcomp,['CONROD    ALL=100']);
fprintf(vcomp,'\n');
fprintf(vcomp, ['BURNUP     ',num2str(EFPHV(i+1),4),',5']);
fprintf(vcomp,'\n');
fprintf(vcomp,['POWER     ',powv(i+1,:)]);
fprintf(vcomp,'\n');
fprintf(vcomp,['FLOW      ',flowv(i+1,:)]);
fprintf(vcomp,'\n');
fprintf(vcomp,['PRESS     70.0']);
fprintf(vcomp,'\n');
fprintf(vcomp,['XCU           ']);
fprintf(vcomp,'\n');
fprintf(vcomp,['TABLE      0.3']);
fprintf(vcomp,'\n');
fprintf(vcomp,['TLOWP     ',tlowpv(i+1,:)]);
fprintf(vcomp,'\n');
fprintf(vcomp,['END']);
fprintf(vcomp,'\n');
fclose(vcomp);
runpolcaramsa=['!polca off/comp-',cykelv(i+1,:),'-v.txt'];
eval(runpolcaramsa)
[TWh,orekWhtot,kostnad]=fuelcost7(initfil,savefil,GWHV(i+1)/1000,0,0,0);
kostnad=sum(kostnad);
sparramsa=['!cp fuelcost7.lis fuelcostv-',cykelv(i+1,:),'.lis'];
eval(sparramsa);
aidnew=asyidold;
asyidold=['refu/asyid-prog-',cykelv(i+1,:),'.txt'];
fubassfil=['bass/bundle-prog-',cykelv(i+1,:),'.txt'];
crbassfil=['bass/cr-prog-',cykelv(i+1,:),'.txt'];
eocfil=savefil;
% skriver ut info före revision i utfil.
fprintf(fid,['Fulleffekttimmar före revision               ',num2str(EFPHV(i+1),4),' EFPH']);
fprintf(fid,'\n');
fprintf(fid,['Produktion före revision                     ',num2str(GWHV(i+1),4),' GWh']);
fprintf(fid,'\n');
fprintf(fid,['Bränslekostnad före revision:               ',num2str(kostnad,4),' MSEK']);
fprintf(fid,'\n');
fprintf(fid,['Specifik Brdnslekostnad före revision:      ',num2str(orekWhtot,3),' öre/kWh']);
fprintf(fid,'\n');
fprintf(fid,'\n');
end
