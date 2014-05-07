%@(#)   writedist7.m 1.5	 10/08/10     13:26:12
%
%function err = writedist7(distfil, dist, distname);
%
%Inparametrar:
%DISTFIL: Distrubitionsfilen som ska skrivas i.
%DIST: Distrubitionen som ska skrivas, anges som en matris.
%      Om symme = 3 f�r distfil, skrivs distrubutionen om till symme 3.
%DISTNAME: Namnet p� distrubitionen, tex asyid.
function err = writedist7(distfil,dist,distname);
[a, mminj, b, c, d, mz] = readdist7(distfil);      %L�ser in mminj och mz.
fid = fopen(expand(distfil,'dat'),'r+', 'b');     %�ppnar filen f�r b.
%L�ser in hela filhuvudet.
head = fread(fid, 50, 'int32');    %L�ser in hela filhuvudet.
if head(1)~= 1        %Om det inte g�r att l�sa d� man �ppant med b
  fclose(fid);
  fid = fopen(expand(distfil,'dat'),'r+', 'l');     %�ppnar filen f�r l.
  head = fread(fid, 50, 'int32');        %L�ser in hela filhuvudet.
end
%L�ser in distnamnen som finns i filen
fseek(fid, 4*head(2)-4, -1);      %S�tter filpekaren vi head(2) d�r distnamnen b�rjar.
distlista=setstr(fread(fid,[8,head(46)]));    %L�ser in distnamnen i matrisen distlista och g�r dem till en str�ng.
distlista=flipud(rot90(distlista));      %V�nder distlista �t r�tt h�ll.
%L�ser in adresserna till de olika distrubitionerna.
fseek(fid, 4*head(3)-4, -1);          %S�tter filpekaren vid head(3) d�r distadresserna b�rjar.
adress2dist = fread(fid, 4*head(46) -head(46), 'int32');  %L�ser distadresserna s� l�ngt som det finns distrubitioner.
%L�ser in positionen i distlista f�r angivet distnamn.
pos_i_distlista = strmatch(upper(distname), distlista, 'exact');    %L�ser ut positionen f�r angivet ditnamn i distlista.
%L�ser in storleken p� distrubitionen.
pos_distsize = 4*(adress2dist(pos_i_distlista*4 - pos_i_distlista - 2) - 1) + 4*5;  %Positionen f�r distrubitionsstorleken.
fseek(fid, pos_distsize, -1);         %S�tter filpekaren vi subhed(6), dist storlek, b�rjar.
if isstr(dist(1)) == 1
  distsize = 4 * fread(fid, 1, 'int32');      %L�ser in storleken p� distrubitionen som heltal*4 ty str�ng.
else
  distsize = fread(fid, 1, 'int32');      %L�ser in storleken p� distrubitionen som heltal.
end
%L�ser in storleken p� subhead.
subhsize = fread(fid, 1, 'int32');      %L�ser in storkeken p� dist subhead (filpekaren st�r redan d�r).
%L�ser in symmetrin p� distrubitionen.
pos_symme = 4*(adress2dist(pos_i_distlista*4 - pos_i_distlista - 2) - 1) + 4*9;    %Positionen f�r symetri..
fseek(fid, pos_symme, -1);           %S�tter filpekaren vi subhead(10) d�r symme b�rjar.
symme = fread(fid, 1, 'int32');          %L�ser in symetrin f�r distrubitionen
%L�ser in reflektorer.
pos_sideref = 4*(adress2dist(pos_i_distlista*4 - pos_i_distlista - 2) - 1) + 4*11;    %Positionen f�r side reflektor.
fseek(fid, pos_sideref, -1);             %S�tter filpekaren vi subhead(11) d�r reflektor b�rjar.
sideref = fread(fid, 1, 'int32');          %L�ser in side reflektor f�r distrubitionen
bottomref = fread(fid, 1, 'int32');          %L�ser in bottom reflektor f�r distrubitionen
topref = fread(fid, 1, 'int32')  ;          %L�ser in top reflektor f�r distrubitionen

s = size(dist);    %Ber�kanr storleken p� dist.
if (s(1) ~= mz(14) & s(2) ~= mz(14))
   sideref = 0;          			%S�tter reflektor till noll om det inte �r en br�nsledistrubution.
end

%Ber�knar startposition
pos_diststart = 4*(adress2dist(pos_i_distlista*4 - pos_i_distlista - 2) - 1) + 4*subhsize;  %Positionen f�r distrubitionstart.
%Ber�kning av mminj f�r sidorefflektorer.
smminj = size(mminj);        %Ber�knar storleken p� mminj
mminjref = zeros(smminj(1) + 2, 1);    %Skapar en matris f�r mminjref
j = 1;
for i = 1:(smminj(1) + 2)      %loopar igenom matrisen.
  if i >= (smminj(1)/2)        %Skapar en mmijref
    mminjref(i) = mminj(i-2);
  else
    mminjref(i) = mminj(i);
  end
end

%Utf�rs n�r distname �r styrstavar ty sideref �r 1 men de har inte sidreflektorer.
if (strcmp(upper(distname), 'CRID')) | (strcmp(upper(distname), 'CRTYP'))
  A = dist;
  sA = size(A);
  if strcmp(upper(distname), 'CRID')
    A = [A, char(32 * ones(sA(1), 8 - sA(2)))];    %L�ggar till tomma steg s� att storleken blir 8.
    A = char(A);    %G�r A till en str�ng.
  elseif strcmp(upper(distname), 'CRTYP')
    A = [A, char(32 * ones(sA(1), 4 - sA(2)))];    %L�gger till tomma steg s� att storleken blir 4.
    A = char(A);    %G�r A till en str�ng.
  end
elseif sideref == 1        %Om dist ska ha sidreflektorer.
  
  vec = findrefl(mminjref);    %L�ser in en vektor med platser f�r sidreflektorer.
  svec = size(vec);      %Ber�knar storleken f�r vectorn med sidreflektorer.
  k = 1;
  if isstr(dist(1)) == 1      %Om dist �r en st�ng.
    
    A = ones((svec(2) + mz(14)), s(2));    %Skapar en matris med storleken av dist plus sidreflektorer.
    sA = size(A);
    for i = 1:sA(1)          %Loopar igenom den skapade matrisen.
      for j = 1:svec(2)      %Loopar igenom vektorn.
        if i == vec(j)        %Om platsen finns bland v�rderna i vektorn s� s�tts platsen till 0.
          A(i,:) = zeros(1,s(2));
          break
        end
      end
      if A(i,1) ~= 0          %Annars tilldelas A v�rdet av motsvarande dist.
        A(i,:) = dist(k,:);
        k = k + 1;
      end
    end
    if strcmp(upper(distname), 'ASYID')
      A = [A, char(32 * ones(sA(1), 8 - sA(2)))];    %L�gger till tomma steg f�r att storleken ska bli 8.
    elseif strcmp(upper(distname), 'ASYTYP')
      A = [A, char(32 * ones(sA(1), 4 - sA(2)))];    %L�gger till tomma steg f�r att storleken ska ble 4.
    end
    sA = size(A);      %Ber�knar storleken av A.
    for i = 1:sA(1)      %Loopar igenom hela matrisen.
      for j = 1:sA(2)
        if A(i,1) == 0 & A(i,j) == 32    %L�gger till nollor i i st�llet f�r tomma steg p� rader med sidoreflektorer.
          A(i,j) = 0;
        end
      end
    end
  elseif (s(1) == 1) | (s(2) == 1)      %Om dist �r en vektor.
    A = ones((svec(2) + mz(14)), 1);    %Skapar en matris med storleken av dist plus sidoreflektorer.
    sA = size(A);          %Ber�knar storleken av A.
    for i = 1:sA(1)          %Loopar igenom matrisen.
      for j = 1:svec(2)      %Loopar igen vektorn f�r sidreflektorspositioner
        if i == vec(j)      %Om platen motsvarar ett v�rde i vektorn s�ttst platsen till 0.
          A(i) = 0;
          break
        end
      end
      if A(i) ~= 0        %Annars s�tts platsen i A motsvarande v�rde f�r dist.
        A(i) = dist(k);
        k = k + 1;
      end
    end
  else              %Om dist inte �r en vektor eller str�ng.
    A = ones(s(1), (s(2) + svec(2)));
    %A = ones(s(1), (mz(14) + svec(2)));    %Skapar en matris med storleken f�r dist och sidoreflektorer.
    sA = size(A);          %Ber�knar storleken av dA
    for i = 1:sA(2)          %Loopar igenom matrisen.
      for j = 1:svec(2)      %loopar igenom vektorn f�r sidoreflektorer.
        if i == vec(j)      %Om platen motsvarar ett v�rde i vektorn s�ttst platsen till 0.
          A(:,i) = zeros(s(1),1);
          break
        end
      end
      if A(:,i) ~= zeros(s(1),1)    %Annars s�tts platsen i A motsvarande v�rde f�r dist.
        A(:,i) = dist(:,k);
        k = k + 1;
      end
    end
  end
else
  A = dist;
  sA = size(dist);
  if strcmp(upper(distname), 'ASYID')
    A = [A, char(32 * ones(sA(1), 8 - sA(2)))];    %L�gger till tomma steg f�r att storleken ska bli 8.
  end
end
sA = size(A);      %Ber�knar ny storlek av A.
dist = A;      %Tilldelar dist v�rderna av A.
if symme == 3      %Om symetrin �r halvh�rdsymetri.
  j = 1;
  if isstr(dist(1)) == 1      %Om dist �r en str�ng.
    A = zeros(sA(1)/2, sA(2));  %Skapar en matris med halva storleken av dist.
  elseif (s(1) == 1) | (s(2) == 1)  %Om dist �r en vektor.
    A = zeros(sA(1)/2, 1);    %Skapar en matris med halva storleken av dist.
  else
    A = zeros(s(1), sA(2)/2);  %Skapar en matris med halva storleken av dist.
  end
  if (strcmp(upper(distname), 'CRID')) | (strcmp(upper(distname), 'CRTYP')) | (strcmp(upper(distname), 'CREFPH')) | (strcmp(upper(distname), 'CRDEPL')) | (strcmp(upper(distname), 'CRFLUE'))    %Om dist �r styrstavar.
    for i = 1:mz(69)            %Loopar igenom antal styrstavar.
      halv = full2half(i, mminjref);        %Kanalnummrena p� v�nster halva s�tts till 0.
      if halv ~= 0            %Om det inte �r v�nster halva.
        A(j,:) = dist(i,:);        %A till delat v�rdet av dist.
        j = j + 1;
      end
    end
  else
    for i = 1:(mz(14) + svec(2))          %Loopar igenom dist.
      halv = full2half(i, mminjref);        %Kanalnummrena p� v�nster halva s�tts till 0.
      if (halv ~= 0) & isstr(dist(1)) == 1      %Om det inte �r v�nster halva och dist �r en str�ng.
        A(j,:) = dist(i,:);        %A till delat v�rdet av dist.
        j = j + 1;
      elseif (halv ~= 0) & ((s(1) == 1) | (s(2) == 1))  %Om det inte �r v�nster halva och dist �r en vektor.
        A(j) = dist(i);          %A till delat v�rdet av dist.
        j = j + 1;
      elseif halv ~= 0          %Om det inte �r v�nster halva.
        A(:,j) = dist(:,i);        %A till delat v�rdet av dist.
        j = j + 1;
      end
    end
  end
  dist = A;    %Tiiildelar dist v�rdet av A.
end
if isstr(dist(1)) == 1 | strcmp(upper(distname), 'ASYTYP')    %Om dist �r en str�ng eller asytyp (asyid upph�r att vara en str�ng).
  dist = dist';            %G�r matrisen till en kolonnvektor �t r�tth�ll.
  dist = dist(:);
elseif (s(1) ~= 1) | (s(2) ~= 1)        %Om matrisen inte �r en vektor.
  dist = dist(:);            %G�r matrisen till en kolonnvektor.
end
s = size(dist);      %Ber�knar storleken p� dist.
if  s(1) ~= distsize    %J�mf�r dist med storleken p� distrubitonen och om de inte �r lika skrivs dist inte p� filen.
  fprintf(1, '\nDatam�ngden har inte samma storlek som dens plats.\nDistrubitionen kommer inte att skrivas in i filen.');
else
  fseek(fid, pos_diststart, -1);    %St�ller filpekaren d�r distrubitionen startar.
  if isstr(dist(1)) == 1 | strcmp(upper(distname), 'ASYTYP')    %Om dist �r str�ng skrivs den som char.
    count = fwrite(fid, dist, 'char');
    
  else                %Annars skrivs den som flyttal.
    count = fwrite(fid, dist, 'float32');
    
  end
end
fclose(fid);    %St�nger filen

