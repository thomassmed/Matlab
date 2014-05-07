%@(#)   idflytt.m 1.2   08/04/23     07:44:47
%
%function f = idflytt(eocfil, bocfil, id, axstr)
%
%Funktionen används i ladsdm

function f = idflytt(eocfil, bocfil, id, axstr)
[asyidold, mminj, konrod, bb, hy, mz, ks, asytyp, asyref, distlist, staton] = readdist7(eocfil, 'ASYID');        %Läser in asyidold och mminj.
asytypold = readdist7(eocfil, 'ASYTYP');        %läser in asytypold
asyweiold = readdist7(eocfil, 'ASYWEI');        %Läser in asyweiold.
burnupold = readdist7(eocfil, 'BURNUP');
BURSIDold = readdist7(eocfil, 'bursid');
BURCORold = readdist7(eocfil, 'burcor');
DNSHISold = readdist7(eocfil, 'dnshis');
CRHISold = readdist7(eocfil, 'crhis');
CRHFRCold = readdist7(eocfil, 'crhfrc');
CREINold = readdist7(eocfil, 'CREIN');
CREOUTold = readdist7(eocfil, 'CREOUT');
EFPHold = readdist7(eocfil, 'EFPH');
SIHISold = readdist7(eocfil, 'SIHIS');
SIHSIDold = readdist7(eocfil, 'SIHSID');
SIHCORold = readdist7(eocfil, 'SIHCOR');
U235old = readdist7(eocfil, 'u235');
U236old = readdist7(eocfil, 'u236');
U238old = readdist7(eocfil, 'u238');
Np239old = readdist7(eocfil, 'np239');
Pu239old = readdist7(eocfil, 'pu239');
Pu240old = readdist7(eocfil, 'pu240');
Pu241old = readdist7(eocfil, 'pu241');
Pu242old = readdist7(eocfil, 'pu242');
Am241old = readdist7(eocfil, 'am241');
Am242old = readdist7(eocfil, 'am242');
Ru103old = readdist7(eocfil, 'ru103');
Rh103old = readdist7(eocfil, 'rh103');
Rh105old = readdist7(eocfil, 'rh105');
Ce143old = readdist7(eocfil, 'ce143');
Pr143old = readdist7(eocfil, 'pr143');
Nd143old = readdist7(eocfil, 'nd143');
Nd147old = readdist7(eocfil, 'nd147');
Pm147old = readdist7(eocfil, 'pm147');
Pm148old = readdist7(eocfil, 'pm148');
Pm148mold = readdist7(eocfil, 'pm148m');
Pm149old = readdist7(eocfil, 'pm149');
Sm147old = readdist7(eocfil, 'sm147');
Sm149old = readdist7(eocfil, 'sm149');
Sm150old = readdist7(eocfil, 'sm150');
Sm151old = readdist7(eocfil, 'sm151');
Sm152old = readdist7(eocfil, 'sm152');
Sm153old = readdist7(eocfil, 'sm153');
Eu153old = readdist7(eocfil, 'eu153');
Eu154old = readdist7(eocfil, 'eu154');
Eu155old = readdist7(eocfil, 'eu155');
Gd155old = readdist7(eocfil, 'gd155');
BAeffold = readdist7(eocfil, 'BAeff');
u235sidold = readdist7(eocfil, 'u235sid');
pu239sidold = readdist7(eocfil, 'pu239sid');
pu240sidold = readdist7(eocfil, 'pu240sid');
pu241sidold = readdist7(eocfil, 'pu241sid');
BOXEFPHold = readdist7(eocfil, 'boxefph');
BOXFLUold = readdist7(eocfil, 'boxflu');
KHOTold = readdist7(eocfil, 'khot');
FUDENSold = readdist7(eocfil, 'fudens');
KCOLDold = readdist7(eocfil, 'kcold');
prmsnvtold = readdist7(eocfil, 'prmsnvt');

asyidnew = readdist7(bocfil, 'ASYID');          %Läser in asyidnew
asytypnew = readdist7(bocfil, 'ASYTYP');        %Läser in asytypnew
asyweinew = readdist7(bocfil, 'ASYWEI');        %Läser in asyweinew.
burnupnew = readdist7(bocfil, 'BURNUP');
BURSIDnew = readdist7(bocfil, 'bursid');
BURCORnew = readdist7(bocfil, 'burcor');
DNSHISnew = readdist7(bocfil, 'dnshis');
CRHISnew = readdist7(bocfil, 'crhis');
CRHFRCnew = readdist7(bocfil, 'crhfrc');
CREINnew = readdist7(bocfil, 'CREIN');
CREOUTnew = readdist7(bocfil, 'CREOUT');
EFPHnew = readdist7(bocfil, 'EFPH');
SIHISnew = readdist7(bocfil, 'SIHIS');
SIHSIDnew = readdist7(bocfil, 'SIHSID');
SIHCORnew = readdist7(bocfil, 'SIHCOR');
U235new = readdist7(bocfil, 'u235');
U236new = readdist7(bocfil, 'u236');
U238new = readdist7(bocfil, 'u238');
Np239new = readdist7(bocfil, 'np239');
Pu239new = readdist7(bocfil, 'pu239');
Pu240new = readdist7(bocfil, 'pu240');
Pu241new = readdist7(bocfil, 'pu241');
Pu242new = readdist7(bocfil, 'pu242');
Am241new = readdist7(bocfil, 'am241');
Am242new = readdist7(bocfil, 'am242');
Ru103new = readdist7(bocfil, 'ru103');
Rh103new = readdist7(bocfil, 'rh103');
Rh105new = readdist7(bocfil, 'rh105');
Ce143new = readdist7(bocfil, 'ce143');
Pr143new = readdist7(bocfil, 'pr143');
Nd143new = readdist7(bocfil, 'nd143');
Nd147new = readdist7(bocfil, 'nd147');
Pm147new = readdist7(bocfil, 'pm147');
Pm148new = readdist7(bocfil, 'pm148');
Pm148mnew = readdist7(bocfil, 'pm148m');
Pm149new = readdist7(bocfil, 'pm149');
Sm147new = readdist7(bocfil, 'sm147');
Sm149new = readdist7(bocfil, 'sm149');
Sm150new = readdist7(bocfil, 'sm150');
Sm151new = readdist7(bocfil, 'sm151');
Sm152new = readdist7(bocfil, 'sm152');
Sm153new = readdist7(bocfil, 'sm153');
Eu153new = readdist7(bocfil, 'eu153');
Eu154new = readdist7(bocfil, 'eu154');
Eu155new = readdist7(bocfil, 'eu155');
Gd155new = readdist7(bocfil, 'gd155');
BAeffnew = readdist7(bocfil, 'BAeff');
u235sidnew = readdist7(bocfil, 'u235sid');
pu239sidnew = readdist7(bocfil, 'pu239sid');
pu240sidnew = readdist7(bocfil, 'pu240sid');
pu241sidnew = readdist7(bocfil, 'pu241sid');
BOXEFPHnew = readdist7(bocfil, 'boxefph');
BOXFLUnew = readdist7(bocfil, 'boxflu');
KHOTnew = readdist7(bocfil, 'khot');
FUDENSnew = readdist7(bocfil, 'fudens');
KCOLDnew = readdist7(bocfil, 'kcold');
prmsnvtnew = readdist7(bocfil, 'prmsnvt');



crid = readdist7(eocfil, 'CRID');          %Läser in cridentiteten.
crmminj = mminj2crmminj(mminj);            %Beräkanr crmminj.
scrmminj = size(crmminj);            %Beräknar storleken på crmminj.
smminj = size(mminj);


%Skriver den gamla härdkartan (asyidold) i filen idkarta_old
fid = fopen ('idkarta_old.txt', 'w');    %Öppnar filen idkarta_old
fprintf(fid, 'ASYID');
map = karta(asyidold, mminj);
for rad = 1:size(map,1)
  fprintf(fid, '\n%s', map(rad,:));
end



fprintf(fid, '\n');
fclose(fid);      %Stänger filen


if nargin == 4          %Om antalet inparametrar är 4 (då tillkoordinaterna är i härden).
  cpos = axis2cpos(axstr);    %Beräknar cpos ur axstr.
  knum = cpos2knum(cpos, mminj);    %Beräkanr knum ur cpos.
  i = strmatch(upper(id), asyidold);    %letar upp angivet id i gamla listan.
  if isempty(i)  %Om inte angivet id finns i gamla listan, ny patron.
%  if (size(i,1) == 0) & (size(i,2) == 1)    %Om inte angivet id finns i gamla listan, ny patron.
    j = strmatch(upper(id), asyidnew);
    typ = asytypnew(j,:);      %Sätter typ till den typ som id (i nya) har.
    wei = asyweinew(j);      %Sätter wei till den vikt som id (i nya) har.
    burnup = burnupnew(:,j);
    BURSID = BURSIDnew(:,j);
    BURCOR = BURCORnew(:,j);
    DNSHIS = DNSHISnew(:,j);
    CRHIS = CRHISnew(:,j);
    CRHFRC = CRHFRCnew(:,j);
    CREIN = CREINnew(:,j);
    CREOUT = CREOUTnew(:,j);
    EFPH = EFPHnew(j);
    SIHIS = SIHISnew(j);
    SIHSID = SIHSIDnew(j);
    SIHCOR = SIHCORnew(j);
    U235 = U235new(:,j);
    U236 = U236new(:,j);
    U238 = U238new(:,j);
    Np239 = Np239new(:,j);
    Pu239 = Pu239new(:,j);
    Pu240 = Pu240new(:,j);
    Pu241 = Pu241new(:,j);
    Pu242 = Pu242new(:,j);
    Am241 = Am241new(:,j);
    Am242 = Am242new(:,j);
    Ru103 = Ru103new(j);
    Rh103 = Rh103new(j);
    Rh105 = Rh105new(j);
    Ce143 = Ce143new(j);
    Pr143 = Pr143new(j);
    Nd143 = Nd143new(j);
    Nd147 = Nd147new(j);
    Pm147 = Pm147new(j);
    Pm148 = Pm148new(j);
    Pm148m = Pm148mnew(j);
    Pm149 = Pm149new(j);
    Sm147 = Sm147new(j);
    Sm149 = Sm149new(j);
    Sm150 = Sm150new(j);
    Sm151 = Sm151new(j);
    Sm152 = Sm152new(j);
    Sm153 = Sm153new(j);
    Eu153 = Eu153new(j);
    Eu154 = Eu154new(j);
    Eu155 = Eu155new(j);
    Gd155 = Gd155new(j);
    BAeff = BAeffnew(:,j);
    u235sid = u235sidnew(:,j);
    pu239sid = pu239sidnew(:,j);
    pu240sid = pu240sidnew(:,j);
    pu241sid = pu241sidnew(:,j);
    BOXEFPH = BOXEFPHnew(j);
    BOXFLU = BOXFLUnew(:,j);
    KHOT = KHOTnew(j);
    FUDENS = FUDENSnew(:,j);
    KCOLD = KCOLDnew(j);

  
  
  else
    typ = asytypold(i,:);      %Sätter typ till den typ som id (i gamla) har.
    wei = asyweiold(i);      %Sätter wei till den vikt som id (igamla) har.
    burnup = burnupold(:,i);
    BURSID = BURSIDold(:,i);
    BURCOR = BURCORold(:,i);
    DNSHIS = DNSHISold(:,i);
    CRHIS = CRHISold(:,i);
    CRHFRC = CRHFRCold(:,i);
    CREIN = CREINold(:,i);
    CREOUT = CREOUTold(:,i);
    EFPH = EFPHold(i);
    SIHIS = SIHISold(i);
    SIHSID = SIHSIDold(i);
    SIHCOR = SIHCORold(i);
    U235 = U235old(:,i);
    U236 = U236old(:,i);
    U238 = U238old(:,i);
    Np239 = Np239old(:,i);
    Pu239 = Pu239old(:,i);
    Pu240 = Pu240old(:,i);
    Pu241 = Pu241old(:,i);
    Pu242 = Pu242old(:,i);
    Am241 = Am241old(:,i);
    Am242 = Am242old(:,i);
    Ru103 = Ru103old(i);
    Rh103 = Rh103old(i);
    Rh105 = Rh105old(i);
    Ce143 = Ce143old(i);
    Pr143 = Pr143old(i);
    Nd143 = Nd143old(i);
    Nd147 = Nd147old(i);
    Pm147 = Pm147old(i);
    Pm148 = Pm148old(i);
    Pm148m = Pm148mold(i);
    Pm149 = Pm149old(i);
    Sm147 = Sm147old(i);
    Sm149 = Sm149old(i);
    Sm150 = Sm150old(i);
    Sm151 = Sm151old(i);
    Sm152 = Sm152old(i);
    Sm153 = Sm153old(i);
    Eu153 = Eu153old(i);
    Eu154 = Eu154old(i);
    Eu155 = Eu155old(i);
    Gd155 = Gd155old(i);
    BAeff = BAeffold(:,i);
    u235sid = u235sidold(:,i);
    pu239sid = pu239sidold(:,i);
    pu240sid = pu240sidold(:,i);
    pu241sid = pu241sidold(:,i);
    BOXEFPH = BOXEFPHold(i);
    BOXFLU = BOXFLUold(:,i);
    KHOT = KHOTold(i);
    FUDENS = FUDENSold(:,i);
    KCOLD = KCOLDold(i);
    
    a = ['vat', num2str(i)];      %Lägger till kanalnum efter vat.					%vattenhål
    nyid = [a, char(32*ones(1, size(asyidold,2)-size(a,2)))];  %Fyller ut med mellanslag.				%Mellanslag!!!!!!!!!!    
    asyidold(i,:) = nyid;        %Skriver nya id  på den gamla platsen.					%Sätter vattenhål där den satt
    asytypold(i,:) = 'WHOL';      %Skriver hole på den gamla platsen.
    asyweiold(i) = 0;        %Skriver noll på den gamla platsen.
    burnupold(:,i) = 0;
    BURSIDold(:,i) = 0;
    BURCORold(:,i) = 0;
    DNSHISold(:,i) = 0;
    CRHISold(:,i) = 0;
    CRHFRCold(:,i) = 0;
    CREINold(:,i) = 0;
    CREOUTold(:,i) = 0;
    EFPHold(i) = 0;
    SIHISold(i) = 0;
    SIHSIDold(i) = 0;
    SIHCORold(i) = 0;
    U235old(:,i) = 0;
    U236old(:,i) = 0;
    U238old(:,i) = 0;
    Np239old(:,i) = 0;
    Pu239old(:,i) = 0;
    Pu240old(:,i) = 0;
    Pu241old(:,i) = 0;
    Pu242old(:,i) = 0;
    Am241old(:,i) = 0;
    Am242old(:,i) = 0;
    Ru103old(i) = 0;
    Rh103old(i) = 0;
    Rh105old(i) = 0;
    Ce143old(i) = 0;
    Pr143old(i) = 0;
    Nd143old(i) = 0;
    Nd147old(i) = 0;
    Pm147old(i) = 0;
    Pm148old(i) = 0;
    Pm148mold(i) = 0;
    Pm149old(i) = 0;
    Sm147old(i) = 0;
    Sm149old(i) = 0;
    Sm150old(i) = 0;
    Sm151old(i) = 0;
    Sm152old(i) = 0;
    Sm153old(i) = 0;
    Eu153old(i) = 0;
    Eu154old(i) = 0;
    Eu155old(i) = 0;
    Gd155old(i) = 0;
    BAeffold(:,i) = 0;
    u235sidold(:,i) = 0;
    pu239sidold(:,i) = 0;
    pu240sidold(:,i) = 0;
    pu241sidold(:,i) = 0;
    BOXEFPHold(i) = 0;
    BOXFLUold(:,i) = 0;
    KHOTold(i) = 0;
    FUDENSold(:,i) = 0;
    KCOLDold(i) = 0;


  end
  asyidold(knum,:) = id;        %Tilldelar den nya platen angivet id.					%Sätter den där den ska
  asytypold(knum,:) = typ;      %Tilldelar den nya platsen den typ som id har.
  asyweiold(knum) = wei;
  burnupold(:,knum) = burnup;
  BURSIDold(:,knum) = BURSID;
  BURCORold(:,knum) = BURCOR;
  DNSHISold(:,knum) = DNSHIS;
  CRHISold(:,knum) = CRHIS;
  CRHFRCold(:,knum) = CRHFRC;
  CREINold(:,knum) = CREIN;
  CREOUTold(:,knum) = CREOUT;
  EFPHold(knum) = EFPH;
  SIHISold(knum) = SIHIS;
  SIHSIDold(knum) = SIHSID;
  SIHCORold(knum) = SIHCOR;
  U235old(:,knum) = U235;
  U236old(:,knum) = U236;
  U238old(:,knum) = U238;
  Np239old(:,knum) = Np239;
  Pu239old(:,knum) = Pu239;
  Pu240old(:,knum) = Pu240;
  Pu241old(:,knum) = Pu241;
  Pu242old(:,knum) = Pu242;
  Am241old(:,knum) = Am241;
  Am242old(:,knum) = Am242;
  Ru103old(knum) = Ru103;
  Rh103old(knum) = Rh103;
  Rh105old(knum) = Rh105;
  Ce143old(knum) = Ce143;
  Pr143old(knum) = Pr143;
  Nd143old(knum) = Nd143;
  Nd147old(knum) = Nd147;
  Pm147old(knum) = Pm147;
  Pm148old(knum) = Pm148;
  Pm148mold(knum) = Pm148m;
  Pm149old(knum) = Pm149;
  Sm147old(knum) = Sm147;
  Sm149old(knum) = Sm149;
  Sm150old(knum) = Sm150;
  Sm151old(knum) = Sm151;
  Sm152old(knum) = Sm152;
  Sm153old(knum) = Sm153;
  Eu153old(knum) = Eu153;
  Eu154old(knum) = Eu154;
  Eu155old(knum) = Eu155;
  Gd155old(knum) = Gd155;
  BAeffold(:,knum) = BAeff;
  u235sidold(:,knum) = u235sid;
  pu239sidold(:,knum) = pu239sid;
  pu240sidold(:,knum) = pu240sid;
  pu241sidold(:,knum) = pu241sid;
  BOXEFPHold(knum) = BOXEFPH;
  BOXFLUold(:,knum) = BOXFLU;
  KHOTold(knum) = KHOT;
  FUDENSold(:,knum) = FUDENS;
  KCOLDold(knum) = KCOLD;
  asyweiold = asyweiold';        %Byter rader och kolonner.




end

if nargin == 3          %Om antalet inparametrar är 3 (då tillkoordinaterna är i en pool).
  i = strmatch(upper(id), asyidold);    %Letar upp knum för angivet id.
  if ~isempty(i)
    a = ['vat', num2str(i)];      %Lägger till kanalnum efter vat.
    nyid = [a, char(32*ones(1, size(asyidold,2)-size(a,2)))];  %Fyller ut med mellanslag.				%Mellanslag!!!!!!!!!
    asyidold(i,:) = nyid;        %Skriver nya id på den gamla platsen.
    asytypold(i,:) = 'WHOL';      %Skriver hole på den gamla platsen.
    asyweiold(i) = 0;        %Skriver noll på den gamla platsen.
    burnupold(:,i) = 0;
    BURSIDold(:,i) = 0;
    BURCORold(:,i) = 0;
    DNSHISold(:,i) = 0;
    CRHISold(:,i) = 0;
    CRHFRCold(:,i) = 0;
    CREINold(:,i) = 0;
    CREOUTold(:,i) = 0;
    EFPHold(i) = 0;
    SIHISold(i) = 0;
    SIHSIDold(i) = 0;
    SIHCORold(i) = 0;
    U235old(:,i) = 0;
    U236old(:,i) = 0;
    U238old(:,i) = 0;
    Np239old(:,i) = 0;
    Pu239old(:,i) = 0;
    Pu240old(:,i) = 0;
    Pu241old(:,i) = 0;
    Pu242old(:,i) = 0;
    Am241old(:,i) = 0;
    Am242old(:,i) = 0;
    Ru103old(i) = 0;
    Rh103old(i) = 0;
    Rh105old(i) = 0;
    Ce143old(i) = 0;
    Pr143old(i) = 0;
    Nd143old(i) = 0;
    Nd147old(i) = 0;
    Pm147old(i) = 0;
    Pm148old(i) = 0;
    Pm148mold(i) = 0;
    Pm149old(i) = 0;
    Sm147old(i) = 0;
    Sm149old(i) = 0;
    Sm150old(i) = 0;
    Sm151old(i) = 0;
    Sm152old(i) = 0;
    Sm153old(i) = 0;
    Eu153old(i) = 0;
    Eu154old(i) = 0;
    Eu155old(i) = 0;
    Gd155old(i) = 0;
    BAeffold(:,i) = 0;
    u235sidold(:,i) = 0;
    pu239sidold(:,i) = 0;
    pu240sidold(:,i) = 0;
    pu241sidold(:,i) = 0;
    BOXEFPHold(i) = 0;
    BOXFLUold(:,i) = 0;
    KHOTold(i) = 0;
    FUDENSold(:,i) = 0;
    KCOLDold(i) = 0;
  
  end
  asyweiold = asyweiold';        %byter rader och kolonner.
end


%Skriver den nya härdkartan (asyidold) i filen idkarta_new
fid = fopen ('idkarta_new.txt', 'w');    %Öppnar filen idkarta_new
fprintf(fid, 'ASYID');
map = karta(asyidold, mminj);
for rad = 1:size(map,1)
  fprintf(fid, '\n%s', map(rad,:));
end




fprintf(fid, '\n');
fclose(fid);




%Skriver den nya härdkartan i filen typkarta
fid = fopen ('typkarta.txt', 'w');    %Öppnar filen typkarta.
%Skriver ut styrstavstypen.
fprintf(fid, 'CRTYP');

crtyp = readdist7(eocfil, 'crtyp');
map = karta(crtyp, crmminj);
for rad = 1:size(map,1)
  fprintf(fid, '\n%s', map(rad,:));
end


%Skriver ut en dettyp karta.
if strcmp(staton, 'F3')
  fprintf(fid, '\nDETTYP');
  fprintf(fid, '\n            DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\n      DTYP  DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\nDTYP  DTYP  DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\nDTYP  DTYP  DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\n      DTYP  DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\n      DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\n                  DTYP  DTYP');

else
  fprintf(fid, '\nDETTYP');
  fprintf(fid, '\n            DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\n      DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\nDTYP  DTYP  DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\nDTYP  DTYP  DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\n      DTYP  DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\n      DTYP  DTYP  DTYP  DTYP  DTYP');
  fprintf(fid, '\n                  DTYP  DTYP');
end

%Skriver ut karta över bränsletyperna.
fprintf(fid, '\nASYTYP');
map = karta(asytypold, mminj);
for rad = 1:size(map,1)
  fprintf(fid, '\n%s', map(rad,:));
end

%Skriver en karta av vikten
fprintf(fid, '\nCOMMENT ------ASYWEI------\nASYWEI');
asyweiold = round(asyweiold*100)/100;
map = karta(asyweiold, mminj);
for rad = 1:size(map,1)
  fprintf(fid, '\n%s', map(rad,:));
end

fprintf(fid, '\n');
fclose(fid);      %Stänger filen




%skriverin alla distrubutioner i eoc-upd med writedist7
writedist7(eocfil, asyidold, 'asyid');
writedist7(eocfil, asytypold, 'asytyp')
writedist7(eocfil, asyweiold, 'asywei');
writedist7(eocfil, burnupold, 'burnup');
writedist7(eocfil, BURSIDold, 'BURSID');
writedist7(eocfil, BURCORold, 'BURCOR');
writedist7(eocfil, DNSHISold, 'DNSHIS');
writedist7(eocfil, CRHISold, 'CRHIS');
writedist7(eocfil, CRHFRCold, 'CRHFRC');
writedist7(eocfil, CREINold, 'CREIN');
writedist7(eocfil, CREOUTold, 'CREOUT');
writedist7(eocfil, EFPHold, 'EFPH');
writedist7(eocfil, SIHISold, 'SIHIS');
writedist7(eocfil, SIHSIDold, 'SIHSID');
writedist7(eocfil, SIHCORold, 'SIHCOR');
writedist7(eocfil, U235old, 'U235');
writedist7(eocfil, U236old, 'U236');
writedist7(eocfil, U238old, 'U238');
writedist7(eocfil, Np239old, 'Np239');
writedist7(eocfil, Pu239old, 'Pu239');
writedist7(eocfil, Pu240old, 'Pu240');
writedist7(eocfil, Pu241old, 'Pu241');
writedist7(eocfil, Pu242old, 'Pu242');
writedist7(eocfil, Am241old, 'Am241');
writedist7(eocfil, Am242old, 'Am242');
writedist7(eocfil, Ru103old, 'Ru103');
writedist7(eocfil, Rh103old, 'Rh103');
writedist7(eocfil, Rh105old, 'Rh105');
writedist7(eocfil, Ce143old, 'Ce143');
writedist7(eocfil, Pr143old, 'Pr143');
writedist7(eocfil, Nd143old, 'Nd143');
writedist7(eocfil, Nd147old, 'Nd147');
writedist7(eocfil, Pm147old, 'Pm147');
writedist7(eocfil, Pm148old, 'Pm148');
writedist7(eocfil, Pm148mold, 'Pm148m');
writedist7(eocfil, Pm149old, 'Pm149');
writedist7(eocfil, Sm147old, 'Sm147');
writedist7(eocfil, Sm149old, 'Sm149');
writedist7(eocfil, Sm150old, 'Sm150');
writedist7(eocfil, Sm151old, 'Sm151');
writedist7(eocfil, Sm152old, 'Sm152');
writedist7(eocfil, Sm153old, 'Sm153');
writedist7(eocfil, Eu153old, 'Eu153');
writedist7(eocfil, Eu154old, 'Eu154');
writedist7(eocfil, Eu155old, 'Eu155');
writedist7(eocfil, Gd155old, 'Gd155');
writedist7(eocfil, BAeffold, 'BAeff');
writedist7(eocfil, u235sidold, 'u235sid');
writedist7(eocfil, pu239sidold, 'pu239sid');
writedist7(eocfil, pu240sidold, 'pu240sid');
writedist7(eocfil, pu241sidold, 'pu241sid');
writedist7(eocfil, BOXEFPHold, 'BOXEFPH');
writedist7(eocfil, BOXFLUold, 'BOXFLU');
writedist7(eocfil, KHOTold, 'khot');
writedist7(eocfil, FUDENSold, 'fudens');
writedist7(eocfil, KCOLDold, 'kcold');
writedist7(eocfil, prmsnvtold, 'prmsnvt')





if (nargin ~= 3)        %Skriver ut varningstext om det nya platsen inte sämmer med angiven i nya filen.
  if asyidnew(knum,:) ~= id
    fprintf(1, '\n\nVarning!\nFörflyttningen stämmer inte överens med den nya härdkartan.\n\n');
  end
end
