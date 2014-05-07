function [] = sum2xenoncomp(staton,sumFile,sumsort,seqFile,souFile,iniFile,cykel,fromTime,toTime,symme)

% sum2xenoncomp(staton,sumFile,sumsort,seqFile,souFile,iniFile,cykel,fromTime,toTime,symme)
% Läser en sum-fil och generar en complementfil
% Anpassad för Polca 7
%
% ex:	staton = 	'f1' , 'f2' eller 'f3'
% ex:	sumFile =	'sum-xenon.dat' (hela sökvägen till filen måste ges, om densamma inte återfinns i aktuell directory)
% ex:	sumsort = 	'sum' eller 'lngsum'
% ex:	seqFile = 	'26v-01-crsup.txt' (hela sökvägen till filen måste ges, om densamma inte återfinns i aktuell directory)
% ex:	souFile =	'/cm/f1/c26/pol/source.txt' (hela sökvägen till filen måste ges, om densamma inte återfinns i rådande directory)
% ex:	iniFile =	'/cm/f1/c26/dist/boc26.dat' (hela sökvägen till filen måste ges, om densamma inte återfinns i rådande directory)
% ex:	cykel =		'f1_boc_26'
% ex: 	fromTime = 	[2006 6 21 7 54 0]
% ex:	toTime   = 	[2006 6 19 19 16 0]
% ex:	symme = 	3
%
% Resulterande complementfil hamnar aktuell directory
% med namn						comp-xenon-f1_boc_26.txt
%
% Då complementfilen exekveras sparas resulterande distfil
% i current directory					
% med namn						f1_boc_26-xetran.dat
%
% Då complementfilen exekveras sparas resulterande sumfil
% i current directory					
% med namn						sum-f1_boc_26-xetran.dat												

%------------------------------------------------------------------------------
%	INDATA-FILER
%------------------------------------------------------------------------------
gr2crFile = 	['/cm/' staton '/fil/cr-man.txt'];


%------------------------------------------------------------------------------
%	KOMPLEMENT-FIL			(UTDATA-FIL)
%------------------------------------------------------------------------------
compFile = 	['comp-xenon-' cykel '.txt'];


%------------------------------------------------------------------------------
%	LÄS DATA FRÅN SUMFIL
%------------------------------------------------------------------------------

if strcmp(sumsort,'sum')					% Polca7, online summary-file
  sumData = sum2mlab7(sumFile);				
elseif strcmp(sumsort,'lngsum')					% lng-sum-data-fil
  sumData_temp = lngsum2mlab(sumFile); 
  sumData = zeros(51,size(sumData_temp,2));
  sumData(6,:) = sumData_temp(1,:);
  sumData(5,:) = sumData_temp(2,:);
  sumData(4,:) = sumData_temp(3,:);
  sumData(3,:) = sumData_temp(4,:);
  sumData(2,:) = sumData_temp(5,:);
  sumData(1,:) = sumData_temp(6,:); 
  sumData(51,:) = sumData_temp(10,:);
  sumData(9,:) = sumData_temp(8,:)*1e-2;
  sumData(10,:) = sumData_temp(9,:);
  sumData(11,:) = sumData_temp(11,:);
  sumData(13,:) = 70.0e5*ones(1,size(sumData,2));
  clear sumData_temp;
end
  

%------------------------------------------------------------------------------
%	PERIOD VILKEN SKA SIMULERAS:   fromTime < x < toTime
%------------------------------------------------------------------------------
% First record
fromTime = datenum(fromTime(1),fromTime(2),fromTime(3),fromTime(4),fromTime(5),fromTime(6));

% Last record	% tid för stabmätning
toTime = datenum(toTime(1),toTime(2),toTime(3),toTime(4),toTime(5),toTime(6));	


%------------------------------------------------------------------------------
% 	HITTA RECORDS I SUMFIL
%------------------------------------------------------------------------------
i=1;										% start-record
sumTime=datenum(sumData(6,i),sumData(5,i),sumData(4,i),...
		sumData(3,i),sumData(2,i),sumData(1,i));			% tid för record	
while sumTime<fromTime								% leta rätt på första record!
  i=i+1;
  sumTime=datenum(sumData(6,i),sumData(5,i),sumData(4,i),...
  		sumData(3,i),sumData(2,i),sumData(1,i));
end
fromRecord=i;									% starta med record i 

sumTime=datenum(sumData(6,i),sumData(5,i),sumData(4,i),...
		sumData(3,i),sumData(2,i),sumData(1,i));			% leta vidare till slut-record
while sumTime<toTime
  i=i+1;
  sumTime=datenum(sumData(6,i),sumData(5,i),sumData(4,i),...
  sumData(3,i),sumData(2,i),sumData(1,i));
end

if sumTime == toTime
  toRecord=i;									% sluta med record i 
else
  toRecord=i-1;
end    

fromRecord
toRecord


%------------------------------------------------------------------------------
%	BYGG KOMPLEMENTFILEN
%------------------------------------------------------------------------------
compId = fopen(compFile, 'w');							% öppna comp-filen för skrivning

