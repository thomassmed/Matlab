% Defines parameters for cd-file reading

% Source = cm-cg-globals.h
NFTMAX=999;

% Source = cmlib-ctadrs.h
INTSIZ=100;
IADSIZ=500;

MAINPO=2;
ADRAPO=3;
FREEPO=4;

NCRMAB=15;
NSGMAB=5;

CDVERS=090815;
NCDREC=32;

XNHEADCD=1;
XNEVENT=1;
XNSTATUS=1;
XNTITLE=20;
XNSCALES=1;
NHEADT=XNHEADCD+XNEVENT+XNSTATUS+XNTITLE+XNSCALES;

NOLDHT=9;

XNSYM=1;
XNGRIDF=1;
XNVAL=1;
XNMMPAR=1;
NNEWPA=XNSYM+XNGRIDF+XNVAL+XNMMPAR;

% Source = cmlib-ctdat1.h
IMASIZ=2*IADSIZ;

NROFMT=54;
NROFTA=650;

NCDADD=650;

% Source = simula/tdata.F90
MAINTAB={
'XSEC    ' ,  8, 0
'DISFAC  ' , 16, 0
'PINPOW  ' ,  1, 0
'FINT    ' ,  1, 0
'DETAB1  ' ,  4, 0
'DETAB2  ' ,  4, 0
'DIFFSG  ' , 11, 1
'DIFFCR  ' , 14, 1
'DPPMCR  ' ,  1, 0
'HISTCR  ' , 30, 0
'DIFFBO  ' , 12, 0
'DOPPXS  ' ,  9, 1
'HISTXS  ' , 30, 0
'FDATA   ' ,  3, 4
'PINFM   ' ,  1, 0
'DPFMCR  ' ,  1, 0
'FMNRM   ' ,  2, 1
'PINBUR  ' ,  1, 0
'DISFCR  ' , 16, 0
'GDETPW  ' ,  1, 0
'BAXS    ' ,  2, 0
'BAXSCR  ' ,  2, 0
'RBXS    ' ,  2, 0
'RBXSCR  ' ,  2, 0
'ENRICH  ' ,  1, 0
'BAMAPS  ' ,  2, 0   % Main groups BAPOIS and BACONT in CoreLink Methodology
'FPROXS  ' , 30, 0
'FPROCR  ' , 30, 0
'DOPPCR  ' ,  8, 0
'HISTBO  ' , 30, 0
'ISOTOP  ' ,  2, 0
'DYNAM   ' , 25, 1
'IMPFAC  ' , 12, 0
'CRDEPL  ' ,  3, 0   % Provided by CRDEPL
'CRDEPLXS' ,  4, 0
'DPPHIS  ' ,  4, 0   % Not provided by CoreLink
'DFCHIS  ' ,  2, 8   % Not provided by CoreLink
'DPPCIN  ' ,  1, 0
'DPPCUT  ' ,  1, 0
'DPPCUD  ' ,  1, 0
'DDFCIN  ' , 16, 0   % Not provided by CoreLink
'DDFCUT  ' , 16, 0   % Not provided by CoreLink
'DDFCUD  ' , 16, 0   % Not provided by CoreLink
'XSMOM   ' , 10, 0   % Not provided by CoreLink
'XSMOCR  ' , 10, 0   % Not provided by CoreLink
'BAXSBO  ' ,  2, 0
'DIFFBOCR' ,  6, 0
'XENON   ' ,  7, 0
'XENOCR  ' ,  7, 0
'HISTXE  ' , 30, 0
'FPROXE  ' , 30, 0
'DYNAMCR ' , 14, 0
'IMPFCR  ' , 12, 0
'KINPAR  ' ,130, 0};


