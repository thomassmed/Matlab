function [varargout] = superead(fil,varargin)

% function [T PRESS ...] = superead(fil, T, PRESS ...)
%
% L�ser in variabler fr�n supe-filen "fil". Funktionen klarar sm� bokst�ver 
% i indata. Om ingen utparameter ges, skrivs v�rden ut p� sk�rmen.
%
% Om f�rsta variabel �r 'ALL' returneras en matris med samtliga variabler 
% och om tv� utvariabler ges d�, returneras �ven en matris med
% variabelnamnen. 
%
% Exempel:
% var = superead('bison.supe','ALL')
% var kommer inneh�lla samtliga m�tv�rden fr�n filen, varje rad motsvarar
% en variabel i den ordning de kommer i supe-filen
%
% [var namn] = superead('bison.supe','ALL') 
% var som ovan. Varje rad i namn inneh�ller variabelnamnet p� v�rdena i 
% motsvarande rad i var.
%
% var = superead('bison.supe','T','press','W314')
% var blir en treraders matris d�r f�rsta raden inneh�ller T, andra PRESS
% osv.
%
% [a b c] = superead('bison.supe','T','press','W314')
% I a returneras T, i b returneras 'PRESS' osv.
%
% Version 0.5, 2006-01-18
% Kan nu l�sa in signal.supe och 649.supe (f�rhoppningsvis alla 
% sorters supe-filer)
%
% Version 0.2
% Bj�rn Schr�der, bsc, FTTP, 2005-03-17
%
% Denna funktion �r inte kvalitetskontrollerad och inget ansvar tas av 
% f�rfattaren f�r eventuella fel som uppkommer vid anv�ndandet eller f�ljder
% d�rav.

disp(' ')
disp('OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS OBS');
disp('Denna funktion �r f�r�ldrad. Anv�nd axialread ist�llet.')
disp('Den �r snabbare och kan l�sa in axial- och hotrod-supefiler')
disp('All framtida utveckling sker p� axialread.m')
disp(' ')
% Maxl�ngd p� variablenamn
antal = 20;

[fid, errmsg] = fopen(fil,'r');
if fid == -1
  disp(['Inl�sningen avbryts: ' errmsg]);
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

% Variablerna har olika l�ngd i vanlig supe-fil (6 tecken) j�mf�rt med 
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
% Om den f�rs�ker l�sa end of file, se till att den g�r det f�r att 
% bryta while-loopen 
    if (fseek(fid,4*(9+no_var-sindex(end)),0) == -1)
      fseek(fid,0,1);
      fread(fid,1);
    end
  end
  no_matp = ind;
end

disp(['Antal m�tpunkter: ' num2str(no_matp)])

if nargout == 0
  varden
  return;
elseif nargout == 1
  varargout{1} = varden;
  return;
else
  disp('Returnerade v�rden:');
  for ind = 1:nargout
    varargout{ind} = varden(ind,:);
    disp(['      ' char(filvariabler(index(ind),:))]);
  end
end
return
