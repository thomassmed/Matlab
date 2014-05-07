%@(#)   dopbundle7.m 1.4   10/07/12     12:46:43
%
%function f = dopbundle7(bocfil, asytyp, asyid1_bokstav, asyid1_num, symme, utfil)
% 
%Inparametrar:
%BOCFIL: Bocfil med identiteter NY...
%ASYTYP: Skrivs som en kolonvektor med de nya typerna,
%        tex ['N304'; 'N204'; 'H305']
%ASYID1_BOKSTAV: Det första identitetsnummret i en serie, bara bokstäverna.
%                Skriv en tom sträng om det inte finns några bokstäver.
%                tex ['GNP'; 'GU '; '   '], (kollonvektor, lika många som antal typer).
%ASYID1_num: Det första identitetsnummret i en serie, bara siffror.
%            tex ['12   '; '123  '; '12345'], (kollonvektor, lika många som antal typer).
%SYMME: Anges som 1 eller 3, hel eller halvhärd.
%UTFIL: Filen som resultatet skrivs ut i.

function f = dopbundle7(bocfil, asytyp, asyid1_bokstav, asyid1_num, symme, utfil)

%id = readdist7(bocfil, 'asyid');			%Läser in identitetnummrena från angiven fil.
[id, mminj, konrod, bb, hy, mz, ks, typ] = readdist7(bocfil, 'asyid');		%Läser in typen och mminj.

fid = fopen(expand(utfil, 'txt'), 'w');
fprintf(1, '\n');

if (size(asytyp,1) ~= size(asyid1_bokstav,1)) | ...
      (size(asytyp,1) ~= size(asyid1_num,1)) | ...
      (size(asyid1_bokstav,1) ~= size(asyid1_num,1))
  fprintf(1, '\n\nDu måste ange lika många typer, som asyidbokstäver och nummer!\n\n\n');
  return;
end

s = size(asyid1_num);
for k = 1:s(1)
  num = remblank(asyid1_num(k,:));		%Tar bort mellanslag
  bokstav = remblank(asyid1_bokstav(k,:));	%tar bort mellanslag
  for j = 0:2:8					%Loopar jämna nummer
    if str2num(num(length(num))) == j		%Om serien börjar på ett jämn nummer.
      fprintf(1, '\n\nVarning!\nIdentitetsummer %s%s slutar på jämnsiffra.', bokstav, num);		%Skriver varningstext.
      fprintf(fid, '\n\nVarning!\nIdentitetsummer %s%s slutar på jämnsiffra.', bokstav, num);
    end
  end
end

%Utökar matrisen id så att idnummer med 8 tecken får plats.
s_id = size(id);
A = zeros(mz(14), 8);		%Skapar matris

for i = 1:mz(14)	
  A(i,1:s_id(2)) = id(i,:);	%Flyttar över idnummret
  for j = (1+s_id(2)):1:8	%Fyller ut med mellanslag
    A(i,j) = 32;
  end
end

id = setstr(A);                 %Gör om till en sträng


%Val av helhärdssymmetri.
if symme == 1	
  for k = 1:s(1)				%Loppar igenom antalet serier
    num = remblank(asyid1_num(k,:));		%Tar bort mellanslag
    bokstav = remblank(asyid1_bokstav(k,:));	%Tar bort mellanslag    
    j = 0;
    for i = 1:mz(14)
      if (id(i,1) == 'N') & (id(i,2) == 'Y') & (typ(i,:) == asytyp(k,:))	%För att hitta rätt plats
	    idnum = str2num(num) +j;						%Ändrar till nummer och plussar på en
        idstr = sprintf('%03.0f',idnum);
        id(i,1:length(bokstav)) = bokstav(:);   %Nya bokstäver
        id(i,length(bokstav)+1:length(bokstav)+length(idstr)) = idstr(:);   %Nya siffror
        id(i,length(bokstav)+length(idstr)+1:end) = ' ';    %Fyller ut med mellanslag
	
	    j = j + 1;
      end      
    end
  end	
end

%Halvhärdsymmetri
if symme == 3  
  [right, left] = knumhalf(mminj);		%Läser in halvhärds knum.
  for k = 1:s(1)				%Loopar igenom alla asytyper ocg asyid1.
    num = remblank(asyid1_num(k,:));		%Tar bort mellanslag
    bokstav = remblank(asyid1_bokstav(k,:));	%Tar bort mellanslag
    j = 0;
    
    for i = 1:(mz(14)/2)	%Loopar igenom hälften av knum.      
      knumr = right(i);		%Sparar höger och vänster knum.
      knuml = left(i);
      
      if (id(knumr,1) == 'N') & (id(knumr,2) == 'Y') & (id(knuml,1) == 'N') & (id(knuml,2) == 'Y') & (typ(knumr,:) == asytyp(k,:))		
	%Skriver ut varning om symetrikompisarna har olika typ.
	if typ(knumr,:) ~= typ(knuml,:)	
	  fprintf(1, '\n\nVarning! De symetriska typerna %6s och %6s är inte samma.', typ(knumr,:), typ(knuml,:));
	  fprintf(fid, '\n\nVarning! De symetriska typerna %6s och %6s är inte samma.', typ(knumr,:), typ(knuml,:));			
	else	  
	  %Höger halva
	  
	  idnum = str2num(num) + j;						%Ändrar till nummer och plussar på j som öker med antal gånger
      idstr = sprintf('%03.0f',idnum);
      id(knumr,1:length(bokstav)) = bokstav(:);     %Nya bokstäver
      id(knumr,length(bokstav)+1:length(bokstav)+length(idstr)) = idstr(:);     %Nya siffror
      id(knumr,length(bokstav)+length(idstr)+1:end) = ' ';      %Fyller ut med mellanslag
      
	  %Vänster halva
	  
	  idnum = str2num(num) + j + 1;						%Ändrar till nummer och plussar på j + 1
      idstr = sprintf('%03.0f',idnum);
      id(knuml,1:length(bokstav)) = bokstav(:);     %Nya bokstäver
      id(knuml,length(bokstav)+1:length(bokstav)+length(idstr)) = idstr(:);     %Nya siffror
	  id(knuml,length(bokstav)+length(idstr)+1:end) = ' ';      %Fyller ut med mellanslag
      
	  j = j + 2;		%Öker j med 2
	  
	end
      end
    end    
  end
	
  %För NY som inte har någon symmetrikompis
  for k = 1:s(1)				%Loppar igenom antalet serier
    num = remblank(asyid1_num(k,:));		%Tar bort mellanslag
    bokstav = remblank(asyid1_bokstav(k,:));	%Tar bort mellanslag
    j = 0;
    
    for i = 1:mz(14)
      if (id(i,1) == 'N') & (id(i,2) == 'Y') & (typ(i,:) == asytyp(k,:))	%För att hitta rätt plats
	
	    idnum = str2num(num) +j;						%Ändrar till nummer och plussar på en
	    idstr = sprintf('%03.0f',idnum);
        id(i,1:length(bokstav)) = bokstav(:);           %Nya bokstäver
        id(i,length(bokstav)+1:length(bokstav)+length(idstr)) = idstr(:);   %Nya siffror
        id(i,length(bokstav)+length(idstr)+1:end) = ' ';    %Fyller ut med mellanslag
	
	    j = j + 1;
      end      
    end    
  end	
end


%Härd karta
fprintf(fid, '%s\n', 'ASYID');
map=ascdist2map(id, mminj);
fprintf(fid,'%s', map);

fprintf(1, '\n\nEn ny härdkarta har skrivits i %s\n\n\n', utfil);
fprintf(fid, '\n\n\n');

fclose(fid);