fprintf(compId, 'TITLE     Date: %4.0f-%2.0f-%2.0f  Time: %2.0f:%2.0f:%2.0f  SSUM: %1.0f\n',...
	 	[sumData(6, fromRecord) sumData(5, fromRecord) sumData(4, fromRecord) ...
	 	sumData(3, fromRecord) sumData(2, fromRecord) ...
		sumData(1, fromRecord) sumData(51, fromRecord)]);
fprintf(compId, ['SOUFIL    ' souFile '\n']);
fprintf(compId, 'PRIFIL    print.txt\n');
fprintf(compId, 'IDENT     F1\n');
fprintf(compId, 'OPTION    NEU3,POWER,TLOWP,CBH,NOPOST\n');
if symme>0
  fprintf(compId, ['SYMME     ' num2str(symme) '\n']);
end  
fprintf(compId, ['INIT      ' iniFile ' = BURNUP,HISTORY,BASIC\n']);
fprintf(compId, ['SAVE      ' cykel '-xetran.dat = POWER,\n']);
fprintf(compId, 'SAVE  *     HISTORY,BASIC,CHFLOW,FLWWC,VOID,IODINE,XENON,LEKBP2,LEKBP3\n');
fprintf(compId, 'PRINT\n');
fprintf(compId, ['SUMFIL    sum-' cykel '-xetran.dat = RESET\n']);

for fall = fromRecord:toRecord
  if fall > fromRecord
    fprintf(compId, 'TITLE     Date: %4.0f-%2.0f-%2.0f  Time: %2.0f:%2.0f:%2.0f  SSUM: %1.0f\n',...
    		[sumData(6, fall) sumData(5, fall) sumData(4, fall) sumData(3, fall) ...
		 sumData(2, fall) sumData(1, fall) sumData(51, fall)]);
%    if fall == fromRecord + 1
     if 100*sumData(9, fall) > 5.0
        fprintf(compId, 'OPTION    NEU3,POWER,TLOWP,CBH,NOPOST,XETRAN\n');
     else
        fprintf(compId, 'OPTION    NEU3,POWER,TLOWP,CBH,NOPOST,XEONLY\n');
     end
