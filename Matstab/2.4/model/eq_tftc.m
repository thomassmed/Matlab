%-----------------------------------------------------------------------------------------------%
%												%
% funktion:	eq_tftc										%
%												%
% beskrivning:	bestämmer temperaturer i bränslenod för given yttemperatur och totalt värme-	%
%		flöde från noden i steady-state							%
%												%
% indata:	tw,			temperatur vid nodens yta				%
%		qtherm,power,delta	används vid beräkning av det totala värmeflödet 	%
%					från noden 						%
%		dzz,			nodens höjd (angiven i cm)				%
%		rf,			bränslets radie						%
%		rca,			nodens ytterradie					%
%		drca,			tjocklek på inkapsling					%
%		p,			"top of reactor vessel pressure (Pa)",			%
%					används vid beräkning av "mättningstemperaturer"	%
%		nrods,			antalet stavar, nodvis 					%		
%												%
% utdata:	tf,			bränsletemperaturer, 	 rader motsvarar noder,		%
%								 kolumner motsvarar zoner	%
%		tc,			inkapslingstemperaturer, rader motsvarar noder,		%
%								 kolumner motsvarar zoner	%
%		tfM,			temperatur vid bränslets ytterradie,			%
%								 radnr. motsvarar nodnr.	%
%		tc0,			temperatur vid kapslings innerradie,			%
%								 radnr. motsvarar nodnr.	%
%												%
% funk.anrop:	cor_tsat		1							%
%		set_th2ne		1							%
%		cor_pinmprop		>mmc+mm+3						%
%												%
% glob. var:	ntot,			totala antalet noder (neutronik)			% 
%		mm,			antal bränslezoner (4)					% 
%		mmc, 			antal kapslingszoner (2)				%
%		ihydr,			"hydraulic channel number assigned to 			%
%					neutronic channel number"				%
%												%
%		Emma Lundgren 050930								%
%												%
%-----------------------------------------------------------------------------------------------%


function [tf,tc,tfM,tc0] = eq_tftc(tw,qtherm,power,dzz,rf,rca,drca,p,delta,nrods)

global geom termo fuel

kk = 1;

ntot	= geom.ntot;						
mm	= fuel.mm;						
mmc	= fuel.mmc;						
ihydr	= termo.ihydr;						

p_neu	= p*ones(ntot,1);			
tsat	= cor_tsat(p_neu);					% "mättningstemperaturer"

tw	= set_th2ne(tw,ihydr);					

qk	= power*qtherm*(1-delta)./ntot./nrods;			% qk = totalt värmeflöde från noden (J/s) 
qtriss	= qk./(pi*dzz/100*rf.*rf);				% qtriss = skapad energi per volymsenhet och tidsenhet (J/m3s)


%----------------------------------------------------------------
%	GEOMETRI
%----------------------------------------------------------------
o	= sqrt(0:mm);
rfo	= rf*(o(2:mm+1)./sqrt(mm));				% rfo(:,i) = ytterradie för zon i (bränsle), i = 1..mm
rfm	= 0.5*rf*((o(1:mm)+o(2:mm+1))/sqrt(mm));		% rfm(:,i) = radie till mittpunkt i zon i (bränsle), i = 1..mm
drc	= drca/mmc;						% drc(:,1) = tjocklek på "zoner" i cladding 
rc0	= rf;							% sätter innerradie kapsling (rc0) till ytterradie bränsle (rf)
rco	= repmat(rc0,1,mmc) + drc*(1:mmc);			% rco(:,j) = ytterradie för zon j (kapsling), j = 1..mmc


%----------------------------------------------------------------
%	TEMPERATURER KAPSLING
%----------------------------------------------------------------
kc = cor_pinmprop(tw,6);					% medeltemperatur kapslingszon mmc => tc(mmc)
if kk == 1
  tc(:,mmc) = tw + 0.25*qtriss.*rf.*rf.*drc./rco(:,mmc)./kc;
else
  tc(:,mmc) = tw + 0.25*qtriss.*rf.*drc./kc; 
end  

tc1 = tc(:,mmc);						% medeltemperatur kapslingszon mmc-1 =>tc(mmc-1)
[cor, alfa, beta, t2]=cor_pinmprop(tc(:,mmc),6);
if kk == 1 
  kappa = 2*rco(:,mmc)./rco(:,mmc-1).*kc.*(tw-tc(:,mmc));
else
  kappa = 2*kc.*(tw-tc(:,mmc)); 
end  
tc2 = (tc1.*(alfa./kappa-0.5.*beta)-1)./(alfa./kappa+0.5.*beta);
tc12=0.5*(tc1+tc2);						
while tc12>t2
  [cor, alfa, beta, t2]=cor_pinmprop(t2+1,6);			
  tc2 = (tc1.*(alfa./kappa-0.5.*beta)-1)./(alfa./kappa+0.5.*beta);
  tc12=0.5*(tc1+tc2);
end
tc(:,mmc-1)=tc2;
kc = alfa./(1+beta.*tc12);

