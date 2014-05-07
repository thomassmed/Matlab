%@(#)   p4_p7.m 1.2	 04/06/28     13:42:19
%
%function f = p4_p7(dist4, dist7)
function f = p4_p7(dist4, dist7)

id4right = readdist(dist4, 'buidnt');					%L�ser in identiteterna f�r polca 4.
id4 = left_adjust(id4right);						%V�nsterst�ller identiteterna
[id7, mminj, konrod, bb, hy, mz] = readdist7(dist7, 'asyid');		%L�ser in identiteterna f�r polca 7 samt mz.

typ4right = readdist(dist4, 'buntyp');					%L�ser in typerna f�r polca 4.
typ4 = left_adjust(typ4right);						%V�nsterst�ller typerna
typ7 = readdist7(dist7, 'asytyp');					%L�ser in typerna f�r polca 7.

cr4right = readdist(dist4, 'cridnt');					%L�ser in styrstavsidentiteterna f�r polca 4.
cr4 = left_adjust(cr4right);						%V�nsterst�ller styrstavsidentiteterna
cr7 = readdist7(dist7, 'crid');						%L�ser in styrstavsidentiteterna f�r polca 7.








fprintf(1, '\n\n\nJ�mf�relse av br�nsleidentiteter mellan polca 4 och 7:');

j = 0;

for i = 1:mz(14)				%Loopar igenom alla identiteter.

	if id4(i,:) ~= id7(i,:)										%Om de inte �r lika skrivs de ut.
		fprintf(1, '\n%6s i p7 st�mmer inte �verens med %6s i p4', id7(i,:), id4(i,:));
		j = 1;
	end
end

if j ~= 1					%Om alla st�mmer�verens s� skrivs Allt ok.
	fprintf(1, '\n\nAllt ok');
end	








fprintf(1, '\n\n\nJ�mf�relse av br�nsletyp mellan polca 4 och 7:');

j = 0;

for i = 1:mz(14)				%Loopar igenom alla typerna.

	if typ4(i,:) ~= typ7(i,:)									%Om de inte �r lika skrivs de ut.
		fprintf(1, '\n%6s i p7 st�mmer inte �verens med %6s i p4', typ7(i,:), typ4(i,:));
		j = 1;
	end
end

if j ~= 1					%Om alla st�mmer�verens s� skrivs Allt ok.
	fprintf(1, '\n\nAllt ok');
end







fprintf(1, '\n\n\nJ�mf�relse av styrstavsidentiterter mellan polca 4 och 7:');

j = 0;

for i = 1:mz(69)				%Loopar igenom alla styrstavsidentiteter.

	if cr4(i,:) ~= cr7(i,:)										%Om de inte �r lika skrivs de ut.
		fprintf(1, '\n%6s i p7 st�mmer inte �verens med %6s i p4', cr7(i,:), cr4(i,:));
		j = 1;
	end
end

if j ~= 1					%Om alla st�mmer�verens s� skrivs Allt ok.
	fprintf(1, '\n\nAllt ok');
end	







fprintf(1, '\n\n');