TABLES={   
    'D1    ' ,     1    % XSEC
    'D2    ' ,     1    % XSEC
    'SIGR  ' ,     1    % XSEC
    'SIGA1 ' ,     1    % XSEC
    'SIGA2 ' ,     1    % XSEC
    'NSF1  ' ,     1    % XSEC
    'NSF2  ' ,     1    % XSEC
    'NY/E  ' ,     1    % XSEC
    'DFO11 ' ,     1    % DISFAC
    'DFO12 ' ,     1    % DISFAC
    'DFO21 ' ,     1    % DISFAC
    'DFO22 ' ,     1    % DISFAC
    'DFO31 ' ,     1    % DISFAC
    'DFO32 ' ,     1    % DISFAC
    'DFO41 ' ,     1    % DISFAC
    'DFO42 ' ,     1    % DISFAC
    'DFO51 ' ,     1    % DISFAC
    'DFO52 ' ,     1    % DISFAC
    'DFO61 ' ,     1    % DISFAC
    'DFO62 ' ,     1    % DISFAC
    'DFO71 ' ,     1    % DISFAC
    'DFO72 ' ,     1    % DISFAC
    'DFO81 ' ,     1    % DISFAC
    'DFO82 ' ,     1    % DISFAC
    'PINPOW' ,     6    % PINPOW
    'FINT  ' ,     1    % FINT
    'DET11 ' ,     1    % DETAB1
    'DET12 ' ,     1    % DETAB1
    'DETF11' ,     1    % DETAB1
    'DETF12' ,     1    % DETAB1
    'DET21 ' ,     1    % DETAB2
    'DET22 ' ,     1    % DETAB2
    'DETF21' ,     1    % DETAB2
    'DETF22' ,     1    % DETAB2
    'SD1   ' ,     1    % DIFFSG
    'SD2   ' ,     1    % DIFFSG
    'SSIGR ' ,     1    % DIFFSG
    'SSIGA1' ,     1    % DIFFSG
    'SSIGA2' ,     1    % DIFFSG
    'SNSF1 ' ,     1    % DIFFSG
    'SNSF2 ' ,     1    % DIFFSG
    'SNY/E ' ,     1    % DIFFSG
    'SDET11' ,     1    % DIFFSG
    'SDET12' ,     1    % DIFFSG
    'MISC  ' ,    11    % DIFFSG
    'CD1   ' ,     1    % DIFFCR
    'CD2   ' ,     1    % DIFFCR
    'CSIGR ' ,     1    % DIFFCR
    'CSIGA1' ,     1    % DIFFCR
    'CSIGA2' ,     1    % DIFFCR
    'CNSF1 ' ,     1    % DIFFCR
    'CNSF2 ' ,     1    % DIFFCR
    'CNY/E ' ,     1    % DIFFCR
    'CDFINT' ,     1    % DIFFCR
    'CDET11' ,     1    % DIFFCR
    'CDET12' ,     1    % DIFFCR
    'CDET21' ,     1    % DIFFCR
    'CSSA2'  ,     1    % DIFFCR
    'MISC  ' ,    11    % DIFFCR
    'CPINPO' ,     6    % DPPMCR
    'CH5SA1' ,     1    % HISTCR
    'CH5SA2' ,     1    % HISTCR
    'CH5NF1' ,     1    % HISTCR
    'CH5NF2' ,     1    % HISTCR
    'CH8SA1' ,     1    % HISTCR
    'CH8SA2' ,     1    % HISTCR
    'CH8NF1' ,     1    % HISTCR
    'CH9SA1' ,     1    % HISTCR
    'CH9SA2' ,     1    % HISTCR
    'CH9NF1' ,     1    % HISTCR
    'CH9NF2' ,     1    % HISTCR
    'CH0SA1' ,     1    % HISTCR
    'CH0SA2' ,     1    % HISTCR
    'CH0NF1' ,     1    % HISTCR
    'CH0NF2' ,     1    % HISTCR
    'CH1SA1' ,     1    % HISTCR
    'CH1SA2' ,     1    % HISTCR
    'CH1NF1' ,     1    % HISTCR
    'CH1NF2' ,     1    % HISTCR
    'CH2SA1' ,     1    % HISTCR
    'CH2SA2' ,     1    % HISTCR
    'CH2NF1' ,     1    % HISTCR
    'CA1SA1' ,     1    % HISTCR
    'CA1SA2' ,     1    % HISTCR
    'CA1NF1' ,     1    % HISTCR
    'CA1NF2' ,     1    % HISTCR
    'CA2SA1' ,     1    % HISTCR
    'CA2SA2' ,     1    % HISTCR
    'CA2NF1' ,     1    % HISTCR
    'CA2NF2' ,     1    % HISTCR
    'BD1   ' ,     1    % DIFFBO
    'BD2   ' ,     1    % DIFFBO
    'BSIGR ' ,     1    % DIFFBO
    'BSIGA1' ,     1    % DIFFBO
    'BSIGA2' ,     1    % DIFFBO
    'BNSF1 ' ,     1    % DIFFBO
    'BNSF2 ' ,     1    % DIFFBO
    'BNY/E ' ,     1    % DIFFBO
    'BDET11' ,     1    % DIFFBO
    'BDET12' ,     1    % DIFFBO
    'BDET21' ,     1    % DIFFBO
    'BSAXE2' ,     1    % DIFFBO
    'DPSIGR' ,     1    % DOPPXS
    'DOPSA1' ,     1    % DOPPXS
    'DOPSA2' ,     1    % DOPPXS
    'DPNSF1' ,     1    % DOPPXS
    'DPNSF2' ,     1    % DOPPXS
    'U38DOP' ,     1    % DOPPXS
    'P40DOP' ,     1    % DOPPXS
    'P42DOP' ,     1    % DOPPXS
    'MISC  ' ,    11    % DOPPXS
    'H35SA1' ,     1    % HISTXS
    'H35SA2' ,     1    % HISTXS
    'H35NF1' ,     1    % HISTXS
    'H35NF2' ,     1    % HISTXS
    'H38SA1' ,     1    % HISTXS
    'H38SA2' ,     1    % HISTXS
    'H38NF1' ,     1    % HISTXS
    'H39SA1' ,     1    % HISTXS
    'H39SA2' ,     1    % HISTXS
    'H39NF1' ,     1    % HISTXS
    'H39NF2' ,     1    % HISTXS
    'H40SA1' ,     1    % HISTXS
    'H40SA2' ,     1    % HISTXS
    'H40NF1' ,     1    % HISTXS
    'H40NF2' ,     1    % HISTXS
    'H41SA1' ,     1    % HISTXS
    'H41SA2' ,     1    % HISTXS
    'H41NF1' ,     1    % HISTXS
    'H41NF2' ,     1    % HISTXS
    'H42SA1' ,     1    % HISTXS
    'H42SA2' ,     1    % HISTXS
    'H42NF1' ,     1    % HISTXS
    'HA1SA1' ,     1    % HISTXS
    'HA1SA2' ,     1    % HISTXS
    'HA1NF1' ,     1    % HISTXS
    'HA1NF2' ,     1    % HISTXS
    'HA2SA1' ,     1    % HISTXS
    'HA2SA2' ,     1    % HISTXS
    'HA2NF1' ,     1    % HISTXS
    'HA2NF2' ,     1    % HISTXS
    'H36SA1' ,     1    % FDATA
    'H36SA2' ,     1    % FDATA
    'MISC  ' ,    11    % FDATA
    'PINFM ' ,     6    % PINFM
    'CPINFM' ,     6    % DPFMCR
    'FMNRM ' ,     1    % FMNRM
    'MISC  ' ,    11    % FMNRM
    'PINBUR' ,     6    % PINBUR
    'CDFO11' ,     1    % DISFCR
    'CDFO12' ,     1    % DISFCR
    'CDFO21' ,     1    % DISFCR
    'CDFO22' ,     1    % DISFCR
    'CDFO31' ,     1    % DISFCR
    'CDFO32' ,     1    % DISFCR
    'CDFO41' ,     1    % DISFCR
    'CDFO42' ,     1    % DISFCR
    'CDFO51' ,     1    % DISFCR
    'CDFO52' ,     1    % DISFCR
    'CDFO61' ,     1    % DISFCR
    'CDFO62' ,     1    % DISFCR
    'CDFO71' ,     1    % DISFCR
    'CDFO72' ,     1    % DISFCR
    'CDFO81' ,     1    % DISFCR
    'CDFO82' ,     1    % DISFCR
    'GDETPW' ,     6    % GDETPW
    'BASA1 ' ,    21    % BAXS
    'BASA2 ' ,    21    % BAXS
    'CBASA1' ,    21    % BAXSCR
    'CBASA2' ,    21    % BAXSCR
    'RBSA1 ' ,     1    % RBXS
    'RBSA2 ' ,     1    % RBXS
    'CRBSA1' ,     1    % RBXSCR
    'CRBSA2' ,     1    % RBXSCR
    'ENRICH' ,     6    % ENRICH
    'BACONT' ,     6    % BAMAPS
    'BAPOIS' ,     6    % BAMAPS
    'FRH3A1' ,     1    % FPROXS
    'FRH3A2' ,     1    % FPROXS
    'FRH5A1' ,     1    % FPROXS
    'FRH5A2' ,     1    % FPROXS
    'FND3A1' ,     1    % FPROXS
    'FND3A2' ,     1    % FPROXS
    'FPM7A1' ,     1    % FPROXS
    'FPM7A2' ,     1    % FPROXS
    'FPM8A1' ,     1    % FPROXS
    'FPM8A2' ,     1    % FPROXS
    'FPM8M1' ,     1    % FPROXS
    'FPM8M2' ,     1    % FPROXS
    'FSM7A1' ,     1    % FPROXS
    'FSM7A2' ,     1    % FPROXS
    'FSM9A1' ,     1    % FPROXS
    'FSM9A2' ,     1    % FPROXS
    'FSM0A1' ,     1    % FPROXS
    'FSM0A2' ,     1    % FPROXS
    'FSM1A1' ,     1    % FPROXS
    'FSM1A2' ,     1    % FPROXS
    'FSM2A1' ,     1    % FPROXS
    'FSM2A2' ,     1    % FPROXS
    'FEU3A1' ,     1    % FPROXS
    'FEU3A2' ,     1    % FPROXS
    'FEU4A1' ,     1    % FPROXS
    'FEU4A2' ,     1    % FPROXS
    'FEU5A1' ,     1    % FPROXS
    'FEU5A2' ,     1    % FPROXS
    'FGD5A1' ,     1    % FPROXS
    'FGD5A2' ,     1    % FPROXS
    'CRH3A1' ,     1    % FPROCR
    'CRH3A2' ,     1    % FPROCR
    'CRH5A1' ,     1    % FPROCR
    'CRH5A2' ,     1    % FPROCR
    'CND3A1' ,     1    % FPROCR
    'CND3A2' ,     1    % FPROCR
    'CPM7A1' ,     1    % FPROCR
    'CPM7A2' ,     1    % FPROCR
    'CPM8A1' ,     1    % FPROCR
    'CPM8A2' ,     1    % FPROCR
    'CPM8M1' ,     1    % FPROCR
    'CPM8M2' ,     1    % FPROCR
    'CSM7A1' ,     1    % FPROCR
    'CSM7A2' ,     1    % FPROCR
    'CSM9A1' ,     1    % FPROCR
    'CSM9A2' ,     1    % FPROCR
    'CSM0A1' ,     1    % FPROCR
    'CSM0A2' ,     1    % FPROCR
    'CSM1A1' ,     1    % FPROCR
    'CSM1A2' ,     1    % FPROCR
    'CSM2A1' ,     1    % FPROCR
    'CSM2A2' ,     1    % FPROCR
    'CEU3A1' ,     1    % FPROCR
    'CEU3A2' ,     1    % FPROCR
    'CEU4A1' ,     1    % FPROCR
    'CEU4A2' ,     1    % FPROCR
    'CEU5A1' ,     1    % FPROCR
    'CEU5A2' ,     1    % FPROCR
    'CGD5A1' ,     1    % FPROCR
    'CGD5A2' ,     1    % FPROCR
    'CDPSGR' ,     1    % DOPPCR
    'CDPSA1' ,     1    % DOPPCR
    'CDPSA2' ,     1    % DOPPCR
    'CDPNF1' ,     1    % DOPPCR
    'CDPNF2' ,     1    % DOPPCR
    'CU38DO' ,     1    % DOPPCR
    'CP40DO' ,     1    % DOPPCR
    'CP42DO' ,     1    % DOPPCR
    'BH5SA1' ,     1    % HISTBO
    'BH5SA2' ,     1    % HISTBO
    'BH5NF1' ,     1    % HISTBO
    'BH5NF2' ,     1    % HISTBO
    'BH8SA1' ,     1    % HISTBO
    'BH8SA2' ,     1    % HISTBO
    'BH8NF1' ,     1    % HISTBO
    'BH9SA1' ,     1    % HISTBO
    'BH9SA2' ,     1    % HISTBO
    'BH9NF1' ,     1    % HISTBO
    'BH9NF2' ,     1    % HISTBO
    'BH0SA1' ,     1    % HISTBO
    'BH0SA2' ,     1    % HISTBO
    'BH0NF1' ,     1    % HISTBO
    'BH0NF2' ,     1    % HISTBO
    'BH1SA1' ,     1    % HISTBO
    'BH1SA2' ,     1    % HISTBO
    'BH1NF1' ,     1    % HISTBO
    'BH1NF2' ,     1    % HISTBO
    'BH2SA1' ,     1    % HISTBO
    'BH2SA2' ,     1    % HISTBO
    'BH2NF1' ,     1    % HISTBO
    'BA1SA1' ,     1    % HISTBO
    'BA1SA2' ,     1    % HISTBO
    'BA1NF1' ,     1    % HISTBO
    'BA1NF2' ,     1    % HISTBO
    'BA2SA1' ,     1    % HISTBO
    'BA2SA2' ,     1    % HISTBO
    'BA2NF1' ,     1    % HISTBO
    'BA2NF2' ,     1    % HISTBO
    'PU238 ' ,     1    % ISOTOP
    'XE135 ' ,     1    % ISOTOP
    'SPEED1' ,     1    % DYNAM
    'SPEED2' ,     1    % DYNAM
    'BETA11' ,     1    % DYNAM
    'BETA12' ,     1    % DYNAM
    'BETA21' ,     1    % DYNAM
    'BETA22' ,     1    % DYNAM
    'BETA31' ,     1    % DYNAM
    'BETA32' ,     1    % DYNAM
    'BETA41' ,     1    % DYNAM
    'BETA42' ,     1    % DYNAM
    'BETA51' ,     1    % DYNAM
    'BETA52' ,     1    % DYNAM
    'BETA61' ,     1    % DYNAM
    'BETA62' ,     1    % DYNAM
    'EDEPNT' ,     1    % DYNAM
    'EDEPNC' ,     1    % DYNAM
    'EDEPNB' ,     1    % DYNAM
    'EDEPNI' ,     1    % DYNAM
    'EDEPNE' ,     1    % DYNAM
    'EDEPGT' ,     1    % DYNAM
    'EDEPGC' ,     1    % DYNAM
    'EDEPGB' ,     1    % DYNAM
    'EDEPGI' ,     1    % DYNAM
    'EDEPGE' ,     1    % DYNAM
    'MISC  ' ,    11    % DYNAM
    'IBAR11' ,     1    % IMPFAC
    'IBAR12' ,     1    % IMPFAC
    'IBAR21' ,     1    % IMPFAC
    'IBAR22' ,     1    % IMPFAC
    'IBAR31' ,     1    % IMPFAC
    'IBAR32' ,     1    % IMPFAC
    'IBAR41' ,     1    % IMPFAC
    'IBAR42' ,     1    % IMPFAC
    'IBAR51' ,     1    % IMPFAC
    'IBAR52' ,     1    % IMPFAC
    'IBAR61' ,     1    % IMPFAC
    'IBAR62' ,     1    % IMPFAC
    'CRDS1 ' ,     1    % CRDEPL
    'CRDS2 ' ,     1    % CRDEPL
    'CRDFLX' ,     1    % CRDEPL
    'CRDREM' ,     1    % CRDEPLXS
    'CRDSA1' ,     1    % CRDEPLXS
    'CRDSA2' ,     1    % CRDEPLXS
    'CRDNSF' ,     1    % CRDEPLXS
    'ACRIN ' ,     6    % DPPHIS
    'BCRUT ' ,     6    % DPPHIS
    'DPCRIN' ,     6    % DPPHIS
    'DPCRUT' ,     6    % DPPHIS
    'DFHDUM' ,     1    % DFCHIS
    'MISC  ' ,    11    % DFCHIS
    'DPPCIN' ,     6    % DPPCIN
    'DPPCUT' ,     6    % DPPCUT
    'DPPCUD' ,     6    % DPPCUD
    'DFIN11' ,     1    % DDFCIN
    'DFIN12' ,     1    % DDFCIN
    'DFIN21' ,     1    % DDFCIN
    'DFIN22' ,     1    % DDFCIN
    'DFIN31' ,     1    % DDFCIN
    'DFIN32' ,     1    % DDFCIN
    'DFIN41' ,     1    % DDFCIN
    'DFIN42' ,     1    % DDFCIN
    'DFIN51' ,     1    % DDFCIN
    'DFIN52' ,     1    % DDFCIN
    'DFIN61' ,     1    % DDFCIN
    'DFIN62' ,     1    % DDFCIN
    'DFIN71' ,     1    % DDFCIN
    'DFIN72' ,     1    % DDFCIN
    'DFIN81' ,     1    % DDFCIN
    'DFIN82' ,     1    % DDFCIN
    'DFUT11' ,     1    % DDFCUT
    'DFUT12' ,     1    % DDFCUT
    'DFUT21' ,     1    % DDFCUT
    'DFUT22' ,     1    % DDFCUT
    'DFUT31' ,     1    % DDFCUT
    'DFUT32' ,     1    % DDFCUT
    'DFUT41' ,     1    % DDFCUT
    'DFUT42' ,     1    % DDFCUT
    'DFUT51' ,     1    % DDFCUT
    'DFUT52' ,     1    % DDFCUT
    'DFUT61' ,     1    % DDFCUT
    'DFUT62' ,     1    % DDFCUT
    'DFUT71' ,     1    % DDFCUT
    'DFUT72' ,     1    % DDFCUT
    'DFUT81' ,     1    % DDFCUT
    'DFUT82' ,     1    % DDFCUT
    'DFUD11' ,     1    % DDFCUD
    'DFUD12' ,     1    % DDFCUD
    'DFUD21' ,     1    % DDFCUD
    'DFUD22' ,     1    % DDFCUD
    'DFUD31' ,     1    % DDFCUD
    'DFUD32' ,     1    % DDFCUD
    'DFUD41' ,     1    % DDFCUD
    'DFUD42' ,     1    % DDFCUD
    'DFUD51' ,     1    % DDFCUD
    'DFUD52' ,     1    % DDFCUD
    'DFUD61' ,     1    % DDFCUD
    'DFUD62' ,     1    % DDFCUD
    'DFUD71' ,     1    % DDFCUD
    'DFUD72' ,     1    % DDFCUD
    'DFUD81' ,     1    % DDFCUD
    'DFUD82' ,     1    % DDFCUD
    'M1SA1 ' ,     1    % XSMOM
    'M2SA1 ' ,     1    % XSMOM
    'M1SA2 ' ,     1    % XSMOM
    'M2SA2 ' ,     1    % XSMOM
    'M1NSF1' ,     1    % XSMOM
    'M2NSF1' ,     1    % XSMOM
    'M1NSF2' ,     1    % XSMOM
    'M2NSF2' ,     1    % XSMOM
    'M1SR  ' ,     1    % XSMOM
    'M2SR  ' ,     1    % XSMOM
    'CM1SA1' ,     1    % XSMOCR
    'CM2SA1' ,     1    % XSMOCR
    'CM1SA2' ,     1    % XSMOCR
    'CM2SA2' ,     1    % XSMOCR
    'CM1SF1' ,     1    % XSMOCR
    'CM2SF1' ,     1    % XSMOCR
    'CM1SF2' ,     1    % XSMOCR
    'CM2SF2' ,     1    % XSMOCR
    'CM1SR ' ,     1    % XSMOCR
    'CM2SR ' ,     1    % XSMOCR
    'BBASA1' ,    21    % BAXSBO
    'BBASA2' ,    21    % BAXSBO
    'CBSIGR' ,     1    % DIFFBOCR
    'CBSA1 ' ,     1    % DIFFBOCR
    'CBSA2 ' ,     1    % DIFFBOCR
    'CBNSF1' ,     1    % DIFFBOCR
    'CBNSF2' ,     1    % DIFFBOCR
    'CBSAXE' ,     1    % DIFFBOCR
    'SAXE2 ' ,     1    % XENON
    'XSAXE2' ,     1    % XENON
    'XSIGR ' ,     1    % XENON
    'XSIGA1' ,     1    % XENON
    'XSIGA2' ,     1    % XENON
    'XNSF1 ' ,     1    % XENON
    'XNSF2 ' ,     1    % XENON
    'CSAXE2' ,     1    % XENOCR
    'CXSAXE' ,     1    % XENOCR
    'CXSIGR' ,     1    % XENOCR
    'CXSGA1' ,     1    % XENOCR
    'CXSGA2' ,     1    % XENOCR
    'CXNSF1' ,     1    % XENOCR
    'CXNSF2' ,     1    % XENOCR
    'XH5SA1' ,     1    % HISTXE
    'XH5SA2' ,     1    % HISTXE
    'XH5NF1' ,     1    % HISTXE
    'XH5NF2' ,     1    % HISTXE
    'XH8SA1' ,     1    % HISTXE
    'XH8SA2' ,     1    % HISTXE
    'XH8NF1' ,     1    % HISTXE
    'XH9SA1' ,     1    % HISTXE
    'XH9SA2' ,     1    % HISTXE
    'XH9NF1' ,     1    % HISTXE
    'XH9NF2' ,     1    % HISTXE
    'XH0SA1' ,     1    % HISTXE
    'XH0SA2' ,     1    % HISTXE
    'XH0NF1' ,     1    % HISTXE
    'XH0NF2' ,     1    % HISTXE
    'XH1SA1' ,     1    % HISTXE
    'XH1SA2' ,     1    % HISTXE
    'XH1NF1' ,     1    % HISTXE
    'XH1NF2' ,     1    % HISTXE
    'XH2SA1' ,     1    % HISTXE
    'XH2SA2' ,     1    % HISTXE
    'XH2NF1' ,     1    % HISTXE
    'XA1SA1' ,     1    % HISTXE
    'XA1SA2' ,     1    % HISTXE
    'XA1NF1' ,     1    % HISTXE
    'XA1NF2' ,     1    % HISTXE
    'XA2SA1' ,     1    % HISTXE
    'XA2SA2' ,     1    % HISTXE
    'XA2NF1' ,     1    % HISTXE
    'XA2NF2' ,     1    % HISTXE
    'XRH3A1' ,     1    % FPROXE
    'XRH3A2' ,     1    % FPROXE
    'XRH5A1' ,     1    % FPROXE
    'XRH5A2' ,     1    % FPROXE
    'XND3A1' ,     1    % FPROXE
    'XND3A2' ,     1    % FPROXE
    'XPM7A1' ,     1    % FPROXE
    'XPM7A2' ,     1    % FPROXE
    'XPM8A1' ,     1    % FPROXE
    'XPM8A2' ,     1    % FPROXE
    'XPM8M1' ,     1    % FPROXE
    'XPM8M2' ,     1    % FPROXE
    'XSM7A1' ,     1    % FPROXE
    'XSM7A2' ,     1    % FPROXE
    'XSM9A1' ,     1    % FPROXE
    'XSM9A2' ,     1    % FPROXE
    'XSM0A1' ,     1    % FPROXE
    'XSM0A2' ,     1    % FPROXE
    'XSM1A1' ,     1    % FPROXE
    'XSM1A2' ,     1    % FPROXE
    'XSM2A1' ,     1    % FPROXE
    'XSM2A2' ,     1    % FPROXE
    'XEU3A1' ,     1    % FPROXE
    'XEU3A2' ,     1    % FPROXE
    'XEU4A1' ,     1    % FPROXE
    'XEU4A2' ,     1    % FPROXE
    'XEU5A1' ,     1    % FPROXE
    'XEU5A2' ,     1    % FPROXE
    'XGD5A1' ,     1    % FPROXE
    'XGD5A2' ,     1    % FPROXE
    'CSPED1' ,     1    % DYNAMCR
    'CSPED2' ,     1    % DYNAMCR
    'CBET11' ,     1    % DYNAMCR
    'CBET12' ,     1    % DYNAMCR
    'CBET21' ,     1    % DYNAMCR
    'CBET22' ,     1    % DYNAMCR
    'CBET31' ,     1    % DYNAMCR
    'CBET32' ,     1    % DYNAMCR
    'CBET41' ,     1    % DYNAMCR
    'CBET42' ,     1    % DYNAMCR
    'CBET51' ,     1    % DYNAMCR
    'CBET52' ,     1    % DYNAMCR
    'CBET61' ,     1    % DYNAMCR
    'CBET62' ,     1    % DYNAMCR
    'CIBA11' ,     1    % IMPFCR
    'CIBA12' ,     1    % IMPFCR
    'CIBA21' ,     1    % IMPFCR
    'CIBA22' ,     1    % IMPFCR
    'CIBA31' ,     1    % IMPFCR
    'CIBA32' ,     1    % IMPFCR
    'CIBA41' ,     1    % IMPFCR
    'CIBA42' ,     1    % IMPFCR
    'CIBA51' ,     1    % IMPFCR
    'CIBA52' ,     1    % IMPFCR
    'CIBA61' ,     1    % IMPFCR
    'CIBA62' ,     1    % IMPFCR
    'U35NUD' ,     1    % KINPAR
    'U36NUD' ,     1    % KINPAR
    'U38NUD' ,     1    % KINPAR
    'N39NUD' ,     1    % KINPAR
    'P39NUD' ,     1    % KINPAR
    'P40NUD' ,     1    % KINPAR
    'P41NUD' ,     1    % KINPAR
    'P42NUD' ,     1    % KINPAR
    'A41NUD' ,     1    % KINPAR
    'A42NUD' ,     1    % KINPAR
    'U35F1A' ,     1    % KINPAR
    'U35F2A' ,     1    % KINPAR
    'U35F3A' ,     1    % KINPAR
    'U35F4A' ,     1    % KINPAR
    'U35F5A' ,     1    % KINPAR
    'U35F6A' ,     1    % KINPAR
    'U36F1A' ,     1    % KINPAR
    'U36F2A' ,     1    % KINPAR
    'U36F3A' ,     1    % KINPAR
    'U36F4A' ,     1    % KINPAR
    'U36F5A' ,     1    % KINPAR
    'U36F6A' ,     1    % KINPAR
    'U38F1A' ,     1    % KINPAR
    'U38F2A' ,     1    % KINPAR
    'U38F3A' ,     1    % KINPAR
    'U38F4A' ,     1    % KINPAR
    'U38F5A' ,     1    % KINPAR
    'U38F6A' ,     1    % KINPAR
    'N39F1A' ,     1    % KINPAR
    'N39F2A' ,     1    % KINPAR
    'N39F3A' ,     1    % KINPAR
    'N39F4A' ,     1    % KINPAR
    'N39F5A' ,     1    % KINPAR
    'N39F6A' ,     1    % KINPAR
    'P39F1A' ,     1    % KINPAR
    'P39F2A' ,     1    % KINPAR
    'P39F3A' ,     1    % KINPAR
    'P39F4A' ,     1    % KINPAR
    'P39F5A' ,     1    % KINPAR
    'P39F6A' ,     1    % KINPAR
    'P40F1A' ,     1    % KINPAR
    'P40F2A' ,     1    % KINPAR
    'P40F3A' ,     1    % KINPAR
    'P40F4A' ,     1    % KINPAR
    'P40F5A' ,     1    % KINPAR
    'P40F6A' ,     1    % KINPAR
    'P41F1A' ,     1    % KINPAR
    'P41F2A' ,     1    % KINPAR
    'P41F3A' ,     1    % KINPAR
    'P41F4A' ,     1    % KINPAR
    'P41F5A' ,     1    % KINPAR
    'P41F6A' ,     1    % KINPAR
    'P42F1A' ,     1    % KINPAR
    'P42F2A' ,     1    % KINPAR
    'P42F3A' ,     1    % KINPAR
    'P42F4A' ,     1    % KINPAR
    'P42F5A' ,     1    % KINPAR
    'P42F6A' ,     1    % KINPAR
    'A41F1A' ,     1    % KINPAR
    'A41F2A' ,     1    % KINPAR
    'A41F3A' ,     1    % KINPAR
    'A41F4A' ,     1    % KINPAR
    'A41F5A' ,     1    % KINPAR
    'A41F6A' ,     1    % KINPAR
    'A42F1A' ,     1    % KINPAR
    'A42F2A' ,     1    % KINPAR
    'A42F3A' ,     1    % KINPAR
    'A42F4A' ,     1    % KINPAR
    'A42F5A' ,     1    % KINPAR
    'A42F6A' ,     1    % KINPAR
    'U35F1L' ,     1    % KINPAR
    'U35F2L' ,     1    % KINPAR
    'U35F3L' ,     1    % KINPAR
    'U35F4L' ,     1    % KINPAR
    'U35F5L' ,     1    % KINPAR
    'U35F6L' ,     1    % KINPAR
    'U36F1L' ,     1    % KINPAR
    'U36F2L' ,     1    % KINPAR
    'U36F3L' ,     1    % KINPAR
    'U36F4L' ,     1    % KINPAR
    'U36F5L' ,     1    % KINPAR
    'U36F6L' ,     1    % KINPAR
    'U38F1L' ,     1    % KINPAR
    'U38F2L' ,     1    % KINPAR
    'U38F3L' ,     1    % KINPAR
    'U38F4L' ,     1    % KINPAR
    'U38F5L' ,     1    % KINPAR
    'U38F6L' ,     1    % KINPAR
    'N39F1L' ,     1    % KINPAR
    'N39F2L' ,     1    % KINPAR
    'N39F3L' ,     1    % KINPAR
    'N39F4L' ,     1    % KINPAR
    'N39F5L' ,     1    % KINPAR
    'N39F6L' ,     1    % KINPAR
    'P39F1L' ,     1    % KINPAR
    'P39F2L' ,     1    % KINPAR
    'P39F3L' ,     1    % KINPAR
    'P39F4L' ,     1    % KINPAR
    'P39F5L' ,     1    % KINPAR
    'P39F6L' ,     1    % KINPAR
    'P40F1L' ,     1    % KINPAR
    'P40F2L' ,     1    % KINPAR
    'P40F3L' ,     1    % KINPAR
    'P40F4L' ,     1    % KINPAR
    'P40F5L' ,     1    % KINPAR
    'P40F6L' ,     1    % KINPAR
    'P41F1L' ,     1    % KINPAR
    'P41F2L' ,     1    % KINPAR
    'P41F3L' ,     1    % KINPAR
    'P41F4L' ,     1    % KINPAR
    'P41F5L' ,     1    % KINPAR
    'P41F6L' ,     1    % KINPAR
    'P42F1L' ,     1    % KINPAR
    'P42F2L' ,     1    % KINPAR
    'P42F3L' ,     1    % KINPAR
    'P42F4L' ,     1    % KINPAR
    'P42F5L' ,     1    % KINPAR
    'P42F6L' ,     1    % KINPAR
    'A41F1L' ,     1    % KINPAR
    'A41F2L' ,     1    % KINPAR
    'A41F3L' ,     1    % KINPAR
    'A41F4L' ,     1    % KINPAR
    'A41F5L' ,     1    % KINPAR
    'A41F6L' ,     1    % KINPAR
    'A42F1L' ,     1    % KINPAR
    'A42F2L' ,     1    % KINPAR
    'A42F3L' ,     1    % KINPAR
    'A42F4L' ,     1    % KINPAR
    'A42F5L' ,     1    % KINPAR
    'A42F6L' ,     1};  % KINPAR

