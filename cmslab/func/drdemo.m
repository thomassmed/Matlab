echo on
% Demo fr DRIDENT och STPR
%
pause;% Tryck p ngon tangent
%
%
% Om man vill anaylsera signalen x 
% som har samplingstiden T utfr man
% s=drident(x,T);
%
% s r en vektor med en rad och 12 kolumner
%
pause;% Tryck p ngon tangent
%
% Formatet p s r fljande:
%
pause;% Tryck p ngon tangent
help s
pause;% Tryck p ngon tangent
clc
% 
% Om man vill utfra en analys p en mtning
% med n signaler kar man s med n rader till 
% formatet [n,12]
%
pause;% Tryck p ngon tangent
%
% Sg att vi har resultat frn 6 signaler som vi vill 
% ha utskrivna. s r allts en 6 x 12 matris.
%
% Fr enkelhetens skull skapar vi s med kommandot
% s=rand(6,12)
%
pause;% Tryck p ngon tangent
s=rand(6,12)
pause;% Tryck p ngon tangent
%
% Vi dper mtningen till lprm med:
% namn='lprm'
%
pause;% Tryck p ngon tangent
namn='lprm';
clc
%
% Fr att kunna hlla ordning p resultaten:
% direkt='a' 
% 
% Detta betyder att resultaten presenteras p
% filerna; tabella1.txt, tabella2.txt, osv
%
direkt='a';
pause;% Tryck p ngon tangent
%
% Definition av de 6 signalnamnen grs med
%
varlist=['LPRM 1     '       
        'LPRM 2     ' 
        'LPRM 3     '
        'LPRM 4     '
        'FLDE 1    '
        'FLDE 2    '];
%
% Ha lika antal positioner fr varje rad
%
%
% Om antalet signaler verstiger det som fr
% plats p en sida skapas fler sidor.
%        
pause;% Tryck p ngon tangent 
%
% Driftpunkten defineras enl:
effekt=75;
hcflow=3700;
%
pause;% Tryck p ngon tangent 
%
% Utskriften fs sedan med
%
% y=stpr(namn,direkt,varlist,s,effekt,hcflow);
%
pause;% Tryck p ngon tangent 
y=stpr(namn,direkt,varlist,s,effekt,hcflow);
%
pause;% Tryck p ngon tangent 
%
% Resultatet r lagrat p filen:
%
% tabella1.txt
