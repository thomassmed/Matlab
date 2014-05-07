function filetyp = identfile(filename)
% identfile is used to find the kind of file in input works for restart, 
% cms, sum, out & pin 
%   
%   filetyp = identfile(filename)
%
% Input
%   filename    - name of file
% Output
%   filetyp     - file type
%   
% Example:
%
% filetyp = identfile('EOC16_ISO_12742')
% 
% See also ReadCore, file

% Mikael Andersson 2012-04-12

[PATH,NAME,ext] = fileparts(filename);
if strncmpi(ext,'.mat',4), filetyp='mat';return;end
%% get example text
fid = fopen(filename,'r');
if fid<0, warning('File not found');return;end
extext = fread(fid,400)';
fclose(fid);
filetyp = [];
% tests
%% Polca distribution file
if extext(200)== 188 && extext(199)== 104 && extext(198)== 1 && extext(197)==0
    filetyp='p7'; % little endian
    return;
end
if extext(197)== 188 && extext(198)== 104 && extext(199)== 1 && extext(200)==0
    filetyp='p7'; % big endian
    return;
end
%% Polca distribution file
if extext(197)== 60 && extext(198)== 48 && extext(199)== 0 && extext(200)==0
    filetyp='p4'; % big endian
    return;
end
if extext(200)== 60 && extext(199)== 48 && extext(198)== 0 && extext(197)==0
    filetyp='p4'; % little endian
    return;
end
if extext(197)== 189 && extext(198)== 104 && extext(199)== 1 && extext(200)==0
    filetyp='pre'; % big endian
    return;
end
%% restart file
if strcmp(char(extext(9:18)),'PARAMETERS') && extext(4) == 24
    filetyp = 'res';
    return;
end
%% cmsfile
if strcmp(char(extext(1:8)),'XVIS0003') || strcmp(char(extext(1:4)),'XVIS') 
    filetyp = 'cms';
    return;
end
%% sumfile
if strcmpi(char(extext(1:5)),'TITLE')
    filetyp = 'sum';
    return;
end
%% outfile
if ~isempty(strfind(lower(char(extext)),'using executable'))
    filetyp = 'out';
    return;
end
%%
%% pinfile
% NOTE/TODO: Is based on where the date is positioned
pindatvec = [35 38 43 46 51 54];
if strcmp('////::',char(extext(pindatvec))) || strcmp('////::',char(extext(pindatvec+2)))
    filetyp = 'pin';
end
%% not working
if isempty(filetyp)
    warning('filetype not found.');
    filetyp = 'unknown';
end
    