% CRTYP Tables
MANCRT={'DIFFCR  ', 'DPPMCR  ', 'HISTCR  ', 'DPFMCR  ',...
        'DISFCR  ', 'DPPHIS  ', 'BAXSCR  ', 'RBXSCR  ',...
        'XSMOCR  ', 'CRDEPL  ', 'DFCHIS  ', 'DPPCIN  ',...
        'DPPCUT  ', 'DPPCUD  ', 'DDFCIN  ', 'DDFCUT  ',...
        'DDFCUD  ', 'FPROCR  ', 'DOPPCR  ', 'DIFFBOCR',...
        'XENOCR  ', 'DYNAMCR ', 'IMPFCR  ', 'CRDEPLXS'};
    
% SGTYP Tables
MANSGT={'DIFFSG  '};

% PINPOW Map Tables
MANPIN={'PINPOW  ', 'DPPMCR  ', 'PINFM   ', 'DPFMCR  ',...
        'PINBUR  ', 'DPPHIS  ', 'GDETPW  ', 'ENRICH  ',...
        'BAMAPS  ', 'DPPCIN  ', 'DPPCUT  ', 'DPPCUD  '};
    
% DF Tables
MANDF={'DISFAC  ', 'DISFCR  ', 'DDFCIN  ', 'DDFCUT  ', 'DDFCUD  '};

