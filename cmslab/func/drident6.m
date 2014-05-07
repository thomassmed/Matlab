% DRIDENT:M  Revision : 6.1     Datum : 930309
%                     
% Levererar resultat p s-format (se help s). S-formatet innehller
% statistik p signalen, resultat frn spektralanlys och identifiering
% av signalens dmpning och egenfrekvenser.
%
% Syntax : [s,th]=drident(x,T,nn,sd,ns);
% x :      Insignal fr berkning
% T :      Samplingstiden i s
%
%
% nn	-	man vljer sjlv vilken ordning identifieringen skall
%		starta p (default nn=[10 9] eller [11 10])
% sd	-	standardavvikelsen som pol/nollstlles-
%		reduktionsalgoritmen anvnder (default sd=0.25)
% ns	-	nedsampling (default ns=2)
%

% 	   Bengt Melkerson	        Pr Lansker
%	   Vattenfall			Vattenfall
%	   Ringhalsverket		Forsmarksverket
%	   S-432 32 VRBACKA	        S-742 03 STHAMMAR
%	   SWEDEN      			SWEDEN
%
%
%   	   Camilla Rotander
%	   RPA
%	   ABB Atom
%	   S-721 63 Vsters
%	   SWEDEN


%nytt:	efter nedsampling differentieras signalen fr att ta bort lng-
%       samma oscillationer. Identifieringen startar p vald ordning. Om
%	poler/nollstllen kancellerar varandra (d v s deras "standardavvikel-
%	se-ellipser" skr varandra, eller omrdena tcker varandra helt) grs
%	identifieringen om med snkt ordning (se POLRED). Ordningen snks med 1 
%       om det r reell pol/reellt nollstlle, och med 2 om det r komplex 
%       pol/komplext nollstlle. Nr slutlig ordning uppntts kontrolleras 
%       (som tidigare) om det ligger fler en 1 polpar inom frekvens-intervallet
%       0.3-0.7 Hz.Om det gr det, grs identifieringen om med snkt ordning.
%       Nr den slutliga ordningen uppntts berknas decay ratio med standardav-
%       vikelse samt resonansfrekvens (se TH2DR).
%
%	Om ingen pol hittas blir resultatet "NaN". S-formatet presenteras med
%       show(s), se ven stpr.
%
% 
%
function [s,th]=drident(x,T,nn,sd,ns);

echo off

if nargin==2, 
   nn=[10 9]; 
   sd=0.25;
   ns=2;
elseif nargin==3
   sd=0.25;
   ns=2;
elseif nargin==4
   ns=2;
end


% Statistikberkningar

s(1)=mean(x);		% Medelvrde
s(2)=max(x);		% Maxvrde
s(3)=min(x);		% Minvrde
s(4)=std(x);		% Standardavvikelse
s(6)=s(2)-s(3);		% Topp - toppvrde
s(7)=s(6)*100/s(1);		% T-T / medelvrde i %
s(8)=s(4)*100/s(1);		% Standardavvikelse / medelvrde i %

% Signalbehandling

y=dtrend(x,1);
if T<0.1                         %Pak 930309
  y=decimate(y,ns,'fir');
  T=ns*T;
end
% Berkning av effektspektrum

p=spectrum(y,512,256);
p=p(:,1);

% Rimlighetskontroll fr spektrum

x1=round(0.3*256*T*2);            
x2=round(0.7*256*T*2);           
maxtopp=max(abs(p(x1:x2,1)));      % Hitta resonanstoppen i stabilitetsomrdet
f=find(p==maxtopp);                %        "
wref=f(1)/256*pi/T;
ampl1=p(f(1),1); 

maxtopp=max(abs(p(:,1)));  	     % Koll om  resonanstopp finns utanfr
f=find(p==maxtopp);		     % stabilitetsomrdet
wres=f(1)/256*pi/T;		     % Resonansfrekvens i radianer
if wres<2*0.7*pi,wres=0;,end

%
% Identifieringsalgoritm
% 
% Hr startar den modifierade delen
%
% Frfiltrera fr att ta bort lngsamma variationer, (ARIMA modell)
%
%yp=filter([1 -1],1,y);         Tas bort tillsvidare Pak 930322
%yp(1)=yp(2);
%y=yp;

nno=nn+1;
while (nn(1)>=4)&(nno(1)>nn(1))                 %Avbrottsvillkor
  th=parmax(y,nn,-1,-1,-1,-1,T);  
  zpplot(th2zp(th),1)
  flag=polred(th,sd);
  nno=nn;nn=nn-flag;
% [dr,sdr,fr,ok]=th2dr(th,T);           %Ingen koll av nollstallen
% if (flag==0)&((length(dr)>1)|(~ok)),  %Pak 930309
  [dr,sdr,fr]=th2dr(th,T);
  if (flag==0)&(length(dr)>1),          %Koll om fler n ett polpar 
    if nn(1)==5,   
      nn=nn-1;    
    else
      nn=nn-2;                           
    end
  end                                  
end
%
%
if length(dr)==1,
  s(5)=dr;             		     % Decay-Ratio
  s(9)=fr;                           % Hrdresonansfrekvens
  s(13)=sdr;			     % Standardavvikelse fr decay ratio
else
  s(5)=NaN;
  s(9)=NaN;
  s(13)=NaN;		             % Standardavvikelse fr decay ratio
end
s(10)=wref/2/pi;		     % Resonanstopp i omrdet [0.3-0.7] Hz
s(11)=wres/2/pi;                     % Resonanstopp (om ngon) > 0.7 Hz
s(12)=nno(1);		             % Modellordning

