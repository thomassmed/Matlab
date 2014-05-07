%@(#)   Contents.m 1.4	 94/03/16     14:39:32
%
%Instruktion för refuelfunktionen i distplot
%
%
%1. Syfte
%
%Syftet med funktionen är att kunna göra ett interaktivt bränslebyte,
%där nödvändiga filer skapas för cykelsimulering och analoadinput. Någon
%funktion för multicykelanalyser, rankingbyten mm ingår fn inte.
%
%2. Vad ingår?
%
%Insättning av färskt bränsle, där det färska bränslet alltid ersätter
%bränsle med lägst varm kinf. Varm kinf beräknas pss som i anaload dvs
%med 50% void och en standardiserad effektprofil. Bränsleskyfflingar
%kan göras såväl inom härden som mellan pool och härd. Med pool menas
%det bränsle som ersatts av färskt bränsle, poolen kan också utökas
%med bränsle från tidigare cykler. Vid laddning från poolen finns tre
%alternativ:
%
% * Insert, insättning på den plats med närmast lägre kinf. De knippen
%   som har lägre kinf skyfflas vartefter så att det knippet med lägst
%   kinf hamnar i poolen. Används exempelvis vid studium av enstaka
%   patrons inverkan på cykellängd med bibehållna termiska marginaler.
%
% * Low, insättning på den plats där knippet med lägst kinf står.
%
% * To x, insättning på valfri plats.
%
%Vid laddning av färska knippen så hamnar dessa ibland i randen. För
%att ta hand om detta finns en funktion som skyfflar in färska
%patroner. De färska byter då plats med de icke-randpatroner som har
%lägst kinf. De symmetrier som implementerats är symme 1 och symme 3.
%En optionsfil kan definieras där det kan anges om vissa buntyper
%och/eller buidnter ej skall visas i poolen, vidare kan anges
%härdpositioner som skall markeras.
%
%
%3. Användning
%
%Starta applikationen genom att klicka på Refuel/execute. Därvid öppnas
%ett manöverfönster där olika saker behöver skrivas i. Den fil som står
%i distplot-fönstret är den blivande BOC-filen. Innehållet i denna fil
%kommer att ändras vartefter uppdateringar görs från manöver-fönstret.
%BOC-filen skall vara skapad med en masterfil som innehåller ev färska
%buntyper. De rutor i manöverfönstret som måste vara ifyllda är EOC-
%file, där EOC-filnamnet skrivs in, och Symmetry, där symmetrin skrivs
%in (def 3). En ruta som starkt rekommenderas vara ifylld är Buntyp-
%file, där namnet på den include-fil för buntyper som behövs till POLCA
%skrivs in. Fresh buntyp måste vara ifylld vid laddning av färskt
%bränsle. Om analoadinputfil önskas anges namnet på denna i ruta Map-
%file. Namnet på ev optionsfil anges vid Option-file, och ev poolfil
%vid Pool-file. Optionsfilen skall vara en .mat -fil där variblerna
%flag1, flag2, notbuidnt och notbuntyp finns definierade (ev tomma).
%Flag1 och flag2 skall vara radvektorer med kanalnummer som sedan
%kommer att markeras i distplotfönstret. Notbuntyp och notbuidnt skall
%vara strängvektorer med buntyper resp buidnter som ej skall visas i
%poolen. Förkortningar går bra exvis E18, IA, eller 161. Poolfilen är
%lika med en utfil från bunhist.
%  BOC-filen uppdateras genom att trycka på update, då först görs de
%operationer som föreslagits. Om föreslagna operationer ej önskas tryck
%på undo. Vid användning av move markeras positioner i kartan i
%turording med tryck på vänster knapp, avsluta kedja med höger knapp.
%Med mittknappen raderas senaste kedjan. Godtyckligt många operationer
%kan göras mellan uppdateringarna. I härdkartan är färska knippen
%markerade med en punkt och ej flyttade knippen markeras med ett x.
%  Ibland kan konstigheter uppstå i kinfberäkningarna vilket beror på
%att fel masterfil används (av programmet). Detta beror på att namnet
%på masterfilen hämtas från distfilens filhuvud. Lösningen på problemet
%är att köra ett POLCA-fall med rätt masterfil och spara någon
%fördelning exvis POWER på berörd distfil. Namnet på masterfilen hamnar
%då i filhuvudet.
%
%
%
%
%
%Funktioner i paketet:
% 
%  Ny Distplot refueling:
%
%    refuwin        -
%    refupd7        -
%    runsky         -
%    mkskyinp       -
%
%    ldpins7        -
%    ldplow7        -
%    ldptox7        -
%    ldfresh7       -
%    lowper7        - FIX USE OF REFU-FILE
%
%  Privata funktioner:
%    refumov7       - 
%    refundo7       - FIX USE OF REFU-FILE?
%
%    addfresh
%    delfresh
%    update
%    update_fresh
%    update_pool
%    update_shuffles
%    setupwin
%
%
%  Gamla Distplot refueling:
%    refuwin7       -
%    setbut         -
%    podown         -
%    poup           -
%    readkinf       -
%
%
%  Rankingbyten:
%    rank           -
%    rankbyt        -
%
%
%  Övrigt:
%    bransleflytt   -
%    bransleflytt2  -
%    axis2knum      - 
%    countsky       -
%    cutpool        -
%