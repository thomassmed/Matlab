% DRIDENT:M  Revision : 5		Datum : 930115
%           (modifierad från som hade datum : 920221)             
% Levererar resultat på s-format (se help s). S-formatet innehåller
% statistik på signalen, resultat från spektralanlys och identifiering
% av signalens dämpning och egenfrekvenser.
%
%	Samma som drident, men ingen högpassfiltrering (differentiering) av
%	tidsserien C. Rotander, 93-01-15
%
%
% Syntax : [s,th]=drident(x,T,nn,sd,ns);
% x :      Insignal för beräkning
% T :      Samplingstiden i s
%
% 	   Bengt Melkerson		Pär Lansåker
%	   Vattenfall			Vattenfall
%	   Ringhalsverket		Forsmarksverket
%	   S-432 32 VÄRÖBACKA	        S-742 03 ÖSTHAMMAR
%	   SWEDEN			SWEDEN
%
%	Modifierad 92-02-12
%
%	Camilla Rotander
%	RPA
%	ABB Atom
%	S-721 63 Västerås
%	SWEDEN
%
%	nn	-	man väljer själv vilken ordning identifieringen skall
%			starta på (default nn=[10 9] eller [11 10])
%	sd	-	standardavvikelsen som pol/nollställes-
%			reduktionsalgoritmen använder (default sd=0.5)
%	ns	-	nedsampling (default ns=2)
%
%	nytt:	efter nedsampling differentieras signalen för att ta bort lång-
%		samma oscillationer. Identifieringen startar på vald ordning. Om
%		poler/nollställen kancellerar varandra (d v s deras "standardavvikel-
%		se-ellipser" skär varandra, eller områdena täcker varandra helt) görs
%		identifieringen om med sänkt ordning (se POLRED). Ordningen sänks med 1 om de är 
%		reell pol/reellt nollställe, och med 2 om det är komplex pol/komplext
%		nollställe. När slutlig ordning uppnåtts kontrolleras (som tidigare)
%		om det ligger fler än 1 polpar inom frekvens-intervallet 0.3-0.7 Hz.
%		Om det gör det, görs identifieringen om med sänkt ordning. När den
%		slutliga ordningen uppnåtts beräknas decay ratio med standardavvikelse
%		samt resonansfrekvens (se TH2DR).
%
%		Om ingen pol hittas blir resultatet "NaN". S-formatet presenteras med show(s), se även stpr.
%
%	Reviderad 93-01-15, C. Rotander, ABB Atom
%	differentiering borttagen, "stör" vid identyifiering av signaler med lågt signal-till-brusförhållande
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


% Statistikberäkningar

s(1)=mean(x);		% Medelvärde
s(2)=max(x);		% Maxvärde
s(3)=min(x);		% Minvärde
s(4)=std(x);		% Standardavvikelse
s(6)=s(2)-s(3);		% Topp - toppvärde
s(7)=s(6)*100/s(1);		% T-T / medelvärde i %
s(8)=s(4)*100/s(1);		% Standardavvikelse / medelvärde i %

% Signalbehandling
y=dtrend(x,1);
y=decimate(y,ns,'fir');
%fid = fopen('hunting.txt','w');
%fprintf(fid,'%f\n',y);
%fclose(fid);
%pause
T=ns*T;

% Beräkning av effektspektrum

p=spectrum(y,512,256);
p=p(:,1);

% Rimlighetskontroll för spektrum

x1=round(0.3*256*T*2);             % Definera stabilitetsområdet
x2=round(0.7*256*T*2);             %        "
maxtopp=max(abs(p(x1:x2,1)));      % Hitta resonanstoppen i stabilitetsområdet
f=find(p==maxtopp);                %        "
wref=f(1)/256*pi/T;
ampl1=p(f(1),1); 

maxtopp=max(abs(p(:,1)));  	     % Koll om  resonanstopp finns utanför
f=find(p==maxtopp);		     % stabilitetsområdet
wres=f(1)/256*pi/T;		     % Resonansfrekvens i radianer
if wres<2*0.7*pi,wres=0;,end

%
% Identifieringsalgoritm
% 
%	Här startar den modifierade delen
%
%	Förfiltrera för att ta bort långsamma variationer, (ARIMA modell)
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
  s(9)=fr(1);                        % Härdresonansfrekvens
  s(10)=wref/2/pi;		     % Resonanstopp i området [0.3-0.7] Hz
  s(11)=wres/2/pi;                   % Resonanstopp (om någon) > 0.7 Hz
  s(12)=nn(1);		             % Modellordning
  s(13)=sdr(1);			     % Standardavvikelse för decay ratio
else  % alkuperäinen osuus if lause ei tarpeellinen
  s(5)=dr;             		     % Decay-Ratio
  s(9)=fr;                           % Härdresonansfrekvens
  s(10)=wref/2/pi;		     % Resonanstopp i området [0.3-0.7] Hz
  s(11)=wres/2/pi;                   % Resonanstopp (om någon) > 0.7 Hz
  s(12)=nn(1);		             % Modellordning
  s(13)=sdr;			     % Standardavvikelse för decay ratio
end






