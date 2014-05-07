%-----------------------------------------------------------------------------------------------%
%												%
% funktion:	eq_DtfDt									%
%												%
% beskrivning:	best�mmer v�rden p� differentialekvationer f�r temperaturer i br�nslenod f�r	%
%		givna temperaturer och totalt v�rme-fl�de fr�n noden 				%
%												%
% indata:	tfm,			medeltemperaturer i br�nslezonerna,			%
%								rader motsvarar noder,		%
%								kolumner motsvarar zoner	%
%		tfM,			temperatur vid br�nslets ytterradie,			%
%								 radnr. motsvarar nodnr.	%
%		qtrissf,cmpfrc		anv�nds vid ber�kning av det totala v�rmefl�det 	%
%					fr�n noden 						%
%		tc0,			temperatur vid kapslings innerradie,			%
%								 radnr. motsvarar nodnr.	%
%		tcm,			medeltemperaturer i kapslingszonerna,			%
%								rader motsvarar noder,		%
%								kolumner motsvarar zoner	%
%		rf,			br�nslets radie						%
%		drca,			tjocklek p� inkapsling					%
%		tw,			temperatur vid nodens yta				%
%		dx,			nodens bredd (angiven i cm)				%
%		nrods,			antalet stavar, nodvis 					%		
%												%
% utdata:	y,			v�rden p� differentialekvationer,			%
%								rader motsvarar noder,		%
%								kolumner motsvarar zoner	%
%												%
% funk. anrop:	cor_pinmprop		>12							%
%												%
% glob. var:	ntot,			totala antalet noder (neutronik)			% 
%		mm,			antal br�nslezoner (4)					% 
%		mmc, 			antal kapslingszoner (2)				%
%												%
%			Emma Lundgren 050930							%
%												%
%-----------------------------------------------------------------------------------------------%

function y = eq_DtfDt(tfm,tfM,qtrissf,tc0,tcm,rf,drca,tw,dx,cmpfrc,nrods);

global 	  fuel geom

kk = 1;

ntot 	= geom.ntot;						
mm	= fuel.mm;						
mmc	= fuel.mmc;						
y	= zeros(ntot,mm+mmc);					% initierar utv�rden

o	= sqrt(0:mm);
rfo	= rf*(o(2:mm+1)./sqrt(mm));				% rfo(:,i) = ytterradie f�r zon i (br�nsle), i = 1..mm
rfm	= 0.5*rf*((o(1:mm)+o(2:mm+1))/sqrt(mm));		% rfm(:,i) = radie till mittpunkt i zon i (br�nsle), i = 1..mm
drc	= drca/mmc;						% drc(:,1) = tjocklek p� "zoner" i cladding 
rc0	= rf;							% s�tter innerradie kapsling till ytterradie br�nsle
rco	= repmat(rc0,1,mmc) + drc*(1:mmc);			% rco(:,j) = ytterradie f�r zon j (kapsling), j = 1..mmc

qtrissf = (1 - cmpfrc)*(dx^2)*qtrissf/pi./rf./rf./nrods/10000;

