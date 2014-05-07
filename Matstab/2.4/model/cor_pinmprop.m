%-----------------------------------------------------------------------------------------------%
%												%
% funktion:	cor_pinmprop	(CORrelations, fuel PIN Material PROPerties)			%
%												%
% beskrivning:	bestämmer värde på önskad korrelation för given temperaturvektor,		%
%												%
% indata:	t 	temperaturer, kolumnvektor/matris					%
%		flag	indikerar vilken korrelation som söks:					%
%			flag = 									%
% 				1- uo2c	fuel heat capacity 					%
% 				2- uo2k	fuel conductivity 					%
% 				3- gapk	gap conductivity 					%
% 				4- uo2r	fuel density 						%
% 				5- zrcc	clad heat capacity 					%
% 				6- zrck	clad conductivity 					%
% 				7- zrcr	clad density 	 					%
% kommentar:	flag = 1,3:5,7									%
%				korrelation bestäms med linjär interpolation:			%
%								 cor = alfa + beta*t		%
%		flag = 2,6									%
%				korrelation anpassas till formen:				%
%								 cor = alfa/(1+beta*t)		%										%
%												%
% utdata:	cor 	korrelation, kolumnvektor/matris cor(j,i) svarar mot t(j,i)		%
%		alfa	se kommentar, kolumnvektor/matris alfa(j,i) svarar mot t(j,i)		%
%		beta	se kommentar, kolumnvektor/matris beta(j,i) svarar mot t(j,i)		%
%		t2	anger inom vilket temperaturintervall t ligger, t1 <= t < t2		%
%				    , kolumnvektor/matris t2(j,i) svarar mot t(j,i)		%
%												%
% funk. anrop:	-										%
%												%
% glob. var:	xxxx.t										%
%		xxxx.tab									%
%				xxxx: uo2c,uo2k,gapk,uo2r,zrcc,zrck,zrcr			%
%												%
%			Emma Lundgren 050930							%
%												%
%-----------------------------------------------------------------------------------------------%

function [cor, alfa, beta, t2]=cor_pinmprop(t,flag)

global fuel

flag2 = 0;

switch flag

case 1
  temp	= fuel.uo2c.t;				% temperatur-ingångar (rad i motsvarar nod i)
  tab	= fuel.uo2c.tab;			% tabellvärden (tab(i,j) motsvarar temp(i,j))
  flag	= 1;					% linjär interpolation
case 2
  temp	= fuel.uo2k.t;				% temperatur-ingångar (rad i motsvarar nod i)
  tab	= fuel.uo2k.tab;			% tabellvärden (tab(i,j) motsvarar temp(i,j))
  flag	= 2;					% cor = alfa/(1+beta*t)
case 3
  temp	= fuel.gapk.t;				% temperatur-ingångar (rad i motsvarar nod i)
  tab	= fuel.gapk.tab;			% tabellvärden (tab(i,j) motsvarar temp(i,j))
  flag	= 1;					% linjär interpolation
case 4
  temp	= fuel.uo2r.t;				% temperatur-ingångar (rad i motsvarar nod i)
  tab	= fuel.uo2r.tab;			% tabellvärden (tab(i,j) motsvarar temp(i,j))
  flag	= 1;					% linjär interpolation
case 5
  temp	= fuel.zrcc.t;				% temperatur-ingångar (rad i motsvarar nod i)
  tab	= fuel.zrcc.tab;			% tabellvärden (tab(i,j) motsvarar temp(i,j))
  flag	= 1;					% linjär interpolation
case 6
  temp	= fuel.zrck.t;				% temperatur-ingångar (rad i motsvarar nod i)
  tab	= fuel.zrck.tab;			% tabellvärden (tab(i,j) motsvarar temp(i,j))
  flag	= 2;					% cor = alfa/(1+beta*t)
case 7
  temp	= fuel.zrcr.t;				% temperatur-ingångar (rad i motsvarar nod i)
  tab	= fuel.zrcr.tab;			% tabellvärden (tab(i,j) motsvarar temp(i,j)) 
  flag	= 1;					% linjär interpolation
end 

temp(:,1) = [];					% tar bort första kolumnen i temp (innehåller antal ingångar)									
				
[mt,nt]	= size(temp);				% maxantal temperatur-ingångar
[ot,pt] = size(t);


temp1	= temp';
temp1	= temp1(:);
tab1	= tab';
tab1	= tab1(:);

add	= [0:nt:nt*(mt-1)]';

for i = 1:pt					% för samtliga "temperatur-zoner"				
						
  t_m	= repmat(t(:,i),1,nt);				
  t_m	= (t_m <  temp(:,1:nt)) & ...
  	  (t_m >= [zeros(mt,1) temp(:,1:nt-1)]);
  [v,u]	= find(t_m');				% temp(j,v-1) <= t(j,i) < temp(j,v)
  
  v	= v + add;
  
  
  t1		= temp1(v-1,1);
  t2(:,i) 	= temp1(v  ,1);			% t1(j) <= t(j,i) < t2(j,i)
  k1		= tab1( v-1,1);				
  k2		= tab1( v  ,1);	
  
  
  %						
  % flag = 1 =>						
  % 		k1 = alfa + beta*t1 
  % 		k2 = alfa + beta*t2	=> 	alfa = (t2k1-t1k2)/(t2-t1)
  %						beta = (k2-k1)/(t2-t1)
  % flag = 2 =>
  % 		k1 = alfa/(1+beta*t1)
  % 		k2 = alfa/(1+beta*t2)	=> 	alfa = k1*k2*(t2-t1)/(k2*t2-k1*t1)
  %						beta = -(k2-k1)/(k2*t2-k1*t1)
  %

  if flag == 1
    nn		= t2(:,i)  - t1;
    alfa(:,i) 	= (t2(:,i) .*k1 - t1.*k2)./nn;
    beta(:,i) 	= (k2-k1)./nn;
    cor(:,i) 	= alfa(:,i) + beta(:,i).*t(:,i);

  elseif flag == 2
    nn		= k2.*t2(:,i) - k1.*t1;
    alfa(:,i)  	= k1.*k2.*(t2(:,i) - t1)./nn;
    beta(:,i) 	= -(k2-k1)./nn;	
    cor(:,i)  	= alfa(:,i)./(1+beta(:,i).*t(:,i));
  end 
  
end 