%    end
  end	
  
  % gör utskrift av SSUM, SSUM-end, och antal records
  disp(['SSUM = ' num2str(sumData(51,fall)) ', STOP = ' num2str(sumData(51,toRecord)) ', NREC = ' num2str(fall-fromRecord+1) ]);

  fprintf(compId, 'CONROD\n');
  crstop = sumData(51, fall);							% sluta då SSUM uppnått crstop
  cr = zeros(15, 15);								% samtliga stavar inne
  
  %------------------------------------------------------------------------------
  %	LÄS DATA FRÅN SEKVENSFIL
  %------------------------------------------------------------------------------
  seqId = fopen(seqFile, 'r');							% öppna fil för läsning
  line = fgets(seqId);								% läs in första raden från sekvensfilen: 
  										% 	"**24V01    F1 C24 Driftsekvens"
	
  while sum(sum(cr)') < crstop							% sålänge SSUM < crstop...
  
    line = fgets(seqId);							% läs in ny rad från sekvensfilen
    if strcmp(line(1,1:3),'VIT')
      continue;
    end  
    if strcmp(line(1,1:3),'SVA')
      continue;
    end
      
    line = strrep(line, ',', ' ');						% byt ut eventuella komman till mellanrum

    if line(1, 1) == ' '							% om raden inleds med mellanrum
      A = sscanf(line, '%f', 3);						% läs in de tre första elementen från line i A

      %------------------------------------------------------------------------------
      %	LÄS DATA FRÅN gr2cr-FIL
      %------------------------------------------------------------------------------
      gr2crId = fopen(gr2crFile,'r');						% öppna fil för läsning
      B = zeros(2,1);
      while B(1,1) ~= A(1,1)							% läs in nr A(1,1)
        line1 = fgets(gr2crId);
	line2 = fgets(gr2crId);
	B = sscanf(line1, '%f',2); 						% läs in de två första elementen från line1 i B
										% styrstavsgrupp och antal styrstavar i gruppen 
      end
      fclose(gr2crId);
	
      grsize = B(2, 1);								% grupp-storlek (antal stavar i gruppen)
	
      if grsize == 2								% om grupp-storlek 2...
        gr = { [line2(1, 1:3)]; [line2(1, 7:9)] };				% styrstavar vilka ingår i gruppen
      end
      if grsize == 4								% om grupp-storlek 4...
        gr = { [line2(1, 1:3)]; [line2(1, 7:9)]; ...
      		[line2(1, 13:15)]; [line2(1, 19:21)] };				% styrstavar vilka ingår i gruppen
      end
      if grsize == 5								% om grupp-storlek 5...
        gr = { [line2(1, 1:3)]; [line2(1, 7:9)]; [line2(1, 13:15)];...
      		 [line2(1, 19:21)]; [line2(1, 25:27)] };			% styrstavar vilka ingår i gruppen
      end	     
      if grsize == 8								% om grupp-storlek 8
        gr = { [line2(1, 1:3)]; [line2(1, 7:9)]; [line2(1, 13:15)]; ...
      		[line2(1, 19:21)];[line2(1, 25:27)]; [line2(1, 31:33)];...
	 	[line2(1, 37:39)]; [line2(1, 43:45)] };				% styrstavar vilka ingår i gruppen
      end	     
    else
      grsize = 1;								% annars, enbart en stav...
      gr = { [line(1, 1:3)] };							% 
      line(1, 1) = ' ';								% ta bort första elementet i line (bokstav)
      A = sscanf(line, '%f', 3);						% läs in de tre första elementen från line i A
    end
    
    if crstop - sum(sum(cr)') >= grsize * (A(3,1) - A(2,1))			% A(3,1)-A(2,1) = antal % gruppens stavar dras
      crAdd = A(3, 1) - A(2, 1);
    else
      crAdd = (crstop - sum(sum(cr)')) / grsize;				% lägg enbart till upp till crstop!!!
    end
    for k = 1:grsize								% för samtliga stavar i gruppen
      coord = axis2crpos(char(gr(k, 1)));
      cr(coord(1, 1), coord(1, 2)) = cr(coord(1, 1), coord(1, 2)) + crAdd;	% dra stav!!!
    end
    
  end

  fclose(seqId);
  
  if strcmp(staton,'f3')
  
    fprintf(compId, '                                     %5.1f %5.1f %5.1f                                        \n', cr(1, 7:9));
    fprintf(compId, '                   %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                      \n', cr(2, 4:12));
    fprintf(compId, '             %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                \n', cr(3, 3:13));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f          \n', cr(4, 2:14));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f          \n', cr(5, 2:14));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f          \n', cr(6, 2:14));
    fprintf(compId, ' %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f    \n', cr(7, 1:15));
    fprintf(compId, ' %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f    \n', cr(8, 1:15));
    fprintf(compId, ' %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f    \n', cr(9, 1:15));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f          \n', cr(10, 2:14));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f          \n', cr(11, 2:14));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f          \n', cr(12, 2:14));
    fprintf(compId, '             %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                \n', cr(13, 3:13));
    fprintf(compId, '                   %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                      \n', cr(14, 4:12));
    fprintf(compId, '                                     %5.1f %5.1f %5.1f                                        \n', cr(15, 7:9));

  else

    fprintf(compId, '                                     %5.1f %5.1f %5.1f                                                \n', cr(1, 7:9));
    fprintf(compId, '                         %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                                \n', cr(2, 5:11));
    fprintf(compId, '             %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                \n', cr(3, 3:13));
    fprintf(compId, '             %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                \n', cr(4, 3:13));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f        \n', cr(5, 2:14));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f        \n', cr(6, 2:14));
    fprintf(compId, ' %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f\n', cr(7, 1:15));
    fprintf(compId, ' %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f\n', cr(8, 1:15));
    fprintf(compId, ' %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f\n', cr(9, 1:15));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f        \n', cr(10, 2:14));
    fprintf(compId, '       %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f        \n', cr(11, 2:14));
    fprintf(compId, '             %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                \n', cr(12, 3:13));
    fprintf(compId, '             %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                \n', cr(13, 3:13));
    fprintf(compId, '                         %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f                                \n', cr(14, 5:11));
    fprintf(compId, '                                     %5.1f %5.1f %5.1f                                                \n', cr(15, 7:9));
  
  end
		
  fprintf(compId, 'POWER     %1.1f\n' ,100 * sumData(9, fall));
  fprintf(compId, 'FLOW      %1.0f\n', sumData(10, fall));
  fprintf(compId, 'PRESS     %1.1f\n', sumData(13, fall) / 100000);
  fprintf(compId, 'TLOWP     %1.1f\n', sumData(11, fall));
	
  if fall > fromRecord
    if sumData(4, fall) == sumData(4, fall - 1)					% om samma dygn...
      fprintf(compId, 'XETRAN    %1.4f\n', (sumData(1,fall)-sumData(1,fall-1)+...
      				60*(sumData(2,fall)-sumData(2,fall-1))+...
				3600*(sumData(3,fall)-sumData(3,fall-1)))/3600);% tid mellan fallen i timmar
    else
      fprintf(compId, 'XETRAN    %1.4f\n', (sumData(1,fall)-sumData(1,fall-1)+...
      				60*(sumData(2,fall)-sumData(2,fall-1))+...
				3600*(24+sumData(3,fall)-sumData(3,fall-1)))/3600);
    end
  end
	
  if fall ~= toRecord								% om slutet ej funnet... 
    fprintf(compId, '!--------------------------------------------------------------\n');
  end
end

fprintf(compId, 'END');								% slut...
fclose(compId);									% stäng fil...


crstop
sum(sum(cr))
