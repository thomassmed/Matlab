%@(#)   laddsdm.m 1.5	 10/05/05     13:19:19
%
%function f = laddsdm(laddfil, eocfil, bocfil, min, kref, crit, utfil_tot, utfil_crit, utfil_vatten, title)
%
%Inparametrar:
%LADDFIL: En fil med alla laddscheman enskillt eller sammanslagna.
%EOCFIL: Eocfilen för aktuell cykel, OBS Symme = 1!
%BOCFIL: Bocfilen för nästkommande cykel.
%MIN: Den gräns på khot som ska beräknas över.
%KREF: Värdet på kref
%CRIT: Kritiskt värde på sdm
%UTFIL_TOT: Resultatfil (alla avstängninsmarginaler)
%UTFIL_CRIT: Alla kritsika avstängningsmarginaler
%UTFIL_VATTEN: Visualiserar antal vattenhål kring aktuell patron
%TITLE: Valbart
%
%Eoc-filen som uppdateras är en kopia av den eocfil som är inparameter.
%Kopian får namnet eoc-upd.dat.
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
fid = fopen(ladfil);              %Öppnar filen med ladsheman.
[khot, mminj, konrod, bb, hy, mz, ks, asytyp, asyref, distlist, staton] = readdist7(bocfil, 'khot');        %Läser in khot och mminj.
asyid = readdist7(bocfil, 'asyid');
crmminj = mminj2crmminj(mminj);            %Beräknar styrstavsmminj.
scrmminj = size(crmminj);            %Beräknar storleken på crmminj.
styrstav = [];                       %Ändrat från zeros(0,9)
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
  vec = fgetl(fid);      %Läser i ladfilen.
  svec = length(vec);      %Beräknar storleken av den lästa informationen.
  if vec ~= -1
    fprintf(1, '\n\n%s', vec);
  end
  if ~ischar(vec)        %Stoppar när filen är slutläst.
    break
  elseif strcmp(vec(1), 'S')
    opnum = opnum + 1;
  
  elseif strcmp(vec(1), 'P')  %Kotrollera så att inte första raden läses in!!!!!!!
    
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
    %knum = strmatch(id, asyid);    %Kanlnummer för bränslet som flyttas.		
    if size(axstr,2) ~= 5
      knum = cpos2knum(axis2cpos(axstr), mminj);
    end
    
    %Det bränsle som har slutposition utanför härden.
    if size(axstr,2) == 5
      fprintf(1, '\n\nBundle Case nr: %1i', g);
      idflytt(eocfil, bocfil, id);    %Function som skriver nya härdkartor och uppdaterar härden.
      g = g + 1;
    
    %Bränsle som har khot mindre än min.
    elseif khot(knum) < min
      fprintf(1, '\n\nBundle Case nr: %1i', g);
      idflytt(eocfil, bocfil, id, axstr);    %Function som skriver nya härdkartor och uppdaterar härde
      g = g + 1;
    
    %Det bränsle som har slutposition i härden och khot större än min.
    else
      fprintf(1, '\n\nBundle Case nr: %1i', g);
      idflytt(eocfil, bocfil, id, axstr);    %Function som skriver nya härdkartor och uppdaterar härden.
      crnum1 = axis2crnum(bocfil, axstr);    %Function som hittar styrstavarna.
      styrstav(n,:) = crnum1;
      crnum = crnum1(find(crnum1));
      scrnum = size(crnum);        %Beräkanr storleken på crnum.
      fil = fopen('comp.txt', 'w');      %Öppnar compfilen.
      
      
      %Börjar skriva de nio styrstavaskartorna.
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
      fclose(fil);            %Stänger filen.
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

fclose(fid);        %Stänger ladfilen
fclose(fp);         %Stänger utfilen
fclose(fp3);
fclose(fp2);
if polcanum > 0
sum = sum2mlab7('sum.dat');
if size(sum,2) ~= polcanum
  differens = polcanum - size(sum,2);
  fprintf('\n\nVarning! %.0i stycken polcaberäkningar har avbrutits!\n\n', differens);
end
end
  
  
  
