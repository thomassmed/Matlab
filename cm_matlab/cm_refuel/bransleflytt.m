%@(#)   bransleflytt.m 1.1	 05/12/08     14:34:05
%
%function f = bransleflytt(eocfil, bocfil, v, utfil)
% 
%Inparametrar:
%EOCFIL: tex eoc23.dat
%BOCFIL: tex boc24.dat
%V: Om v väljs till 1 skrivs även asyid ut, annars väljs v till 0.
%UTFIL: Utfilen som resultatet skrivs ut i.
% 
%Funktionen skriver ut kedjorna som bränslet förflyttas i.

function f = bransleflytt(dist1, dist2, v, utfil)

a = readdist7(dist1, 'asyid');		%Läser in de angivna filerna i a och b.
[b, mminj, konrod, bb, hy, mz] = readdist7(dist2, 'asyid');


c = mbucatch(a,b);		%Läser in värden för respektive gammal och ny plats.
d = mbucatch(b,a);

fid = fopen(expand(utfil,'txt'), 'w');		%Skriver ut i filen utfil.txt.














fprintf(1, '\n\n');
fprintf(fid, '\n\n\n\n\nBränslepatroner i öppna kedjor');

for i = 1:mz(14)
	p1 = i;			%Tilldelar p1 värde av i.
	k1 = knum2cpos(i, mminj);		%Beräknar första koordinaten.
	m = 6;
	n = 0;
	
	if (d(i) == 0) & (c(i) ~= 0)			%För att inte första koordinaten i ej fullständiga kedjor och för bränslen som 
							%tagit bort och ersatts av en ny direkt ska skrivas ut.
		%Skriver ut första koordinaten.
		fprintf(fid, '\n\n%3i%3i', k1(1), k1(2));
		if v == 1
			%Skriver ut identitetsnummer för bränslet när v är valt till 1.
			fprintf(fid, ' (%6s) ', a(i,:));	
		end
	end
	
	
		

		
	if c(i) ~= i			%För att inte bränslen som inte flyttats ska komma med.
		for j = 1:mz(14)
			p2 = c(p1);		%Tilldelar p2 värdet av de nya koordinaterna.
						
							
			if p2 == 0 & d(i) == 0		%Väljer ut förflyttningar som slutar i ett bortaget bränsle och börjar före ett nyinsatt bränsle.
											
				break
			
			elseif d(i) ~= 0		%För att loopen ska sluta när ej önskvärda förflyttningar dyker upp.
				
				break
				
			else
				
				
				fprintf(fid, '    ->    ');
				
				if j == m + 6 * n
					%Skriver en radbrytning när 6 koordinatre har skrivits ut på en rad.
					fprintf(fid, '\n');
					n = n + 1;
				end				
				
				p1 = p2;		%Tilldelar p1 värdet av p2 för att börja om loopen.
				k2 = knum2cpos(p2, mminj);		%Beräknar in resterande koordinater.
				%Skriver ut resterande koordinater.
				fprintf(fid, '     %1i%3i', k2(1), k2(2));
				
				if v == 1
				%Skriver ut identitetsnummer för bränslet när v är valt till 1.
					fprintf(fid, ' (%6s) ', a(p2,:));	
				end
			
			end
			
		end
		
	end
	
end





















fprintf(fid, '\n\n\n\n\nBränslepatroner i slutna kedjor');

l = 1;
A = zeros(mz(14));		%Skapar en matris, A för att lagra de slutna kedjorna i.

for i = 1:mz(14)
	p1 = i;				%Tilldelar p1 värdet av i
		
			
	if c(i) ~= i 				%För att inte bränslen som inte flyttats ska komma med.
		for j = 1:mz(14)
			p2 = c(p1);			%Tilldelar p2 värdet av de nya koordinaterna.
						
			
			if p2 == 0			%För att inte p1 ska få värdet noll.
				break
			
			
			
			elseif p2 == i				%För att sortera ut de slutna kedjor från de öppna.
				p1 = i;				%Tilldelar p1 värdet i igen för att kunna loopa ut koordinaterna
				
				
				for k = 1:mz(14)				%Loopar ut koordinaterna
					p2 = c(p1);			%Tilldelar p2 värdet av de nya koordinaterna.
					
					if p2 == 0				%För att inte p1 ska få värdet noll
						break					
								
					elseif 	p2 == i 				%När kedjan är sluten är p2 lika med den första positionen i.
						
						A(k,l) = p1;				%Lagrar sista positionen i matris A.
											
						break
			
					else
						
						A(k,l) = p1;				%Largrar positionerna i matris A.
						
						p1 = p2;				%Tilldelar p1 värdet av p2 för att börja om loopen.	
					end					
				end
				
				l = l + 1;					%Ökar värdet på l med 1 för att positionerna ska lagras på ny plats i A.
				
				break
			
			
			
			
			
			else
				p1 = p2;		%Tilldelar p1 värdet av p2 för att börja om loopen.
					
			end
		
			
			
		end
		
	end
	
end





for i = 1:mz(14)			%Loopar igenom alla koordinater hos A.
	
	for j = 1:mz(14)
		
		if A(j,i) ~= 0				%För att inte få med elementen i A som inte har någon position lagrad.
		
			for k = 1:mz(14)
				
				for l = 1:mz(14)
				
					if (A(j,i) == A(l,k)) & (i ~= k) & (j ~= l)	%När de är lika men inte när det är en själv.
						A(l,k) = 0;			%Tilldelar de dubbla positionerna värdet 0 för att sortera bort dubletterna.
					end
				end
			end
		end			
	end			
end






for i = 1:mz(14)

	m = 6;
	n = 0;

	if A(1,i) ~= 0				%För att inte få med elementen i A som inte har någon position lagrad.

		fprintf(fid, '\n\n');
	end
	
	for j = 1:mz(14)
		
		if A(j,i) ~= 0					%För att inte få med elementen i A som inte har någon position lagrad.
			
			if j == m + 6 * n
				%Skriver en radbrytning när 6 koordinatre har skrivits ut på en rad.
				fprintf(fid, '\n');
				n = n + 1;
			end				
			
			
			k1 = knum2cpos(A(j,i), mminj);			%Beräknar koordinaterna.
			%Skriver ut koordinaterna.
			fprintf(fid, '%6i%3i', k1(1), k1(2));
			
			if v == 1
				%Skriver ut identitetsnummer för bränslet när v är valt till 1.
				fprintf(fid, ' (%6s) ', a((A(j,i)),:));
			end
			
		
			fprintf(fid, '    ->');
		
		end


	end
	
	if A(1,i) ~= 0
		
		if j == m + 6 * n
			%Skriver en radbrytning när 6 koordinatre har skrivits ut på en rad.
			fprintf(fid, '\n');
			n = n + 1;
		end				
		
		k2 = knum2cpos(A(1,i), mminj);		%Beräknar sista koordinaten (samma som första);
		%Skriver ut sista koordinaten.
		fprintf(fid, '%6i%3i', k2(1), k2(2));
		
		if v == 1
			%Skriver ut identitetsnummer för bränslet när v är valt till 1.
			fprintf(fid, ' (%6s) ', a((A(1,i)),:));
		end
	end

end


















fprintf(fid, '\n\n\n\n\nBränslepatroner som ej flyttats');

for i = 1:mz(14)
	p1 = i;
		
	if c(i) == i					%För de bränslen som inte flyttats.
		k1 = knum2cpos(i, mminj);			%Beräknar koordinaten.
		%Skriver ut koordinaten
		fprintf(fid, '\n\n%6i%3i', k1(1), k1(2));
		
		if v == 1
			%Skriver ut identitetsnummer för bränslet när v är valt till 1.
			fprintf(fid, ' (%6s) ', a(i,:));
		end
	end
	
end	
















fprintf(fid, '\n\n\n\n\nBränslepatroner som ersatts av en ny utan att ingå i en kedja.');

for i = 1:mz(14)
	p1 = i;

	if (c(i) == 0) & (d(i) == 0)			%Väljer ut förflyttningar som slutar i ett bortaget bränsle och börjar före ett nyinsatt bränsle föpr
							%samma bränsle
		k1 = knum2cpos(i, mminj);			%Beräknar koordinaten.
		%Skriver ut koordinaten
		fprintf(fid, '\n\n%6i%3i', k1(1), k1(2));
		
		if v == 1
			%Skriver ut identitetsnummer för bränslet när v är valt till 1.
			fprintf(fid, ' (%6s) ', a(i,:));
		end
	end		
end
		









fprintf(1, 'Kedjorna finns utskrivna i %s', utfil);
fprintf(1, '\n\n\n');

fprintf(fid, '\n\n\n');

			
fclose(fid);		%Stänger filen.


			
		




