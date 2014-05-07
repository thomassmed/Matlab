%@(#)   writedist7.m 1.5	 10/08/10     13:26:12
%
%function err = writedist7(distfil, dist, distname);
%
%Inparametrar:
%DISTFIL: Distrubitionsfilen som ska skrivas i.
%DIST: Distrubitionen som ska skrivas, anges som en matris.
%      Om symme = 3 för distfil, skrivs distrubutionen om till symme 3.
%DISTNAME: Namnet på distrubitionen, tex asyid.
function err = writedist7(distfil,dist,distname);
[a, mminj, b, c, d, mz] = readdist7(distfil);      %Läser in mminj och mz.
fid = fopen(expand(distfil,'dat'),'r+', 'b');     %Öppnar filen för b.
%Läser in hela filhuvudet.
head = fread(fid, 50, 'int32');    %Läser in hela filhuvudet.
if head(1)~= 1        %Om det inte går att läsa då man öppant med b
  fclose(fid);
  fid = fopen(expand(distfil,'dat'),'r+', 'l');     %Öppnar filen för l.
  head = fread(fid, 50, 'int32');        %Läser in hela filhuvudet.
end
%Läser in distnamnen som finns i filen
fseek(fid, 4*head(2)-4, -1);      %Sätter filpekaren vi head(2) där distnamnen börjar.
distlista=setstr(fread(fid,[8,head(46)]));    %Läser in distnamnen i matrisen distlista och gör dem till en sträng.
distlista=flipud(rot90(distlista));      %Vänder distlista åt rätt håll.
%Läser in adresserna till de olika distrubitionerna.
fseek(fid, 4*head(3)-4, -1);          %Sätter filpekaren vid head(3) där distadresserna börjar.
adress2dist = fread(fid, 4*head(46) -head(46), 'int32');  %Läser distadresserna så långt som det finns distrubitioner.
%Läser in positionen i distlista för angivet distnamn.
pos_i_distlista = strmatch(upper(distname), distlista, 'exact');    %Läser ut positionen för angivet ditnamn i distlista.
%Läser in storleken på distrubitionen.
pos_distsize = 4*(adress2dist(pos_i_distlista*4 - pos_i_distlista - 2) - 1) + 4*5;  %Positionen för distrubitionsstorleken.
fseek(fid, pos_distsize, -1);         %Sätter filpekaren vi subhed(6), dist storlek, börjar.
if isstr(dist(1)) == 1
  distsize = 4 * fread(fid, 1, 'int32');      %Läser in storleken på distrubitionen som heltal*4 ty sträng.
else
  distsize = fread(fid, 1, 'int32');      %Läser in storleken på distrubitionen som heltal.
end
%Läser in storleken på subhead.
subhsize = fread(fid, 1, 'int32');      %Läser in storkeken på dist subhead (filpekaren står redan där).
%Läser in symmetrin på distrubitionen.
pos_symme = 4*(adress2dist(pos_i_distlista*4 - pos_i_distlista - 2) - 1) + 4*9;    %Positionen för symetri..
fseek(fid, pos_symme, -1);           %Sätter filpekaren vi subhead(10) där symme börjar.
symme = fread(fid, 1, 'int32');          %Läser in symetrin för distrubitionen
%Läser in reflektorer.
pos_sideref = 4*(adress2dist(pos_i_distlista*4 - pos_i_distlista - 2) - 1) + 4*11;    %Positionen för side reflektor.
fseek(fid, pos_sideref, -1);             %Sätter filpekaren vi subhead(11) där reflektor börjar.
sideref = fread(fid, 1, 'int32');          %Läser in side reflektor för distrubitionen
bottomref = fread(fid, 1, 'int32');          %Läser in bottom reflektor för distrubitionen
topref = fread(fid, 1, 'int32')  ;          %Läser in top reflektor för distrubitionen

s = size(dist);    %Beräkanr storleken på dist.
if (s(1) ~= mz(14) & s(2) ~= mz(14))
   sideref = 0;          			%Sätter reflektor till noll om det inte är en bränsledistrubution.
end

%Beräknar startposition
pos_diststart = 4*(adress2dist(pos_i_distlista*4 - pos_i_distlista - 2) - 1) + 4*subhsize;  %Positionen för distrubitionstart.
%Beräkning av mminj för sidorefflektorer.
smminj = size(mminj);        %Beräknar storleken på mminj
mminjref = zeros(smminj(1) + 2, 1);    %Skapar en matris för mminjref
j = 1;
for i = 1:(smminj(1) + 2)      %loopar igenom matrisen.
  if i >= (smminj(1)/2)        %Skapar en mmijref
    mminjref(i) = mminj(i-2);
  else
    mminjref(i) = mminj(i);
  end
end

%Utförs när distname är styrstavar ty sideref är 1 men de har inte sidreflektorer.
if (strcmp(upper(distname), 'CRID')) | (strcmp(upper(distname), 'CRTYP'))
  A = dist;
  sA = size(A);
  if strcmp(upper(distname), 'CRID')
    A = [A, char(32 * ones(sA(1), 8 - sA(2)))];    %Läggar till tomma steg så att storleken blir 8.
    A = char(A);    %Gör A till en sträng.
  elseif strcmp(upper(distname), 'CRTYP')
    A = [A, char(32 * ones(sA(1), 4 - sA(2)))];    %Lägger till tomma steg så att storleken blir 4.
    A = char(A);    %Gör A till en sträng.
  end
elseif sideref == 1        %Om dist ska ha sidreflektorer.
  
  vec = findrefl(mminjref);    %Läser in en vektor med platser för sidreflektorer.
  svec = size(vec);      %Beräknar storleken för vectorn med sidreflektorer.
  k = 1;
  if isstr(dist(1)) == 1      %Om dist är en stäng.
    
    A = ones((svec(2) + mz(14)), s(2));    %Skapar en matris med storleken av dist plus sidreflektorer.
    sA = size(A);
    for i = 1:sA(1)          %Loopar igenom den skapade matrisen.
      for j = 1:svec(2)      %Loopar igenom vektorn.
        if i == vec(j)        %Om platsen finns bland värderna i vektorn så sätts platsen till 0.
          A(i,:) = zeros(1,s(2));
          break
        end
      end
      if A(i,1) ~= 0          %Annars tilldelas A värdet av motsvarande dist.
        A(i,:) = dist(k,:);
        k = k + 1;
      end
    end
    if strcmp(upper(distname), 'ASYID')
      A = [A, char(32 * ones(sA(1), 8 - sA(2)))];    %Lägger till tomma steg för att storleken ska bli 8.
    elseif strcmp(upper(distname), 'ASYTYP')
      A = [A, char(32 * ones(sA(1), 4 - sA(2)))];    %Lägger till tomma steg för att storleken ska ble 4.
    end
    sA = size(A);      %Beräknar storleken av A.
    for i = 1:sA(1)      %Loopar igenom hela matrisen.
      for j = 1:sA(2)
        if A(i,1) == 0 & A(i,j) == 32    %Lägger till nollor i i stället för tomma steg på rader med sidoreflektorer.
          A(i,j) = 0;
        end
      end
    end
  elseif (s(1) == 1) | (s(2) == 1)      %Om dist är en vektor.
    A = ones((svec(2) + mz(14)), 1);    %Skapar en matris med storleken av dist plus sidoreflektorer.
    sA = size(A);          %Beräknar storleken av A.
    for i = 1:sA(1)          %Loopar igenom matrisen.
      for j = 1:svec(2)      %Loopar igen vektorn för sidreflektorspositioner
        if i == vec(j)      %Om platen motsvarar ett värde i vektorn sättst platsen till 0.
          A(i) = 0;
          break
        end
      end
      if A(i) ~= 0        %Annars sätts platsen i A motsvarande värde för dist.
        A(i) = dist(k);
        k = k + 1;
      end
    end
  else              %Om dist inte är en vektor eller sträng.
    A = ones(s(1), (s(2) + svec(2)));
    %A = ones(s(1), (mz(14) + svec(2)));    %Skapar en matris med storleken för dist och sidoreflektorer.
    sA = size(A);          %Beräknar storleken av dA
    for i = 1:sA(2)          %Loopar igenom matrisen.
      for j = 1:svec(2)      %loopar igenom vektorn för sidoreflektorer.
        if i == vec(j)      %Om platen motsvarar ett värde i vektorn sättst platsen till 0.
          A(:,i) = zeros(s(1),1);
          break
        end
      end
      if A(:,i) ~= zeros(s(1),1)    %Annars sätts platsen i A motsvarande värde för dist.
        A(:,i) = dist(:,k);
        k = k + 1;
      end
    end
  end
else
  A = dist;
  sA = size(dist);
  if strcmp(upper(distname), 'ASYID')
    A = [A, char(32 * ones(sA(1), 8 - sA(2)))];    %Lägger till tomma steg för att storleken ska bli 8.
  end
end
sA = size(A);      %Beräknar ny storlek av A.
dist = A;      %Tilldelar dist värderna av A.
if symme == 3      %Om symetrin är halvhärdsymetri.
  j = 1;
  if isstr(dist(1)) == 1      %Om dist är en sträng.
    A = zeros(sA(1)/2, sA(2));  %Skapar en matris med halva storleken av dist.
  elseif (s(1) == 1) | (s(2) == 1)  %Om dist är en vektor.
    A = zeros(sA(1)/2, 1);    %Skapar en matris med halva storleken av dist.
  else
    A = zeros(s(1), sA(2)/2);  %Skapar en matris med halva storleken av dist.
  end
  if (strcmp(upper(distname), 'CRID')) | (strcmp(upper(distname), 'CRTYP')) | (strcmp(upper(distname), 'CREFPH')) | (strcmp(upper(distname), 'CRDEPL')) | (strcmp(upper(distname), 'CRFLUE'))    %Om dist är styrstavar.
    for i = 1:mz(69)            %Loopar igenom antal styrstavar.
      halv = full2half(i, mminjref);        %Kanalnummrena på vänster halva sätts till 0.
      if halv ~= 0            %Om det inte är vänster halva.
        A(j,:) = dist(i,:);        %A till delat värdet av dist.
        j = j + 1;
      end
    end
  else
    for i = 1:(mz(14) + svec(2))          %Loopar igenom dist.
      halv = full2half(i, mminjref);        %Kanalnummrena på vänster halva sätts till 0.
      if (halv ~= 0) & isstr(dist(1)) == 1      %Om det inte är vänster halva och dist är en sträng.
        A(j,:) = dist(i,:);        %A till delat värdet av dist.
        j = j + 1;
      elseif (halv ~= 0) & ((s(1) == 1) | (s(2) == 1))  %Om det inte är vänster halva och dist är en vektor.
        A(j) = dist(i);          %A till delat värdet av dist.
        j = j + 1;
      elseif halv ~= 0          %Om det inte är vänster halva.
        A(:,j) = dist(:,i);        %A till delat värdet av dist.
        j = j + 1;
      end
    end
  end
  dist = A;    %Tiiildelar dist värdet av A.
end
if isstr(dist(1)) == 1 | strcmp(upper(distname), 'ASYTYP')    %Om dist är en sträng eller asytyp (asyid upphör att vara en sträng).
  dist = dist';            %Gör matrisen till en kolonnvektor åt rätthåll.
  dist = dist(:);
elseif (s(1) ~= 1) | (s(2) ~= 1)        %Om matrisen inte är en vektor.
  dist = dist(:);            %Gör matrisen till en kolonnvektor.
end
s = size(dist);      %Beräknar storleken på dist.
if  s(1) ~= distsize    %Jämför dist med storleken på distrubitonen och om de inte är lika skrivs dist inte på filen.
  fprintf(1, '\nDatamängden har inte samma storlek som dens plats.\nDistrubitionen kommer inte att skrivas in i filen.');
else
  fseek(fid, pos_diststart, -1);    %Ställer filpekaren där distrubitionen startar.
  if isstr(dist(1)) == 1 | strcmp(upper(distname), 'ASYTYP')    %Om dist är sträng skrivs den som char.
    count = fwrite(fid, dist, 'char');
    
  else                %Annars skrivs den som flyttal.
    count = fwrite(fid, dist, 'float32');
    
  end
end
fclose(fid);    %Stänger filen

