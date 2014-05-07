function fluxplot_XP(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           fluxplot_XP.m v1.0 
%          ********************
% Ber�knar skillnaden i LHGR mellan ett 
% startl�ge och ett slutl�ge. Skillnaden 
% anges i f�rh�llande till startl�get.
% delta_LHGR=(START-SLUT)/START
% Programmet ber�knar antingen en f�rvald
% kanal eller s� kontrollerar den alla
% kanaler. START �r den initiala
% distributionsfile och SLUT �r det l�ge
% man vill j�mf�ra med.
% 
% Exempel 1: fluxplot_XP 301 
% ber�knar delta_LHGR i kanal 301.
%
% Exempel 2: fluxplot_XP
% ber�knar delta_LHGR i samtliga kanaler
% och plottar den/de kanal/er med l�gsta 
% v�rdet.
%
% START distrubtionsfil �r utg�ngsl�get
% SLUT distributionsfil �r slutl�get
%
% delta_LHGR �r allts� den nod som ger s�mst
% marginal mot ursprungsfilen. Detta inneb�r
% att negativa delta_LHGR motsvarar att
% slutfilen har ett h�gre LHGR v�rde. Detta
% anv�nds vid t.ex. vid effekth�jning. 
%
% delta_LHGR anges i andelar. Multiplicera
% med 100 f�r att f� delta_LHGR i procent.
%
% Jan Karjalainen, FTB 2004
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ');
disp('*****************************');
disp('       FLUXPLOT_XP v1.0');
disp('*****************************');

OK=1;

try
[STARTfil,STARTvag]=uigetfile({'*.dat'},'OBS! Distributionsfil f�r ****STARTL�GE****');
START=[STARTvag STARTfil];
lhgrSTART=readdist7(START,'lhgr');

[SLUTfil,SLUTvag]=uigetfile({'*.dat'},'OBS! Distributionsfil f�r ****SLUTL�GE****');
SLUT=[SLUTvag SLUTfil];
lhgrSLUT=readdist7(SLUT,'lhgr');
catch
  errordlg('fluxplot_XP st�tte p� ett problem. R�tt START-och SLUT-distribution m�ste anges.','Fel meddelande fluxplot_XP','fluxplot_XP problem...')
  OK=0;
end

block=str2num(STARTvag(6));

if OK==1 %Om Programmet  inte st�tt p� n�gra problem forts�tter programmet annars avslutas det.

if block==1 | block==2 
 modul=676;
elseif block==3
 modul=700;
else
 disp('Kunde inte avg�ra vilket block antar: F1/F2');
 modul=676;
end
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


totalt=0;
try % Kontrollerar om en kanal skickats med som inparameter.
    % Om inte s� g�r programmet vidare under catch.

x=str2num(x); % Konverterar det inmatade x-v�rdet till ett tal.

ktest=(lhgrSTART-lhgrSLUT)./lhgrSTART;
diff2=min((lhgrSTART(:,x)-lhgrSLUT(:,x))./lhgrSTART(:,x));
Kanal=num2str(x);
delta_LHGR=num2str(diff2); 
disp(' ');
disp('*****************************');
eval('disp(''Hittad''); Kanal');
eval('disp(''Minsta''); delta_LHGR');
disp('*****************************');
disp(' ');

plot(lhgrSTART(:,x),'r');
tit=sprintf('KANAL: %s Minsta delta_LHGR differens i denna kanal �r: %s ',Kanal,delta_LHGR);
title(tit);
hold on
plot(lhgrSLUT(:,x));
ylabel(['LHGR']);
xlabel(['NOD']);
hold off
legend('START-dist','SLUT-dist',1)
print -dpsc fluxgraf
totalt=1;


catch % Om ingen kanal angivits ber�knas samtliga kanaler. Den
      % f�rst kanal som inn�h�ller min delta LHGR plottas.

h =waitbar(0,'Ber�knar delta LHGR i samliga kanaler...');
x=1;
while x<=modul
ktest=(lhgrSTART-lhgrSLUT)./lhgrSTART;

diff1=min(min(ktest));
diff2=min((lhgrSTART(:,x)-lhgrSLUT(:,x))./lhgrSTART(:,x));
test=diff1-diff2;

if test==0
figure
Kanal=num2str(x);
delta_LHGR=num2str(diff2); 
disp(' ');
disp('*****************************');
eval('disp(''Hittad''); Kanal');
eval('disp(''Minsta''); delta_LHGR');
disp('*****************************');
plot(lhgrSTART(:,x),'r');
tit=sprintf('KANAL: %s Minsta delta_LHGR differens: %s ',Kanal,delta_LHGR);
title(tit);
hold on
plot(lhgrSLUT(:,x));
ylabel(['LHGR']);
xlabel(['NOD']);
hold off
legend('START-dist','SLUT-dist',1)
totalt=totalt+1;
temp1='print -dpsc fluxgraf';
temp2=num2str(totalt);
temp3=[temp1 temp2];
eval(temp3);
end
waitbar(x/modul)
x=x+1;
end
close(h)

end

disp('*****************************');
disp('Antal kanaler med minsta'); 
disp('delta LHGR �r');
eval('totalt');
skrivut=questdlg('Vill du skriva ut grafen?','Utskrift av graf');
langden=length(skrivut);
       
if langden == 3
set(gcf,'paperposition',[.62 1.5 22.5 17.5])
set (gcf,'paperorientation','landscape')
unix('lpr -Pf1xerox5 fluxgraf*.ps');
end
disp('*****************************');
disp('    Programmet avslutat');
disp('*****************************');
disp(' ');
unix('rm fluxgraf*.ps');
end %tillh�r kontroll if OK.
