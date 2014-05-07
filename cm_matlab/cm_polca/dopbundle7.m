%@(#)   dopbundle7.m 1.4   10/07/12     12:46:43
%
%function f = dopbundle7(bocfil, asytyp, asyid1_bokstav, asyid1_num, symme, utfil)
% 
%Inparametrar:
%BOCFIL: Bocfil med identiteter NY...
%ASYTYP: Skrivs som en kolonvektor med de nya typerna,
%        tex ['N304'; 'N204'; 'H305']
%ASYID1_BOKSTAV: Det f�rsta identitetsnummret i en serie, bara bokst�verna.
%                Skriv en tom str�ng om det inte finns n�gra bokst�ver.
%                tex ['GNP'; 'GU '; '   '], (kollonvektor, lika m�nga som antal typer).
%ASYID1_num: Det f�rsta identitetsnummret i en serie, bara siffror.
%            tex ['12   '; '123  '; '12345'], (kollonvektor, lika m�nga som antal typer).
%SYMME: Anges som 1 eller 3, hel eller halvh�rd.
%UTFIL: Filen som resultatet skrivs ut i.

function f = dopbundle7(bocfil, asytyp, asyid1_bokstav, asyid1_num, symme, utfil)

%id = readdist7(bocfil, 'asyid');			%L�ser in identitetnummrena fr�n angiven fil.
[id, mminj, konrod, bb, hy, mz, ks, typ] = readdist7(bocfil, 'asyid');		%L�ser in typen och mminj.

fid = fopen(expand(utfil, 'txt'), 'w');
fprintf(1, '\n');

if (size(asytyp,1) ~= size(asyid1_bokstav,1)) | ...
      (size(asytyp,1) ~= size(asyid1_num,1)) | ...
      (size(asyid1_bokstav,1) ~= size(asyid1_num,1))
  fprintf(1, '\n\nDu m�ste ange lika m�nga typer, som asyidbokst�ver och nummer!\n\n\n');
  return;
end

s = size(asyid1_num);
for k = 1:s(1)
  num = remblank(asyid1_num(k,:));		%Tar bort mellanslag
  bokstav = remblank(asyid1_bokstav(k,:));	%tar bort mellanslag
  for j = 0:2:8					%Loopar j�mna nummer
    if str2num(num(length(num))) == j		%Om serien b�rjar p� ett j�mn nummer.
      fprintf(1, '\n\nVarning!\nIdentitetsummer %s%s slutar p� j�mnsiffra.', bokstav, num);		%Skriver varningstext.
      fprintf(fid, '\n\nVarning!\nIdentitetsummer %s%s slutar p� j�mnsiffra.', bokstav, num);
    end
  end
end

%Ut�kar matrisen id s� att idnummer med 8 tecken f�r plats.
s_id = size(id);
A = zeros(mz(14), 8);		%Skapar matris

for i = 1:mz(14)	
  A(i,1:s_id(2)) = id(i,:);	%Flyttar �ver idnummret
  for j = (1+s_id(2)):1:8	%Fyller ut med mellanslag
    A(i,j) = 32;
  end
end

id = setstr(A);                 %G�r om till en str�ng


%Val av helh�rdssymmetri.
if symme == 1	
  for k = 1:s(1)				%Loppar igenom antalet serier
    num = remblank(asyid1_num(k,:));		%Tar bort mellanslag
    bokstav = remblank(asyid1_bokstav(k,:));	%Tar bort mellanslag    
    j = 0;
    for i = 1:mz(14)
      if (id(i,1) == 'N') & (id(i,2) == 'Y') & (typ(i,:) == asytyp(k,:))	%F�r att hitta r�tt plats
	    idnum = str2num(num) +j;						%�ndrar till nummer och plussar p� en
        idstr = sprintf('%03.0f',idnum);
        id(i,1:length(bokstav)) = bokstav(:);   %Nya bokst�ver
        id(i,length(bokstav)+1:length(bokstav)+length(idstr)) = idstr(:);   %Nya siffror
        id(i,length(bokstav)+length(idstr)+1:end) = ' ';    %Fyller ut med mellanslag
	
	    j = j + 1;
      end      
    end
  end	
end

%Halvh�rdsymmetri
if symme == 3  
  [right, left] = knumhalf(mminj);		%L�ser in halvh�rds knum.
  for k = 1:s(1)				%Loopar igenom alla asytyper ocg asyid1.
    num = remblank(asyid1_num(k,:));		%Tar bort mellanslag
    bokstav = remblank(asyid1_bokstav(k,:));	%Tar bort mellanslag
    j = 0;
    
    for i = 1:(mz(14)/2)	%Loopar igenom h�lften av knum.      
      knumr = right(i);		%Sparar h�ger och v�nster knum.
      knuml = left(i);
      
      if (id(knumr,1) == 'N') & (id(knumr,2) == 'Y') & (id(knuml,1) == 'N') & (id(knuml,2) == 'Y') & (typ(knumr,:) == asytyp(k,:))		
	%Skriver ut varning om symetrikompisarna har olika typ.
	if typ(knumr,:) ~= typ(knuml,:)	
	  fprintf(1, '\n\nVarning! De symetriska typerna %6s och %6s �r inte samma.', typ(knumr,:), typ(knuml,:));
	  fprintf(fid, '\n\nVarning! De symetriska typerna %6s och %6s �r inte samma.', typ(knumr,:), typ(knuml,:));			
	else	  
	  %H�ger halva
	  
	  idnum = str2num(num) + j;						%�ndrar till nummer och plussar p� j som �ker med antal g�nger
      idstr = sprintf('%03.0f',idnum);
      id(knumr,1:length(bokstav)) = bokstav(:);     %Nya bokst�ver
      id(knumr,length(bokstav)+1:length(bokstav)+length(idstr)) = idstr(:);     %Nya siffror
      id(knumr,length(bokstav)+length(idstr)+1:end) = ' ';      %Fyller ut med mellanslag
      
	  %V�nster halva
	  
	  idnum = str2num(num) + j + 1;						%�ndrar till nummer och plussar p� j + 1
      idstr = sprintf('%03.0f',idnum);
      id(knuml,1:length(bokstav)) = bokstav(:);     %Nya bokst�ver
      id(knuml,length(bokstav)+1:length(bokstav)+length(idstr)) = idstr(:);     %Nya siffror
	  id(knuml,length(bokstav)+length(idstr)+1:end) = ' ';      %Fyller ut med mellanslag
      
	  j = j + 2;		%�ker j med 2
	  
	end
      end
    end    
  end
	
  %F�r NY som inte har n�gon symmetrikompis
  for k = 1:s(1)				%Loppar igenom antalet serier
    num = remblank(asyid1_num(k,:));		%Tar bort mellanslag
    bokstav = remblank(asyid1_bokstav(k,:));	%Tar bort mellanslag
    j = 0;
    
    for i = 1:mz(14)
      if (id(i,1) == 'N') & (id(i,2) == 'Y') & (typ(i,:) == asytyp(k,:))	%F�r att hitta r�tt plats
	
	    idnum = str2num(num) +j;						%�ndrar till nummer och plussar p� en
	    idstr = sprintf('%03.0f',idnum);
        id(i,1:length(bokstav)) = bokstav(:);           %Nya bokst�ver
        id(i,length(bokstav)+1:length(bokstav)+length(idstr)) = idstr(:);   %Nya siffror
        id(i,length(bokstav)+length(idstr)+1:end) = ' ';    %Fyller ut med mellanslag
	
	    j = j + 1;
      end      
    end    
  end	
end


%H�rd karta
fprintf(fid, '%s\n', 'ASYID');
map=ascdist2map(id, mminj);
fprintf(fid,'%s', map);

fprintf(1, '\n\nEn ny h�rdkarta har skrivits i %s\n\n\n', utfil);
fprintf(fid, '\n\n\n');

fclose(fid);
