%@(#)   Contents.m 1.4	 94/03/16     14:39:32
%
%Instruktion f�r refuelfunktionen i distplot
%
%
%1. Syfte
%
%Syftet med funktionen �r att kunna g�ra ett interaktivt br�nslebyte,
%d�r n�dv�ndiga filer skapas f�r cykelsimulering och analoadinput. N�gon
%funktion f�r multicykelanalyser, rankingbyten mm ing�r fn inte.
%
%2. Vad ing�r?
%
%Ins�ttning av f�rskt br�nsle, d�r det f�rska br�nslet alltid ers�tter
%br�nsle med l�gst varm kinf. Varm kinf ber�knas pss som i anaload dvs
%med 50% void och en standardiserad effektprofil. Br�nsleskyfflingar
%kan g�ras s�v�l inom h�rden som mellan pool och h�rd. Med pool menas
%det br�nsle som ersatts av f�rskt br�nsle, poolen kan ocks� ut�kas
%med br�nsle fr�n tidigare cykler. Vid laddning fr�n poolen finns tre
%alternativ:
%
% * Insert, ins�ttning p� den plats med n�rmast l�gre kinf. De knippen
%   som har l�gre kinf skyfflas vartefter s� att det knippet med l�gst
%   kinf hamnar i poolen. Anv�nds exempelvis vid studium av enstaka
%   patrons inverkan p� cykell�ngd med bibeh�llna termiska marginaler.
%
% * Low, ins�ttning p� den plats d�r knippet med l�gst kinf st�r.
%
% * To x, ins�ttning p� valfri plats.
%
%Vid laddning av f�rska knippen s� hamnar dessa ibland i randen. F�r
%att ta hand om detta finns en funktion som skyfflar in f�rska
%patroner. De f�rska byter d� plats med de icke-randpatroner som har
%l�gst kinf. De symmetrier som implementerats �r symme 1 och symme 3.
%En optionsfil kan definieras d�r det kan anges om vissa buntyper
%och/eller buidnter ej skall visas i poolen, vidare kan anges
%h�rdpositioner som skall markeras.
%
%
%3. Anv�ndning
%
%Starta applikationen genom att klicka p� Refuel/execute. D�rvid �ppnas
%ett man�verf�nster d�r olika saker beh�ver skrivas i. Den fil som st�r
%i distplot-f�nstret �r den blivande BOC-filen. Inneh�llet i denna fil
%kommer att �ndras vartefter uppdateringar g�rs fr�n man�ver-f�nstret.
%BOC-filen skall vara skapad med en masterfil som inneh�ller ev f�rska
%buntyper. De rutor i man�verf�nstret som m�ste vara ifyllda �r EOC-
%file, d�r EOC-filnamnet skrivs in, och Symmetry, d�r symmetrin skrivs
%in (def 3). En ruta som starkt rekommenderas vara ifylld �r Buntyp-
%file, d�r namnet p� den include-fil f�r buntyper som beh�vs till POLCA
%skrivs in. Fresh buntyp m�ste vara ifylld vid laddning av f�rskt
%br�nsle. Om analoadinputfil �nskas anges namnet p� denna i ruta Map-
%file. Namnet p� ev optionsfil anges vid Option-file, och ev poolfil
%vid Pool-file. Optionsfilen skall vara en .mat -fil d�r variblerna
%flag1, flag2, notbuidnt och notbuntyp finns definierade (ev tomma).
%Flag1 och flag2 skall vara radvektorer med kanalnummer som sedan
%kommer att markeras i distplotf�nstret. Notbuntyp och notbuidnt skall
%vara str�ngvektorer med buntyper resp buidnter som ej skall visas i
%poolen. F�rkortningar g�r bra exvis E18, IA, eller 161. Poolfilen �r
%lika med en utfil fr�n bunhist.
%  BOC-filen uppdateras genom att trycka p� update, d� f�rst g�rs de
%operationer som f�reslagits. Om f�reslagna operationer ej �nskas tryck
%p� undo. Vid anv�ndning av move markeras positioner i kartan i
%turording med tryck p� v�nster knapp, avsluta kedja med h�ger knapp.
%Med mittknappen raderas senaste kedjan. Godtyckligt m�nga operationer
%kan g�ras mellan uppdateringarna. I h�rdkartan �r f�rska knippen
%markerade med en punkt och ej flyttade knippen markeras med ett x.
%  Ibland kan konstigheter uppst� i kinfber�kningarna vilket beror p�
%att fel masterfil anv�nds (av programmet). Detta beror p� att namnet
%p� masterfilen h�mtas fr�n distfilens filhuvud. L�sningen p� problemet
%�r att k�ra ett POLCA-fall med r�tt masterfil och spara n�gon
%f�rdelning exvis POWER p� ber�rd distfil. Namnet p� masterfilen hamnar
%d� i filhuvudet.
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
%  �vrigt:
%    bransleflytt   -
%    bransleflytt2  -
%    axis2knum      - 
%    countsky       -
%    cutpool        -
%