for j = mmc-1:-1:2						% medeltemperatur kapslingszon mmc-2 -> 1 =>tc(mmc-2) -> tc(1)
  tc1 = tc(:,j);
  [cor, alfa, beta, t2]=cor_pinmprop(tc(:,j),6);
  if kk == 1
    kappa = rco(:,j)./rco(:,j-1).*kc.*(tc(:,j+1)-tc(:,j));
  else
    kappa = kc.*(tc(:,j+1)-tc(:,j));
  end    
  tc2 = (tc1.*(alfa./kappa-0.5.*beta)-1)./(alfa./kappa+0.5.*beta);
  tc12=0.5*(tc1+tc2);						
  while tc12>t2
    [cor, alfa, beta, t2]=cor_pinmprop(t2+1,6);			
    tc2 = (tc1.*(alfa./kappa-0.5.*beta)-1)./(alfa./kappa+0.5.*beta);
    tc12=0.5*(tc1+tc2);
  end
  tc(:,j-1)=tc2;
  kc = alfa./(1+beta.*tc12);
end

tc1 = tc(:,1);							% tc0, temperatur vid kapslings innerradie
[cor, alfa, beta, t2]=cor_pinmprop(tc(:,1),6);
if kk == 1
  kappa = 0.5*rco(:,1)./rc0.*kc.*(tc(:,2)-tc(:,1));
else
  kappa = 0.5*kc.*(tc(:,2)-tc(:,1));
end    
tc2 = (tc1.*alfa./kappa-1)./(alfa./kappa+beta);
while tc2>t2
  [cor, alfa, beta, t2]=cor_pinmprop(t2+1,6);			
  tc2 = (tc1.*alfa./kappa-1)./(alfa./kappa+beta);
end
tc0=tc2;
kc0 = alfa./(1+beta.*tc0); 


%----------------------------------------------------------------
%	BRÄNSLE	
%----------------------------------------------------------------
tf_mean = tsat;
diff    = 1;
antal_iterationer = 0;
							
while (diff > 0.05) && (antal_iterationer<20)		        % konduktiviteten för gasgapet ska bestämmas vid bränslets 
								% medeltemp, sätter tf_mean = tsat inledningsvis, itererar.			
  kgpd=cor_pinmprop(tf_mean,3);					  								
  tfM = tc0 + (2*kc0./drc./kgpd).*(tc0 - tc(:,1));		% tfM, temperatur vid bränslets ytterradie
  kf = cor_pinmprop(tfM,2);
  
  tf(:,mm) = tfM + kgpd.*(rf-rfm(:,mm))./kf.*(tfM - tc0);	% medeltemperatur bränslezon mm => tf(mm)

  tf1 = tf(:,mm);						% medeltemperatur bränslezon mm-1 => tf(mm-1)
  [cor, alfa, beta, t2]=cor_pinmprop(tf(:,mm),2);
  kappa = (rfm(:,mm)-rfm(:,mm-1))./rfo(:,mm-1).*...
  	  (rf./(rf-rfm(:,mm)).*kf.*(tfM-tf(:,mm))+...
	   0.5*qtriss.*(rf.^2-rfo(:,mm-1).^2));
  rf1 = (rfo(:,mm-1)-rfm(:,mm-1))./(rfm(:,mm)-rfm(:,mm-1));
  rf2 = (rfm(:,mm  )-rfo(:,mm-1))./(rfm(:,mm)-rfm(:,mm-1));	   
  tf2 = (tf1.*(alfa./kappa-rf1.*beta)-1)./(alfa./kappa+rf2.*beta);
  tf12 = rf2.*tf2 + rf1.*tf1;  						
  while tf12>t2
    [cor, alfa, beta, t2]=cor_pinmprop(t2+1,2);			
    tf2 = (tf1.*(alfa./kappa-rf1.*beta)-1)./(alfa./kappa+rf2.*beta);
    tf12 = rf1.*tf2 + rf2.*tf1;
  end
  tf(:,mm-1)=tf2;
  kf = alfa./(1+beta.*tf12); 

  for i=mm-1:-1:2						% medeltemperatur bränslezon mm-2 -> 1 => tf(mm-2) -> tf(1)
    tf1 = tf(:,i);
    [cor, alfa, beta, t2]=cor_pinmprop(tf(:,i),2);
    kappa = (rfm(:,i)-rfm(:,i-1))./rfo(:,i-1).*...
  	    (rfo(:,i)./(rfm(:,i+1)-rfm(:,i)).*kf.*(tf(:,i+1)-tf(:,i))+...
	     0.5*qtriss.*(rfo(:,i).^2-rfo(:,i-1).^2));			
    rf1 = (rfo(:,i-1)-rfm(:,i-1))./(rfm(:,i)-rfm(:,i-1));
    rf2 = (rfm(:,i  )-rfo(:,i-1))./(rfm(:,i)-rfm(:,i-1));
    tf2 = (tf1.*(alfa./kappa-rf1.*beta)-1)./(alfa./kappa+rf2.*beta);
    tf12 = rf2.*tf2 + rf1.*tf1;
    while tf12>t2
      [cor, alfa, beta, t2]=cor_pinmprop(t2+1,2);
      tf2 = (tf1.*(alfa./kappa-rf1.*beta)-1)./(alfa./kappa+rf2.*beta);
      tf12 = rf1.*tf2 + rf2.*tf1;
    end
    tf(:,i-1)=tf2;
    kf = alfa./(1+beta.*tf12);
  end
  
  tf_mean_old = tf_mean;
  tf_mean=mean(tf')';
  
  diff = max(abs(tf_mean_old - tf_mean));
  antal_iterationer = antal_iterationer + 1;
    						
end







	       
  
  



	       
