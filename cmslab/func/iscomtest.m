function yon=iscomtest(file)
% iscomtest - true if file is a comtestfile
%
% yon=comtest(file)
%
% Output 
%   yon  - true if file is a comtest file
%   yon  - false if file is not a comtest file
%

% Updated with return false on error /MHE
try
    fid=fopen(file,'r');
    test=fread(fid,12,'*char');
    fclose(fid);
    yon=strncmp(test,'MeasDataFile',12);
catch me
    yon = false;
end