%----------------------------------------------------------------
%	BER�KNING AV KONDUKTANS F�R GASGAPET
%----------------------------------------------------------------
tf_mean	   = mean(tfm')'; 					% tf_mean = medeltemperatur i kutsen (r�ttframt d� varje zon har samma VOLYM)
kgpd	   = cor_pinmprop(tf_mean,3);				% kgpd =  konduktivitet f�r gasgapet (kgp/d) vid tf_mean och burnup
temp 	   = find(kgpd==0);
kgpd(temp) = ones(size(temp));					% undviker division med noll

		
%----------------------------------------------------------------
%	BER�KNING AV VOLYMETRISK V�RMEKAPACITET F�R BR�NSLE 
%	OCH INKAPSLING
%----------------------------------------------------------------
rof 	= cor_pinmprop(tfm,4);					% rof = br�nslets densitet ber�knad vid zonernas medeltemperatur och burnup
roc 	= cor_pinmprop(tcm,7);					% roc = inkapslingens densitet ber�knad vid zonernas medeltemperatur och burnup
cf 	= cor_pinmprop(tfm,1);					% cf = br�nslets specifika v�rmekapacitet ber�knad vid zonernas medeltemperatur och burnup
cc 	= cor_pinmprop(tcm,5);					% cc = inkapslingens specifika v�rmekapacitet ber�knad vid zonernas medeltemp. och burnup
rocf 	= rof.*cf;						% rocf = br�nslets volymetriska v�rmekapacitet (J/m3C)
rocc 	= roc.*cc;						% rocc = inkapslingens volymetriska v�rmekapacitet (J/m3C)
								% rocc(:,j) = inkapslingens volymetriska v�rmekapacitet i zon j	
								% rocf(:,i) = br�nslets volymetriska v�rmekapacitet i zon i		
%----------------------------------------------------------------
%	BER�KNING AV KONDUKTIVITET VID INKAPSLINGENS YTTERRADIE			        																									      
%----------------------------------------------------------------
kcN = cor_pinmprop(tw,6);					% kcN = konduktivitet vid inkapslingens ytterradie	

			
%----------------------------------------------------------------
%	BER�KNING AV TEMPERATUR OCH KONDUKTIVITET VID 
%	KAPSLINGENS INNERRADIE OCH  										      
%	BER�KNING AV TEMPERATUR OCH KONDUKTIVITET VID 
%	BR�NSLETS YTTERRADIE 			        																									      
%----------------------------------------------------------------
kfM = cor_pinmprop(tfM,2);					% kfM = konduktivitet vid br�nslets ytterradie
kc0 = cor_pinmprop(tc0,6);					% kc0 = konduktivitet vid kapslings innerradie
a12 = -kgpd;
a21 = a12;

diff = 1;
while diff > 0.01
  a11 = kfM./(rf-rfm(:,mm)) + kgpd;
  b1  = kfM./(rf-rfm(:,mm)).*tfm(:,mm);
  a22 = 2*kc0./drc + kgpd;
  b2  = 2*kc0./drc.*tcm(:,1);
  
  tfM_old = tfM;
  tc0_old = tc0;
  
  tfM = (a22.*b1-a12.*b2)./(a11.*a22-a12.*a21);			% tfM = temperatur vid br�nslets ytterradie
  tc0 = (b2-a21.*tfM)./a22;					% tc0 = temperatur vid kapslings innerradie
  kfM = cor_pinmprop(tfM,2);
  kc0 = cor_pinmprop(tc0,6);
  
  diff1 = max(abs(tfM_old-tfM));
  diff2 = max(abs(tc0_old-tc0));
  
  diff = max([diff1 diff2]);
end  


%----------------------------------------------------------------  										      
%	BER�KNING AV KONDUKTIVITET F�R BR�NSLE OCH INKAPSLING			        																									      
%---------------------------------------------------------------- 
o0=ones(ntot,1)*sqrt(0:mm-2);
o1=ones(ntot,1)*sqrt(1:mm-1);
o2=ones(ntot,1)*sqrt(2:mm);

tf_out = (o2-o1)./(o2-o0).*tfm(:,1:mm-1) + ...
	(o1-o0)./(o2-o0).*tfm(:,2:mm);				% temperaturer vid br�nsle-zonernas ytterradier, (zon 1 -> mm-1)
	
tc_out = 0.5*(tcm(:,1:mmc-1)+tcm(:,2:mmc));			% temperaturer vid kapslings-zonernas ytterradier, (zon 1 -> mmc-1)	
 					      
kf 	= cor_pinmprop(tf_out,2);							
kc 	= cor_pinmprop(tc_out,6);	
kf 	= [kf kfM];						% kf(:,i) = br�nslets konduktivitet vid ytterradien av zon i 
kc 	= [kc kcN];						% kc(:,j) = inkapslingens konduktivitet vid ytterradien av zon j  


%----------------------------------------------------------------  										      
%	BR�NSLETEMPERATURER			        																									      
%----------------------------------------------------------------
y(:,1) 		= 1./rocf(:,1).*( 2./rfo(:,1).*kf(:,1)./...
 		                  (rfm(:,2)-rfm(:,1)).*...
				  (tfm(:,2)-tfm(:,1)) + ...
				  qtrissf );
				  		
for i = 2:mm-1
  y(:,i) 	= 1./rocf(:,i).*( 2.*rfo(:,i)./...
  		                  (rfo(:,i).^2-rfo(:,i-1).^2).*...
				  kf(:,i)./(rfm(:,i+1)-rfm(:,i)).*...
				  (tfm(:,i+1)-tfm(:,i)) - ...
				  2.*rfo(:,i-1)./...
  		                  (rfo(:,i).^2-rfo(:,i-1).^2).*...
				  kf(:,i-1)./(rfm(:,i)-rfm(:,i-1)).*...
				  (tfm(:,i)-tfm(:,i-1)) + ...
				  qtrissf );
  
end

y(:,mm) 	= 1./rocf(:,mm).*( 2.*rf./...
  		                   (rf.^2-rfo(:,mm-1).^2).*...
				   kfM./(rf-rfm(:,mm)).*...
				   (tfM-tfm(:,mm)) - ...
				   2.*rfo(:,mm-1)./...
  		                   (rf.^2-rfo(:,mm-1).^2).*...
				   kf(:,mm-1)./(rfm(:,mm)-rfm(:,mm-1)).*...
				   (tfm(:,mm)-tfm(:,mm-1)) + ...
				   qtrissf );


%----------------------------------------------------------------  										      
%	KAPSLINGSTEMPERATURER			        																									      
%----------------------------------------------------------------
if kk == 1							% ta h�nsyn till  kapslingens kr�kning

  y(:,mm+1) 	= 2./rocc(:,1)./drc./(rco(:,1).^2-rc0.^2).*...
 				 ( rco(:,1).*kc(:,1).*...
				   (tcm(:,2) - tcm(:,1)) - ...
				   2.*rc0.*kc0.*...
				   (tcm(:,1) - tc0) ); 

  for j=2:mmc-1
  
    y(:,mm+j) 	= 1./rocc(:,j)./drc./(rco(:,j).^2-rco(:,j-1).^2).*...
  				 ( 2.*rco(:,j).*kc(:,j).*...
				   (tcm(:,j+1) - tcm(:,j)) - ...
				   2.*rco(:,j-1).*kc(:,j-1).*...
				   (tcm(:,j) - tcm(:,j-1)) );
  end				   

  y(:,mm+mmc) 	= 1./rocc(:,mmc)./drc./(rco(:,mmc).^2-rco(:,mmc-1).^2).*...
  				 ( 4.*rco(:,mmc).*kc(:,mmc).*...
				   (tw - tcm(:,mmc)) - ...
				   2.*rco(:,mmc-1).*kc(:,mmc-1).*...
				   (tcm(:,mmc) - tcm(:,mmc-1)) );
				   
else								% modellera kapslingen som planparallella skivor

  y(:,mm+1) 	= 1./rocc(:,1)./drc./drc.*...
 				( kc(:,1).*(tcm(:,2) - tcm(:,1)) - ...
				    2*kc0.*(tcm(:,1) - tc0     ) ); 

  for j=2:mmc-1
  
    y(:,mm+j) 	= 1./rocc(:,j)./drc./drc.*...
  				( kc(:,j  ).*(tcm(:,j+1) - tcm(:,j  )) - ...
				  kc(:,j-1).*(tcm(:,j  ) - tcm(:,j-1)) );
  end				   

  y(:,mm+mmc) 	= 1./rocc(:,mmc)./drc./drc.*...
  				( 2*kc(:,mmc).*(tw         - tcm(:,mmc  )) - ...
				  kc(:,mmc-1).*(tcm(:,mmc) - tcm(:,mmc-1)) );
end				   
				   

				   
		
				   
		  
		  
		  


