function kpunkt=ReadKpunkt(filename,kpunktname)
% ReadKpunkt - Reads one K-punkt from racs or comtest data file
%
% kpunkt=ReadKpunkt(filename,kpunktname)
%
% Input
%   filename   - File name
%   kpunktname - Name on k-punkt
%
% Output  
%   kpunkt     - Time trajectory for kpunkt
%
%  Example:
%    hc=ReadKpunkt('Varmaprov_2013-04-04_04_000.dat','211K035');
%    t=ReadKpunkt('Varmaprov_2013-04-04_04_000.dat','t');plot(t,hc)
%
% See also ReadMatdataFil, racsread, plotmat

% Written 2014-04-29 Thomas Smed

%% Check File type
fid=fopen(filename,'r','ieee-be');
test=fread(fid,12);
%% 
filtyp='unknown';
if strncmp(char(test),'MeasDataFile',12),
    filtyp='comtest';
elseif test(1)==7&&test(3)<13&&test(3)<32
    filtyp='racs';
end
fclose(fid);

switch filtyp
    case 'comtest'
        kpunkt=ReadMatdataFil(filename,kpunktname);
    case 'racs'
        kpunkt=racsread(filename,kpunktname);
    otherwise
        kpunkt=[];
end 
end
