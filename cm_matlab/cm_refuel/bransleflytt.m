%@(#)   bransleflytt.m 1.1	 05/12/08     14:34:05
%
%function f = bransleflytt(eocfil, bocfil, v, utfil)
% 
%Inparametrar:
%EOCFIL: tex eoc23.dat
%BOCFIL: tex boc24.dat
%V: Om v v�ljs till 1 skrivs �ven asyid ut, annars v�ljs v till 0.
%UTFIL: Utfilen som resultatet skrivs ut i.
% 
%Funktionen skriver ut kedjorna som br�nslet f�rflyttas i.

function f = bransleflytt(dist1, dist2, v, utfil)

a = readdist7(dist1, 'asyid');		%L�ser in de angivna filerna i a och b.
[b, mminj, konrod, bb, hy, mz] = readdist7(dist2, 'asyid');


c = mbucatch(a,b);		%L�ser in v�rden f�r respektive gammal och ny plats.
d = mbucatch(b,a);

fid = fopen(expand(utfil,'txt'), 'w');		%Skriver ut i filen utfil.txt.














fprintf(1, '\n\n');
fprintf(fid, '\n\n\n\n\nBr�nslepatroner i �ppna kedjor');

for i = 1:mz(14)
	p1 = i;			%Tilldelar p1 v�rde av i.
	k1 = knum2cpos(i, mminj);		%Ber�knar f�rsta koordinaten.
	m = 6;
	n = 0;
	
	if (d(i) == 0) & (c(i) ~= 0)			%F�r att inte f�rsta koordinaten i ej fullst�ndiga kedjor och f�r br�nslen som 
							%tagit bort och ersatts av en ny direkt ska skrivas ut.
		%Skriver ut f�rsta koordinaten.
		fprintf(fid, '\n\n%3i%3i', k1(1), k1(2));
		if v == 1
			%Skriver ut identitetsnummer f�r br�nslet n�r v �r valt till 1.
			fprintf(fid, ' (%6s) ', a(i,:));	
		end
	end
	
	
		

		
	if c(i) ~= i			%F�r att inte br�nslen som inte flyttats ska komma med.
		for j = 1:mz(14)
			p2 = c(p1);		%Tilldelar p2 v�rdet av de nya koordinaterna.
						
							
			if p2 == 0 & d(i) == 0		%V�ljer ut f�rflyttningar som slutar i ett bortaget br�nsle och b�rjar f�re ett nyinsatt br�nsle.
											
				break
			
			elseif d(i) ~= 0		%F�r att loopen ska sluta n�r ej �nskv�rda f�rflyttningar dyker upp.
				
				break
				
			else
				
				
				fprintf(fid, '    ->    ');
				
				if j == m + 6 * n
					%Skriver en radbrytning n�r 6 koordinatre har skrivits ut p� en rad.
					fprintf(fid, '\n');
					n = n + 1;
				end				
				
				p1 = p2;		%Tilldelar p1 v�rdet av p2 f�r att b�rja om loopen.
				k2 = knum2cpos(p2, mminj);		%Ber�knar in resterande koordinater.
				%Skriver ut resterande koordinater.
				fprintf(fid, '     %1i%3i', k2(1), k2(2));
				
				if v == 1
				%Skriver ut identitetsnummer f�r br�nslet n�r v �r valt till 1.
					fprintf(fid, ' (%6s) ', a(p2,:));	
				end
			
			end
			
		end
		
	end
	
end





















fprintf(fid, '\n\n\n\n\nBr�nslepatroner i slutna kedjor');

l = 1;
A = zeros(mz(14));		%Skapar en matris, A f�r att lagra de slutna kedjorna i.

for i = 1:mz(14)
	p1 = i;				%Tilldelar p1 v�rdet av i
		
			
	if c(i) ~= i 				%F�r att inte br�nslen som inte flyttats ska komma med.
		for j = 1:mz(14)
			p2 = c(p1);			%Tilldelar p2 v�rdet av de nya koordinaterna.
						
			
			if p2 == 0			%F�r att inte p1 ska f� v�rdet noll.
				break
			
			
			
			elseif p2 == i				%F�r att sortera ut de slutna kedjor fr�n de �ppna.
				p1 = i;				%Tilldelar p1 v�rdet i igen f�r att kunna loopa ut koordinaterna
				
				
				for k = 1:mz(14)				%Loopar ut koordinaterna
					p2 = c(p1);			%Tilldelar p2 v�rdet av de nya koordinaterna.
					
					if p2 == 0				%F�r att inte p1 ska f� v�rdet noll
						break					
								
					elseif 	p2 == i 				%N�r kedjan �r sluten �r p2 lika med den f�rsta positionen i.
						
						A(k,l) = p1;				%Lagrar sista positionen i matris A.
											
						break
			
					else
						
						A(k,l) = p1;				%Largrar positionerna i matris A.
						
						p1 = p2;				%Tilldelar p1 v�rdet av p2 f�r att b�rja om loopen.	
					end					
				end
				
				l = l + 1;					%�kar v�rdet p� l med 1 f�r att positionerna ska lagras p� ny plats i A.
				
				break
			
			
			
			
			
			else
				p1 = p2;		%Tilldelar p1 v�rdet av p2 f�r att b�rja om loopen.
					
			end
		
			
			
		end
		
	end
	
end





for i = 1:mz(14)			%Loopar igenom alla koordinater hos A.
	
	for j = 1:mz(14)
		
		if A(j,i) ~= 0				%F�r att inte f� med elementen i A som inte har n�gon position lagrad.
		
			for k = 1:mz(14)
				
				for l = 1:mz(14)
				
					if (A(j,i) == A(l,k)) & (i ~= k) & (j ~= l)	%N�r de �r lika men inte n�r det �r en sj�lv.
						A(l,k) = 0;			%Tilldelar de dubbla positionerna v�rdet 0 f�r att sortera bort dubletterna.
					end
				end
			end
		end			
	end			
end






for i = 1:mz(14)

	m = 6;
	n = 0;

	if A(1,i) ~= 0				%F�r att inte f� med elementen i A som inte har n�gon position lagrad.

		fprintf(fid, '\n\n');
	end
	
	for j = 1:mz(14)
		
		if A(j,i) ~= 0					%F�r att inte f� med elementen i A som inte har n�gon position lagrad.
			
			if j == m + 6 * n
				%Skriver en radbrytning n�r 6 koordinatre har skrivits ut p� en rad.
				fprintf(fid, '\n');
				n = n + 1;
			end				
			
			
			k1 = knum2cpos(A(j,i), mminj);			%Ber�knar koordinaterna.
			%Skriver ut koordinaterna.
			fprintf(fid, '%6i%3i', k1(1), k1(2));
			
			if v == 1
				%Skriver ut identitetsnummer f�r br�nslet n�r v �r valt till 1.
				fprintf(fid, ' (%6s) ', a((A(j,i)),:));
			end
			
		
			fprintf(fid, '    ->');
		
		end


	end
	
	if A(1,i) ~= 0
		
		if j == m + 6 * n
			%Skriver en radbrytning n�r 6 koordinatre har skrivits ut p� en rad.
			fprintf(fid, '\n');
			n = n + 1;
		end				
		
		k2 = knum2cpos(A(1,i), mminj);		%Ber�knar sista koordinaten (samma som f�rsta);
		%Skriver ut sista koordinaten.
		fprintf(fid, '%6i%3i', k2(1), k2(2));
		
		if v == 1
			%Skriver ut identitetsnummer f�r br�nslet n�r v �r valt till 1.
			fprintf(fid, ' (%6s) ', a((A(1,i)),:));
		end
	end

end


















fprintf(fid, '\n\n\n\n\nBr�nslepatroner som ej flyttats');

for i = 1:mz(14)
	p1 = i;
		
	if c(i) == i					%F�r de br�nslen som inte flyttats.
		k1 = knum2cpos(i, mminj);			%Ber�knar koordinaten.
		%Skriver ut koordinaten
		fprintf(fid, '\n\n%6i%3i', k1(1), k1(2));
		
		if v == 1
			%Skriver ut identitetsnummer f�r br�nslet n�r v �r valt till 1.
			fprintf(fid, ' (%6s) ', a(i,:));
		end
	end
	
end	
















fprintf(fid, '\n\n\n\n\nBr�nslepatroner som ersatts av en ny utan att ing� i en kedja.');

for i = 1:mz(14)
	p1 = i;

	if (c(i) == 0) & (d(i) == 0)			%V�ljer ut f�rflyttningar som slutar i ett bortaget br�nsle och b�rjar f�re ett nyinsatt br�nsle f�pr
							%samma br�nsle
		k1 = knum2cpos(i, mminj);			%Ber�knar koordinaten.
		%Skriver ut koordinaten
		fprintf(fid, '\n\n%6i%3i', k1(1), k1(2));
		
		if v == 1
			%Skriver ut identitetsnummer f�r br�nslet n�r v �r valt till 1.
			fprintf(fid, ' (%6s) ', a(i,:));
		end
	end		
end
		









fprintf(1, 'Kedjorna finns utskrivna i %s', utfil);
fprintf(1, '\n\n\n');

fprintf(fid, '\n\n\n');

			
fclose(fid);		%St�nger filen.


			
		




