% DRIDENT.M  Revision : 5		Datum : 920610
%           (revision 4 hade datum : 920323)             
% Levererar resultat p s-format (se help s). S-formatet innehller
% statistik p signalen, resultat frn spektralanlys och identifiering
% av signalens dmpning och egenfrekvenser.
%
% Syntax : [s,th]=drident(x,T,signnr,nn,sd,ns);
% x :      Insignal fr berkning
% T :      Samplingstiden i s
% nn :	   Man vljer sjlv vilken ordning identifieringen skall
%	   starta p (default nn=[10 9] eller [11 10])
% sd :	   Standardavvikelsen som pol/nollstllesreduktionsalgoritmen
%	   anvnder (default sd=0.5)
% ns :	   Nedsampling (default ns=2)
%
% 	   Bengt Melkerson	Pr Lanseker		Camilla Rotander
%	   Vattenfall		Vattenfall		RPA
%	   Ringhalsverket	Forsmarksverket		ABB Atom
%	   S-432 32 VRBACKA	S-742 03 STHAMMAR	S-721 63 Vsters
%	   SWEDEN		SWEDEN			SWEDEN
%
%	   Modifierad 92-06-10
%
%	   Bengt Melkerson
%	
% nytt:	   Nargin kat till 5.Default nn ndrad till [10 10]. Ifsats infrd
%	   fr decimering. Ifsats fr att avgra om DR skall berknas
%	   eller inte infrd (processignaler). Frsta identifieringen utfrs
%	   under whilesatsen. Whilesats fr identifiering ndrad (nn(1)>=2). 
%	   

function [s,th]=drident5(x,T,nn,sd,ns);

echo off

if nargin==2, 
   nn=[10 10]; 
   sd=0.5;
   ns=2;
elseif nargin==3
   sd=0.5;
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
s(7)=s(6)*100/s(1);	% T-T / medelvrde i %
s(8)=s(4)*100/s(1);	% Standardavvikelse / medelvrde i %

% Signalbehandling

y=dtrend(x,1);
if ns==1
  y=decimate(y,ns,'fir');
  T=ns*T;
end

% Berkning av effektspektrum

p=spectrum(y,512,256);
p=p(:,1);

% Rimlighetskontroll fr spektrum

x1=round(0.3*256*T*2);             % Definera stabilitetsomrdet
x2=round(0.7*256*T*2);             %        "
maxtopp=max(abs(p(x1:x2,1)));      % Hitta resonanstoppen i stabilitetsomrdet
f=find(p==maxtopp);                %        "
wref=f(1)/256*pi/T;
ampl1=p(f(1),1); 
 
maxtopp=max(abs(p(:,1)));  	     % Koll om  resonanstopp finns utanfr
f=find(p==maxtopp);		     % stabilitetsomrdet
wres=f(1)/256*pi/T;		     % Resonansfrekvens i radianer
if wres<2*0.7*pi,wres=0;,end


  % Identifieringsalgoritm
  % 
  %	Hr startar den modifierade delen
  %
  %	Frfiltrera fr att ta bort lngsamma variationer, (ARIMA modell)
  %
     	yp=filter([1 -1],1,y);
	yp(1)=yp(2);
	y=yp;

	nno=nn+1;
	while (nno>nn)&(nn(1)>=2)
 	     ks=int2str(nn(1));
	     th=armax(y,nn,-1,-1,-1,[],T);  
	     flag=polred(th,sd);
	     nno=nn; nn=nn-flag;
	     if (flag==0 | nn(1)>=2)
	       [dr,sdr,fr]=th2dr(th,T);
	  	if length(dr)>1
	           nn=nn-2;
	 	end
	     end
	end
  s(5)=dr;             	     % Decay-Ratio
  s(9)=fr;                   % Hrdresonansfrekvens
  s(12)=nn(1);		     % Modellordning
  s(13)=sdr;		     % Standardavvikelse fr decay ratio
else
  s(5)=NaN;
  s(9)=NaN;
  s(12)=NaN;
  s(13)=NaN;
end
s(10)=wref/2/pi;	     % Resonanstopp i omrdet [0.3-0.7] Hz
s(11)=wres/2/pi;             % Resonanstopp (om ngon) > 0.7 Hz
