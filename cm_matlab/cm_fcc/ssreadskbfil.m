%@(#)   ssreadskbfil.m 1.1	 06/03/22     09:18:44
%
%function BUIDCLAB=ssreadskbfil(infil)
function BUIDCLAB=ssreadskbfil(infil)
% l�ser in en total inventariefil fr�n ladda

TX= readtextfile(infil);			%L�nar fkt som l�ser in infil till matris TX
[rad, kol]=size(TX);				%Best�mmer storlek p� TX
j=1;
for i=1:1:rad						%stegar igenom alla rader
	BUIDCLAB(i,1:16)=blanks(16);		%skapar tom rad av blanksteg
	if findstr(TX(i,:), ',S,')	%om objektet �r S
		k=find(TX(i,:)== ',');		%Best�mmer var , �r bel�gna
		BUIDCLAB(i,18-(k(3)-k(2)):16)=TX(i,k(2)+1:k(3)-1);	%sparar PatronID i BUIDCLAB, h�gerst�llt
	end
end
