function plex_struct = ReadExcelPlexData(excel_plex_data_file, sheet)
% plex_struct = ReadExcelPlexData(excel_plex_data_file)
%
% In:
%   excel_plex_data_file - S�kv�g till excelfil med plex data [char]
%   sheet - Namn p� flik i excel som data ska l�sas fr�n [char]
%
% Ut:
%   plex_data struct med f�ljande format:
%   plex_struct.namn    Taggnamn
%   plex_struct.beskr   Taggbeskrivning
%   plex_struct.enhet   Tagg enhet
%   plex_struct.tid     Tid i MATLAB "seriel data number" format (>help 
%                       datenum f�r info)
%   plex_struct.data    Numeriskt data
%                 
% Beskrivning:
% L�ser Plex data fr�n Excel ark mha Aspentech till�gg. I fallet att det
% inte finns n�gon data f�r en tagg vid en tid som ing�r i s�kningen s�
% blir denna ruta tom i Exel. Detta ers�tts med NaN i plex_struct.data.
% Data i Excelark ska ha format enligt nedanst�ende.
%
%       A           B             C            D            E    
% 1     Starttid    Namn tagg1    Namn tagg2   Namn tagg3   ...
% 2     Sluttid     Beskr tagg1   Beskr tagg2  Beskr tagg3  ...
% 3     Blank       Enhet tagg1   Enhet tagg2  Enhet tagg3  ...
% 4     Tidpunkt 1  V�rde tagg1   V�rde tagg2  V�rde tagg3  ...
% 5     Tidpunkt 2  V�rde tagg1   V�rde tagg2  V�rde tagg3  ...
% 6     .           .             .            .            ...
% 7     .           .             .            .            ...
% 8     .           .             .            .            ...
%
% Exempel 1, l�s fil med Excel plex data och plotta f�rsta taggen inkl legend:
% plex_data = ReadExcelPlexData('Plex_data.xlsx', 'F2');
% plot(plex_data.tid, plex_data.data(:,1))
% legend([plex_data.namn{1} ' [' plex_data.enhet{1} ']'])
% datetick

% L�s Excelarket med plex data
[num, txt, raw] = xlsread(excel_plex_data_file, sheet);

% Konstanter
nof_header_row = 3;
nof_time_col = 1;

[nof_row, nof_col] = size(txt);
nof_samples = nof_row-nof_header_row;
nof_signal = nof_col-1;


namn = txt(1,2:nof_col);
beskr = txt(2,2:nof_col);
enhet = txt(3,2:nof_col);
tid = datenum(txt(nof_header_row+1:nof_row,1));

%% Transformera textdata till numeriskt data
txt_data = txt(nof_header_row+1:end,nof_time_col+1:end);
[nof_row, nof_col] = size(txt_data);
% Initiera storleken av data
data = zeros(nof_row, nof_col);
for n=1:nof_col
    for m=1:nof_row
        if isempty(txt_data{m,n})
            % Om cellen �r tom betyder det att inget plex data finns f�r
            % denna tidpunkt, s�tt d� detta element till NaN
            data(m,n) = NaN;
        else
            % Ers�tt , med .
            temp = strrep(txt_data(m,n),',','.');
            % Konvertetra till numeriskt v�rde
            data(m,n) = str2num(cell2mat(temp));
        end
    end
end

plex_struct.namn = namn;
plex_struct.beskr = beskr;
plex_struct.enhet = enhet;
plex_struct.tid = tid;
plex_struct.data = data;