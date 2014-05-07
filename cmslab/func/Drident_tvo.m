% DRIDENT:M  Revision : 5		Datum : 930115
%           (modifierad fr�n som hade datum : 920221)             
% Levererar resultat p� s-format (se help s). S-formatet inneh�ller
% statistik p� signalen, resultat fr�n spektralanlys och identifiering
% av signalens d�mpning och egenfrekvenser.
%
%	Samma som drident, men ingen h�gpassfiltrering (differentiering) av
%	tidsserien C. Rotander, 93-01-15
%
%
% Syntax : [s,th]=drident(x,T,nn,sd,ns);
% x :      Insignal f�r ber�kning
% T :      Samplingstiden i s
%
% 	   Bengt Melkerson		P�r Lans�ker
%	   Vattenfall			Vattenfall
%	   Ringhalsverket		Forsmarksverket
%	   S-432 32 V�R�BACKA	        S-742 03 �STHAMMAR
%	   SWEDEN			SWEDEN
%
%	Modifierad 92-02-12
%
%	Camilla Rotander
%	RPA
%	ABB Atom
%	S-721 63 V�ster�s
%	SWEDEN
%
%	nn	-	man v�ljer sj�lv vilken ordning identifieringen skall
%			starta p� (default nn=[10 9] eller [11 10])
%	sd	-	standardavvikelsen som pol/nollst�lles-
%			reduktionsalgoritmen anv�nder (default sd=0.5)
%	ns	-	nedsampling (default ns=2)
%
%	nytt:	efter nedsampling differentieras signalen f�r att ta bort l�ng-
%		samma oscillationer. Identifieringen startar p� vald ordning. Om
%		poler/nollst�llen kancellerar varandra (d v s deras "standardavvikel-
%		se-ellipser" sk�r varandra, eller omr�dena t�cker varandra helt) g�rs
%		identifieringen om med s�nkt ordning (se POLRED). Ordningen s�nks med 1 om de �r 
%		reell pol/reellt nollst�lle, och med 2 om det �r komplex pol/komplext
%		nollst�lle. N�r slutlig ordning uppn�tts kontrolleras (som tidigare)
%		om det ligger fler �n 1 polpar inom frekvens-intervallet 0.3-0.7 Hz.
%		Om det g�r det, g�rs identifieringen om med s�nkt ordning. N�r den
%		slutliga ordningen uppn�tts ber�knas decay ratio med standardavvikelse
%		samt resonansfrekvens (se TH2DR).
%
%		Om ingen pol hittas blir resultatet "NaN". S-formatet presenteras med show(s), se �ven stpr.
%
%	Reviderad 93-01-15, C. Rotander, ABB Atom
%	differentiering borttagen, "st�r" vid identyifiering av signaler med l�gt signal-till-brusf�rh�llande
%	startordning [11 10]

function [s,th]=drident(x,T,nn,sd,ns);

echo off

if nargin==2, 
   nn=[11 10]; 
   sd=0.5;
   ns=2;
elseif nargin==3
   sd=0.5;
   ns=2;
elseif nargin==4
   ns=2;
end


% Statistikber�kningar

s(1)=mean(x);		% Medelv�rde
s(2)=max(x);		% Maxv�rde
s(3)=min(x);		% Minv�rde
s(4)=std(x);		% Standardavvikelse
s(6)=s(2)-s(3);		% Topp - toppv�rde
s(7)=s(6)*100/s(1);		% T-T / medelv�rde i %
s(8)=s(4)*100/s(1);		% Standardavvikelse / medelv�rde i %

% Signalbehandling
y=dtrend(x,1);
y=decimate(y,ns,'fir');
%fid = fopen('hunting.txt','w');
%fprintf(fid,'%f\n',y);
%fclose(fid);
%pause
T=ns*T;

% Ber�kning av effektspektrum

p=spectrum(y,512,256);
p=p(:,1);

% Rimlighetskontroll f�r spektrum

x1=round(0.3*256*T*2);             % Definera stabilitetsomr�det
x2=round(0.7*256*T*2);             %        "
maxtopp=max(abs(p(x1:x2,1)));      % Hitta resonanstoppen i stabilitetsomr�det
f=find(p==maxtopp);                %        "
wref=f(1)/256*pi/T;
ampl1=p(f(1),1); 

maxtopp=max(abs(p(:,1)));  	     % Koll om  resonanstopp finns utanf�r
f=find(p==maxtopp);		     % stabilitetsomr�det
wres=f(1)/256*pi/T;		     % Resonansfrekvens i radianer
if wres<2*0.7*pi,wres=0;,end

%
% Identifieringsalgoritm
% 
%	H�r startar den modifierade delen
%
%	F�rfiltrera f�r att ta bort l�ngsamma variationer, (ARIMA modell)
%
%	yp=filter([1 -1],1,y);
%	yp(1)=yp(2);
%	y=yp;
	th=armax(y,nn,[],[],[],[],T);    % ARMA-identifiering
        [dr,sdr,fr]=th2dr(th)	
        flag=polred(th,sd)
	nno=nn;bjarne=nn;
	if (flag==0)&length(dr)>1
	   nn=nn-2;
	elseif flag>0
	   nn=nn-flag;
	end
%
	while (nno>nn)&(nn>=2)
	     th=armax(y,nn,[],[],[],[],T);
	     flag=polred(th,sd);
	     nno=nn; nn=nn-flag;
	   	if (flag==0)
           	[dr,sdr,fr]=th2dr(th);
	  	    if length(dr)>1
	           nn=nn-2;
	 	    end
	     end
	end
dr
%perus=gcf
%figure
%E=resid(y,th);
%figure
%plot(E)
%res=cov(E)
%figure
%set(perus,'Selected','on')

%
%
%Ollin testausta kommentoi seuraavaan kommenttiin
dr, fr, wref/2/pi, wres/2/pi, nn, sdr

if length(dr) > 1
  s(5)=dr(1);             	     % Decay-Ratio
  s(9)=fr(1);                        % H�rdresonansfrekvens
  s(10)=wref/2/pi;		     % Resonanstopp i omr�det [0.3-0.7] Hz
  s(11)=wres/2/pi;                   % Resonanstopp (om n�gon) > 0.7 Hz
  s(12)=nn(1);		             % Modellordning
  s(13)=sdr(1);			     % Standardavvikelse f�r decay ratio
else  % alkuper�inen osuus if lause ei tarpeellinen
  s(5)=dr;             		     % Decay-Ratio
  s(9)=fr;                           % H�rdresonansfrekvens
  s(10)=wref/2/pi;		     % Resonanstopp i omr�det [0.3-0.7] Hz
  s(11)=wres/2/pi;                   % Resonanstopp (om n�gon) > 0.7 Hz
  s(12)=nn(1);		             % Modellordning
  s(13)=sdr;			     % Standardavvikelse f�r decay ratio
end






