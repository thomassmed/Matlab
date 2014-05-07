%@(#)   readskbfil.m 1.12         06/02/10     13:52:49
%
%function BUIDCLAB=readskbfil(infil)
function BUIDCLAB=readskbfil(infil)
% l�ser in en total inventariefil fr�n ladda

TX= readtextfile(infil);                        %L�nar fkt som l�ser in infil till matris TX
[rad, kol]=size(TX);                            %Best�mmer storlek p� TX
j=1;
for i=1:1:rad                                   %stegar igenom alla rader
  BUIDCLAB(i,1:16)=blanks(16);                  %skapar tom rad av blanksteg
  if findstr(TX(i,:), ',P,') | findstr(TX(i,:), ',K,')        %om objektet �r P alt. K
    k=find(TX(i,:)== ',');                      %Best�mmer var , �r bel�gna
    BUIDCLAB(i,18-(k(3)-k(2)):16)=TX(i,k(2)+1:k(3)-1);        %sparar PatronID i BUIDCLAB, h�gerst�llt
  end
end
