%@(#)   tidschema.m 1.1	 05/07/13     10:29:43
%
%
%function f = tidschema(eocfil, laddfiler)
%
%Inparametrar:
%EOCFIL: tex eoc23.dat
%LADDFILER: Komma-separerad lista med asm-filer från ladda
%           (OBS block läses från titelraden i filen,
%            måste innehålla LADDAFX osv)
%           Kan också utryckas som t.ex. *.asm för att få med
%           alla filer i aktuell katalog som har filändelsen .asm
%
%UTFILER: Laddtider.txt - sammanfattning av alla laddscheman
%         "laddschemafil"_laddtid.txt laddtid för laddschemat
%
%Tiderna i programmet är hårdkodade
%Om nya tider ska används måste de ändras.
%Tiderna är kodade på rad 190 och framåt.
%(t står för tom körning)
function f = tidrev(eocfil,varargin)
if isempty(eocfil) | isempty(varargin)
	error('Incorrect number of input arguments');
end
if ~isempty(cell2mat(strfind(varargin,'*')))
	d = dir(char(varargin));
	ladfil=char(d.name);
else
	ladfil = char(varargin);
end
utfil=[];
for i=1:size(ladfil)
	utfil = strvcat(utfil,strcat(strtok(strtrim(ladfil(i,:)),'.'),'_laddtid.txt'));
end
asyideoc = readdist7(eocfil, 'ASYID');
fprintf(1, '\n\n\n\n\n\n\n');
storlek = size(ladfil);
x = 1;
tot = zeros(0,1);
bokstaver = zeros(0,1);
for q = 1:storlek(1)
  fprintf(1, '\n\n\n\n\n\n\n');
  fid = fopen(strtrim(ladfil(q,:)));
i = 0;
%Läs block nr ur laddschemats första rad
[slask,block] = strtok(fgetl(fid),'F');
%Loopar igenom hela ladfil(q,:)en.
while 1
  read = fgetl(fid);      %Läser i ladfil(q,:)en.
  sread = size(read);      %Beräknar storleken av den lästa informationen.
  if ~ischar(read)        %Stoppar när filen är slutläst.
    break
  elseif sread(2) < 16
    i = i + 1;
  end
end
fclose(fid);
fid = fopen(strtrim(ladfil(q,:)));
asyidlista = zeros(i, 6);
poslista = zeros(i, 5);
i = 1;
%Loopar igenom hela ladfil(q,:)en.
while 1
  read = fgetl(fid);      %Läser i ladfil(q,:)en.
  sread = size(read);      %Beräknar storleken av den lästa informationen.
  if ~ischar(read)        %Stoppar när filen är slutläst.
    break
  elseif sread(2) < 16
    for j = 3:sread(2)
      if j == 3
        for k = 3:8
          if strcmp(read(k), ',') == 0
            asyidlista(i,(k-2)) = read(k);
          end
        end
      elseif (strcmp(read(j - 1), ',') == 1) & (strcmp(read(j - 2), ',') == 1)
        m = 1;
        for k = j:sread(2)
          poslista(i, m) = read(k);
          m = m + 1;
        end
      end
    end
    i = i + 1;
  end
end
asyidlista = setstr(asyidlista);
poslista = setstr(poslista);
fclose(fid);
sasyidlista = size(asyidlista);
tid = zeros(sasyidlista(1), 1);
if q == 1
  urladd = zeros(0,6);
end
%Tiderna för förflyttningarna.
if strcmp(block,'F1') | strcmp(block,'F2')
	R_R = 6.2;
	R_B = 8.5;
	B_R = 8.5;
	Rt_B = 2.5;
	B_Rt = 2.5;
	R_IN = 15;
	IN_B = 5;
	IN_R = 5;
elseif strcmp(block,'F3')
	% Ta bort denna varning när rätt tider för F3 är inlagda
	warning('F3 tider ej korrekta');
	R_R = 6.2;
	R_B = 8.5;
	B_R = 8.5;
	Rt_B = 2.5;
	B_Rt = 2.5;
	R_IN = 15;
	IN_B = 5;
	IN_R = 5;
end
for i = 1:sasyidlista
  B_R_flytt = 0;
  %För att kunna se om det är en ny bränslepatron som ska in
  if abs(asyidlista(i,6)) == 0
    asyid_prel = asyidlista(i,1:5);
    ny = strmatch(asyid_prel, asyideoc);
  else
    ny = strmatch(asyidlista(i,:), asyideoc);
  end
  %För att man inte kan titta på före den första.
  %Olika bränlseförflyttningar
  %Om bränslet är nytt (kommer från bassäng) till reaktor
  if (size(ny,1) == 0) & (size(ny,2) == 1) & abs(poslista(i,5)) == 0
    if (i-1) == 0          %Om den är första på laddshemat
      tid(i) = B_R;
      x = x + 1;
    elseif (abs(poslista((i-1),5)) ~= 0)      %Om maskinen redan är i bassängen
      tid(i) = B_R;
      x = x + 1;
    elseif abs(poslista((i-1),5)) == 0      %Om den är i reaktorn så ska den tillbaks också
      tid(i) = Rt_B + B_R;
      x = x + 1;
    end
  %Om bränslet ska till reaktorn
  elseif abs(poslista(i,5)) == 0
    for j = 1:size(urladd,1)
      if asyidlista(i,:) == urladd(j,:)
        B_R_flytt = 1;
        if (i-1) == 0
          tid(i) = B_R;
          x = x + 1;
        elseif abs(poslista((i-1),5)) ~= 0
          tid(i) = B_R;
          x = x + 1;
        elseif abs(poslista((i-1),5)) == 0
          tid(i) = Rt_B + B_R;
          x = x + 1;
        end
      end
    end
    if B_R_flytt == 0
      if (i-1) == 0
        tid(i) = R_R;
        x = x + 1;
      elseif strmatch(poslista((i-1),:), 'INSPE') == 1
        tid(i) = IN_R;
        x = x + 1;
      elseif abs(poslista((i-1),5)) == 0
        tid(i) = R_R;
        x = x + 1;
      elseif abs(poslista((i-1),5)) ~= 0
        tid(i) = B_Rt + R_R;
        x = x + 1;
      end
    end
  %Om bränslet ska till INSPE
  elseif strmatch(poslista(i,:), 'INSPE') == 1
    if (i - 1) == 0
      tid(i) = R_IN;
      x = x + 1;
    elseif abs(poslista((i-1),5)) == 0
      tid(i) = R_IN;
      x = x + 1;
    elseif abs(poslista((i-1),5)) ~= 0
      tid(i) = B_Rt + R_IN;
      x = x + 1;
    end
  %Om bränslet ska till bassäng
  elseif abs(poslista(i,5)) ~= 0
    urladd((size(urladd,1) + 1), :) = asyidlista(i,:);
    urladd = setstr(urladd);
    if (i-1) == 0
      tid(i) = R_B;
      x = x + 1;
    elseif strmatch(poslista((i-1),:), 'INSPE') == 1
      tid(i) = IN_B;
      x = x + 1;
    elseif abs(poslista((i-1),5)) == 0
      tid(i) = R_B;
      x = x + 1;
    elseif abs(poslista((i-1),5)) ~= 0
      tid(i) = B_Rt + R_B;
      x = x + 1;
    end
  end
end
fil = fopen(expand(strtrim(utfil(q,:)), 'txt'), 'w');
fprintf(1, '\nTidsutskrift för laddschema %s\n\n', strtok(strtrim(ladfil(q,:)),'.'));
fprintf(fil, '\nTidsutskrift för laddschema %s\n\n', strtok(strtrim(ladfil(q,:)),'.'));
fprintf(1, '\nAntagna tider för olika förflyttningar:');
fprintf(fil, '\nAntagna tider för olika förflyttningar:');
fprintf(1, '\n\nReaktor -> reaktor:\t\t%1.1f  min', R_R);
fprintf(fil, '\n\nReaktor -> reaktor:\t\t%1.1f  min', R_R);
fprintf(1, '\nReaktor -> bassäng:\t\t%1.1f  min', R_B);
fprintf(fil, '\nReaktor -> bassäng:\t\t%1.1f  min', R_B);
fprintf(1, '\nBassäng -> reaktor:\t\t%1.1f  min', B_R);
fprintf(fil, '\nBassäng -> reaktor:\t\t%1.1f  min', B_R);
fprintf(1, '\nReaktor(tom) -> bassäng:\t%1.1f  min', Rt_B);
fprintf(fil, '\nReaktor(tom) -> bassäng:\t%1.1f  min', Rt_B);
fprintf(1, '\nBassäng(tom) -> reaktor:\t%1.1f  min', B_Rt);
fprintf(fil, '\nBassäng(tom) -> reaktor:\t%1.1f  min', B_Rt);
fprintf(1, '\nReaktor -> INSPE:\t\t%1i   min', R_IN);
fprintf(fil, '\nReaktor -> INSPE:\t\t%1i   min', R_IN);
fprintf(1, '\nINSPE -> reaktor:\t\t%1i    min', IN_R);
fprintf(fil, '\nINSPE -> reaktor:\t\t%1i    min', IN_R);
fprintf(1, '\nINSPE -> bassäng:\t\t%1i    min', IN_B);
fprintf(fil, '\nINSPE -> bassäng:\t\t%1i    min', IN_B);
%Summering av tiderna
fprintf(1, '\n\n\n\n\n\nTider för förflyttningar från start på laddschema:\n');
fprintf(fil, '\n\n\n\n\n\nTider för förflyttningar från start på laddschema:\n');
stid = size(tid);
for i = 20:20:stid
  tiden = sum(tid(1:i));
  tim = tiden/60;
  tim = floor(tim);
  min = rem(tiden,60);
  fprintf(1, '\n\nFörflytting %1i: %6s\t\tTid: %1.0f h %1.1f min', i, asyidlista(i,:), tim, min);
  fprintf(fil, '\n\nFörflytting %1i: %6s\t\tTid: %1.0f h %1.1f min', i, asyidlista(i,:), tim, min);
end
totalt = sum(tid);
tot(q,1) = totalt;
tim = totalt/60;
tim = floor(tim);
min = rem(totalt,60);
fprintf(1, '\n\n\nTotala tiden för hela laddschemat: %1.0f h %1.1f min', tim, min);
fprintf(fil, '\n\n\nTotala tiden för hela laddschemat: %1.0f h %1.1f min', tim, min);
fclose(fil);
end
fil = fopen(expand(['Laddtider-' block], 'txt'), 'w');
fprintf(1, '\n\n\n\n\n\n\n\n');
fprintf(1, '\nTotala tider för laddscheman:');
fprintf(fil, '\nTotala tider för laddscheman:');
for i = 1:storlek(1)
  tim = tot(i)/60;
  tim = floor(tim);
  min = rem(tot(i),60);
  fprintf(1, '\n\nLaddschema %s:  %1.0f h %1.1f min', strtok(strtrim(ladfil(i,:)),'.'), tim, min);
  fprintf(fil, '\n\nLaddschema %s:  %1.0f h %1.1f min', strtok(strtrim(ladfil(i,:)),'.'), tim, min);
end
summa = sum(tot);
tim = summa/60;
tim = floor(tim);
min = rem(summa,60) + 5;
fprintf(1, '\n\n\n\nTotala tiden för alla förflyttningar:');
fprintf(fil, '\n\n\n\nTotala tiden för alla förflyttningar:');
fprintf(1, '\n\n%1.0f h %1.1f min', tim, min);
fprintf(fil, '\n\n%1.0f h %1.1f min', tim, min);
fclose(fil);
fprintf(1, '\n\n\n\n\n\n\n\n');
fprintf(1, 'Tiderna har också skrivits i filerna:');
for i = 1:size(utfil,1)
  fprintf(1, '\n%s', strtrim(utfil(i,:)));
end
fprintf(1, '\n\n\n');
