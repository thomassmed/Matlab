%@(#)   p4_p7.m 1.2	 04/06/28     13:42:19
%
%function f = p4_p7(dist4, dist7)
function f = p4_p7(dist4, dist7)

id4right = readdist(dist4, 'buidnt');					%Läser in identiteterna för polca 4.
id4 = left_adjust(id4right);						%Vänsterställer identiteterna
[id7, mminj, konrod, bb, hy, mz] = readdist7(dist7, 'asyid');		%Läser in identiteterna för polca 7 samt mz.

typ4right = readdist(dist4, 'buntyp');					%Läser in typerna för polca 4.
typ4 = left_adjust(typ4right);						%Vänsterställer typerna
typ7 = readdist7(dist7, 'asytyp');					%Läser in typerna för polca 7.

cr4right = readdist(dist4, 'cridnt');					%Läser in styrstavsidentiteterna för polca 4.
cr4 = left_adjust(cr4right);						%Vänsterställer styrstavsidentiteterna
cr7 = readdist7(dist7, 'crid');						%Läser in styrstavsidentiteterna för polca 7.








fprintf(1, '\n\n\nJämförelse av bränsleidentiteter mellan polca 4 och 7:');

j = 0;

for i = 1:mz(14)				%Loopar igenom alla identiteter.

	if id4(i,:) ~= id7(i,:)										%Om de inte är lika skrivs de ut.
		fprintf(1, '\n%6s i p7 stämmer inte överens med %6s i p4', id7(i,:), id4(i,:));
		j = 1;
	end
end

if j ~= 1					%Om alla stämmeröverens så skrivs Allt ok.
	fprintf(1, '\n\nAllt ok');
end	








fprintf(1, '\n\n\nJämförelse av bränsletyp mellan polca 4 och 7:');

j = 0;

for i = 1:mz(14)				%Loopar igenom alla typerna.

	if typ4(i,:) ~= typ7(i,:)									%Om de inte är lika skrivs de ut.
		fprintf(1, '\n%6s i p7 stämmer inte överens med %6s i p4', typ7(i,:), typ4(i,:));
		j = 1;
	end
end

if j ~= 1					%Om alla stämmeröverens så skrivs Allt ok.
	fprintf(1, '\n\nAllt ok');
end







fprintf(1, '\n\n\nJämförelse av styrstavsidentiterter mellan polca 4 och 7:');

j = 0;

for i = 1:mz(69)				%Loopar igenom alla styrstavsidentiteter.

	if cr4(i,:) ~= cr7(i,:)										%Om de inte är lika skrivs de ut.
		fprintf(1, '\n%6s i p7 stämmer inte överens med %6s i p4', cr7(i,:), cr4(i,:));
		j = 1;
	end
end

if j ~= 1					%Om alla stämmeröverens så skrivs Allt ok.
	fprintf(1, '\n\nAllt ok');
end	







fprintf(1, '\n\n');



