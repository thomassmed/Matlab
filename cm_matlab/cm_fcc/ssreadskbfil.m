%@(#)   ssreadskbfil.m 1.1	 06/03/22     09:18:44
%
%function BUIDCLAB=ssreadskbfil(infil)
function BUIDCLAB=ssreadskbfil(infil)
% läser in en total inventariefil från ladda

TX= readtextfile(infil);			%Lånar fkt som läser in infil till matris TX
[rad, kol]=size(TX);				%Bestämmer storlek på TX
j=1;
for i=1:1:rad						%stegar igenom alla rader
	BUIDCLAB(i,1:16)=blanks(16);		%skapar tom rad av blanksteg
	if findstr(TX(i,:), ',S,')	%om objektet är S
		k=find(TX(i,:)== ',');		%Bestämmer var , är belägna
		BUIDCLAB(i,18-(k(3)-k(2)):16)=TX(i,k(2)+1:k(3)-1);	%sparar PatronID i BUIDCLAB, högerställt
	end
end
