%@(#)   test.m 1.1	 05/07/13     10:29:42
%

function test(dist1, dist2)




a = readdist7(dist1, 'asyid');		%L�ser in de angivna filerna i a och b.
[b, mminj, konrod, bb, hy, mz] = readdist7(dist2, 'asyid');

c = mbucatch(a,b);		%L�ser in v�rden f�r respektive gammal och ny plats.
d = mbucatch(b,a);


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



A = A';

nollor = find(A(:,1)>0);
A = A(nollor,:);

langst = 1;
for i = 1:size(A,1)
	
	for j = 1:size(A,2)
	
		if A(i,j)==0 & A(i,j-1)~=0
			
			
			
			if j>langst
				langst = j;
			end
			
			A(i,j) = A(i,1);
			break
			
			
		end
	end
end

A = A(:,1:langst)
			







