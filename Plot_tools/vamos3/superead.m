function [varargout] = superead(fil,varargin)

% function [T PRESS ...] = superead(fil, T, PRESS ...)
%
% Läser in variabler från supe-filen "fil". Funktionen klarar små bokstäver 
% i indata. Om ingen utparameter ges, skrivs värden ut på skärmen.
%
% Om första variabel är 'ALL' returneras en matris med samtliga variabler 
% och om två utvariabler ges då, returneras även en matris med
% variabelnamnen. 
%
% Exempel:
% var = superead('bison.supe','ALL')
% var kommer innehålla samtliga mätvärden från filen, varje rad motsvarar
% en variabel i den ordning de kommer i supe-filen
%
% [var namn] = superead('bison.supe','ALL') 
% var som ovan. Varje rad i namn innehåller variabelnamnet på värdena i 
% motsvarande rad i var.
%
% var = superead('bison.supe','T','press','W314')
% var blir en treraders matris där första raden innehåller T, andra PRESS
% osv.
%
% [a b c] = superead('bison.supe','T','press','W314')
% I a returneras T, i b returneras 'PRESS' osv.
%
% Version 0.5, 2006-01-18
% Kan nu läsa in signal.supe och 649.supe (förhoppningsvis alla 
% sorters supe-filer)
%
% Version 0.2
% Björn Schröder, bsc, FTTP, 2005-03-17
%
% Denna funktion är inte kvalitetskontrollerad och inget ansvar tas av 
% författaren för eventuella fel som uppkommer vid användandet eller följder
% därav.

disp(' ')
disp('OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS');
disp('Denna funktion är föråldrad. Använd axialread istället.')
disp('Den är snabbare och kan läsa in axial- och hotrod-supefiler')
disp('All framtida utveckling sker på axialread.m')
disp(' ')
% Maxlängd på variablenamn
antal = 20;

[fid, errmsg] = fopen(fil,'r');
if fid == -1
  disp(['Inläsningen avbryts: ' errmsg]);
  for ind = 1:nargout
    varargout{ind} = 'error';
  end
  return;
end

utvariabler = char(zeros(0,antal+4));
for ind = 1:(nargin-1)
  utvariabler(ind,:) = sprintf('%-24s',upper(varargin{ind}));
end

fseek(fid,0,-1);
fseek(fid,440,0);
[no_var,c] = fread(fid,1,'int32');
if no_var < 10
  fseek(fid,196,0);
  [no_var,c] = fread(fid,1,'int32');
end
disp(['Antal variabler: ' num2str(no_var)]);
fseek(fid,4,0);

% Variablerna har olika längd i vanlig supe-fil (6 tecken) jämfört med 
% signal eller 649-supe-fil (20 tecken)
namnlangd = fread(fid,1,'int32');

% for ind = 1:no_var;
%   [filvariabler(ind,1:6),c] = fread(fid,6,'char');
%   [A,c] = fread(fid,1,'int32');
% end

filvariabler = char(reshape(fread( ...
    fid,(namnlangd+4)*no_var,'char'),(namnlangd+4),no_var)');

fseek(fid,14*4+40*1+9*4,0);

% Om alla
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin == 1 || strcmp('ALL',(upper(varargin{1}))))
  ind = 0;
  while (~feof(fid))
    ind = ind+1;
    varden(:,ind) = fread(fid,no_var,'float32');
    if (fseek(fid,9*4,0) == -1)
      fseek(fid,0,1);
      fread(fid,1);
    end
  end
  no_matp = ind;
  fclose(fid);
  
  if nargout == 0
    varden
    return;
  elseif nargout == 1
    varargout{1} = varden;
    return;
  elseif nargout == 2
    varargout{1} = varden;
    varargout{2} = char(filvariabler);
    return;
  end
  return;
else
  ind3 = 0;
  for ind = 1:size(utvariabler,1);
    ind2 = strmatch(utvariabler(ind,1:namnlangd),filvariabler);
    if ind2
      ind3 = ind3+1;
      index(ind3) = ind2(1);
    else
      disp(['Variabeln ' utvariabler(ind,:) ' inte hittad.'])
    end
  end

  
  [sindex sind] = sort(index);
  dindex = diff(sindex);
  ind = 0;
  while (~feof(fid))
    ind = ind+1;
    fseek(fid,4*(sindex(1)-1),0);

    temp = fread(fid,1,'float32');
    for ind2 = 1:length(dindex);
      if dindex(ind2) == 0
        temp(ind2+1) = temp(ind2);
      else
        fseek(fid,4*(dindex(ind2)-1),0);
        temp(ind2+1) = fread(fid,1,'float32');
      end
    end
    varden(sind,ind) = temp;
% Om den försöker läsa end of file, se till att den gör det för att 
% bryta while-loopen 
    if (fseek(fid,4*(9+no_var-sindex(end)),0) == -1)
      fseek(fid,0,1);
      fread(fid,1);
    end
  end
  no_matp = ind;
end

disp(['Antal mätpunkter: ' num2str(no_matp)])

if nargout == 0
  varden
  return;
elseif nargout == 1
  varargout{1} = varden;
  return;
else
  disp('Returnerade värden:');
  for ind = 1:nargout
    varargout{ind} = varden(ind,:);
    disp(['      ' char(filvariabler(index(ind),:))]);
  end
end
return