% MISC Tables
MANMISC=MAINTAB(cell2mat(MAINTAB(:,3))>0,1);

% Lables for MISC Tables
MISLAB={
    'SGEOM ' , 1    % MISC  DIFFSG
    'CGEOM ' , 1    % MISC  DIFFCR
    'REFVAL' , 8    % MISC  DOPPXS
    'NDU   ' , 3    % MISC  FDATA
    'NDPU  ' , 7    % MISC  FDATA
    'NDBA  ' , 1    % MISC  FDATA
    'FGEOM ' , 1    % MISC  FDATA
    'DSGCR ' , 2    % MISC  FMNRM
    'LAMBDA' , 6    % MISC  DYNAM
    'A1    ' , 8    % MISC  DFCHIS
    'A2    ' , 8    % MISC  DFCHIS
    'B1    ' , 8    % MISC  DFCHIS
    'B2    ' , 8    % MISC  DFCHIS
    'FIN1  ' , 8    % MISC  DFCHIS
    'FIN2  ' , 8    % MISC  DFCHIS
    'FUT1  ' , 8    % MISC  DFCHIS
    'FUT2  ' , 8};  % MISC  DFCHIS


% Define IREFAD
n=0;
IREFAD=zeros(1,NROFTA);
for i=1:NROFMT
   for ii=1:MAINTAB{i,2}
      n=n+1;
      IREFAD(n) = i;
   end
end


% Define INTRCD
n=1;
INTRCD=zeros(1,NROFMT);
for i=1:NROFMT
   INTRCD(i)=n;
   if sum(strcmp(MAINTAB{i,1},MANCRT))
       n=n+NCRMAB;
   elseif sum(strcmp(MAINTAB{i,1},MANSGT))
       n=n+NSGMAB;
   else
       n=n+1;
   end
end
NBLOC1=n;
clear n;