%@(#)   laddsdm.m 1.5	 10/05/05     13:19:19
%
%function f = laddsdm(laddfil, eocfil, bocfil, min, kref, crit, utfil_tot, utfil_crit, utfil_vatten, title)
%
%Inparametrar:
%LADDFIL: En fil med alla laddscheman enskillt eller sammanslagna.
%EOCFIL: Eocfilen f�r aktuell cykel, OBS Symme = 1!
%BOCFIL: Bocfilen f�r n�stkommande cykel.
%MIN: Den gr�ns p� khot som ska ber�knas �ver.
%KREF: V�rdet p� kref
%CRIT: Kritiskt v�rde p� sdm
%UTFIL_TOT: Resultatfil (alla avst�ngninsmarginaler)
%UTFIL_CRIT: Alla kritsika avst�ngningsmarginaler
%UTFIL_VATTEN: Visualiserar antal vattenh�l kring aktuell patron
%TITLE: Valbart
%
%Eoc-filen som uppdateras �r en kopia av den eocfil som �r inparameter.
%Kopian f�r namnet eoc-upd.dat.
%Alla filer som skapas hamnar i den lokala katalogen.

function f = laddsdm(ladfil, eocfil, bocfil, min, kref, crit, utfil1, utfil2, utfil3, title)

[d,mminj,konrod,bb,hy,mz]=readdist7(eocfil);
if mz(2)~=1,error('Only full core symmetry allowed in %s. Present symmetry: %d',eocfil,mz(2));end
v=src2mlab('source.txt','ACCPAR');
vv=v.ACCPAR;
cp=sscanf(vv,'%f');
if cp ~= 1, error('Cp-factor MUST be 1.0 in cold calculations, see input card ACCPAR.');end
str=['!cp ' eocfil ' eoc-upd.dat'];
eval(str)

eocfil = 'eoc-upd.dat';

fprintf(1, '\n\n\n');
fid = fopen(ladfil);              %�ppnar filen med ladsheman.
[khot, mminj, konrod, bb, hy, mz, ks, asytyp, asyref, distlist, staton] = readdist7(bocfil, 'khot');        %L�ser in khot och mminj.
asyid = readdist7(bocfil, 'asyid');
crmminj = mminj2crmminj(mminj);            %Ber�knar styrstavsmminj.
scrmminj = size(crmminj);            %Ber�knar storleken p� crmminj.
styrstav = [];                       %�ndrat fr�n zeros(0,9)
g = 1;
n = 1;
fp3 = fopen(expand(utfil3, 'txt'), 'w');
fp = fopen(expand(utfil1, 'txt'), 'w');
fp2 = fopen(expand(utfil2, 'txt'), 'w');
fprintf(fp, '\n************************ LADDSDM report ************************\n\n\n');

index = 1;
radnum = 1;
opnum = 1;
polcanum = 0;

%Loopar igenom hela ladfilen.
while 1
  vec = fgetl(fid);      %L�ser i ladfilen.
  svec = length(vec);      %Ber�knar storleken av den l�sta informationen.
  if vec ~= -1
    fprintf(1, '\n\n%s', vec);
  end
  if ~ischar(vec)        %Stoppar n�r filen �r slutl�st.
    break
  elseif strcmp(vec(1), 'S')
    opnum = opnum + 1;
  
  elseif strcmp(vec(1), 'P')  %Kotrollera s� att inte f�rsta raden l�ses in!!!!!!!
    
    if strcmp(vec(svec-1:svec), ',L')
      vec = vec(1:svec-3);
      svec = length(vec);
    end
    
    kommapos = find(vec == ',');
    id = vec(kommapos(1)+1 : kommapos(2)-1);
    axstr = vec(kommapos(3)+1 : length(vec));
    id = char(id);
    id = [id, char(32*ones(1, size(asyid,2)-length(id)))];
    axstr = char(axstr);
    %knum = strmatch(id, asyid);    %Kanlnummer f�r br�nslet som flyttas.		
    if size(axstr,2) ~= 5
      knum = cpos2knum(axis2cpos(axstr), mminj);
    end
    
    %Det br�nsle som har slutposition utanf�r h�rden.
    if size(axstr,2) == 5
      fprintf(1, '\n\nBundle Case nr: %1i', g);
      idflytt(eocfil, bocfil, id);    %Function som skriver nya h�rdkartor och uppdaterar h�rden.
      g = g + 1;
    
    %Br�nsle som har khot mindre �n min.
    elseif khot(knum) < min
      fprintf(1, '\n\nBundle Case nr: %1i', g);
      idflytt(eocfil, bocfil, id, axstr);    %Function som skriver nya h�rdkartor och uppdaterar h�rde
      g = g + 1;
    
    %Det br�nsle som har slutposition i h�rden och khot st�rre �n min.
    else
      fprintf(1, '\n\nBundle Case nr: %1i', g);
      idflytt(eocfil, bocfil, id, axstr);    %Function som skriver nya h�rdkartor och uppdaterar h�rden.
      crnum1 = axis2crnum(bocfil, axstr);    %Function som hittar styrstavarna.
      styrstav(n,:) = crnum1;
      crnum = crnum1(find(crnum1));
      scrnum = size(crnum);        %Ber�kanr storleken p� crnum.
      fil = fopen('comp.txt', 'w');      %�ppnar compfilen.
      
      
      %B�rjar skriva de nio styrstavaskartorna.
      for j = 1:scrnum(2)        %Loopar igenom styrstavarna som plockats fram.
        if j == 1        %Skriver ut rubriker till polca.
          fprintf(fil, 'TITLE     *********** LADDSDM ***********   STYRSTAV 1');
          fprintf(fil, '\nSOUFIL     source.txt');
          fprintf(fil, '\nPRIFIL     print_polca.txt');
          fprintf(fil, '\nIDENT     %s', staton);
          fprintf(fil, '\nOPTION    COLD, TLOWP, NOAXHOM, NEU1, NOINTBUR');
          fprintf(fil, '\nINIT       eoc-upd.dat = HISTORY,BASIC');
          fprintf(fil, '\nSAVE       eoc-upd.dat = HISTORY,BASIC');
          fprintf(fil, '\nPRINT');
          if n == 1;
            fprintf(fil, '\nSUMFIL     sum.dat = RESET');
          else
            fprintf(fil, '\nSUMFIL     sum.dat');
          end
          fprintf(fil, '\nSYMME      1');
          fprintf(fil, '\nCOMMENT    FIKTIVA STYRSAVSLAGEN FRAN UNDERKRITISK BESTAMNING AV Kref');
          fprintf(fil, '\nCONROD');
        
	  polcanum = polcanum + 1;
	
	else
          fprintf(fil, '\nTITLE     *********** LADDSDM ***********   STYRSTAV %1i', j);
          fprintf(fil, '\nCONROD');
          polcanum = polcanum + 1;
	end
        
	
	cr = zeros(mz(69),1);
	cr(crnum(j)) = 100;
	cr = num2str(cr);		
	map = karta(cr, crmminj);
	for rad = 1:size(map,1)
          fprintf(fil, '\n%s', map(rad,:));
        end
	
       
	if j == 1          %Skriver rubriker till polca.
          fprintf(fil, '\nPOWER      0.0');
          fprintf(fil, '\nFLOW      3900');
          fprintf(fil, '\nPRESS     70.0');
          fprintf(fil, '\nTLOWP     49.3');
        else
          fprintf(fil, '\nTLOWP     49.3');
        end
      end
      
      fprintf(fil, '\nEND');
      fclose(fil);            %St�nger filen.
      !polca 'comp.txt'
      n = n + 1;
      
      
      if nargin == 10
        index = sdm_berakning(radnum, g, kref, crnum1, id, knum, crit, fp, fp2, index, title);
      else
        index = sdm_berakning(radnum, g, kref, crnum1, id, knum, crit, fp, fp2, index);
      end
      
      print_water(axstr, eocfil, fp3, radnum, g, id, knum);
      
      g = g + 1;
    end
    opnum = opnum + 1;
  end
  fprintf(1, '\n\n\n');

  radnum = radnum + 1;
end
%Utskrift av sdmresultat.

fclose(fid);        %St�nger ladfilen
fclose(fp);         %St�nger utfilen
fclose(fp3);
fclose(fp2);
if polcanum > 0
sum = sum2mlab7('sum.dat');
if size(sum,2) ~= polcanum
  differens = polcanum - size(sum,2);
  fprintf('\n\nVarning! %.0i stycken polcaber�kningar har avbrutits!\n\n', differens);
end
end
  
  
  
