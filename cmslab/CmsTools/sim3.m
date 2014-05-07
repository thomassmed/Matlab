function sim3(inpfil,s3version)
% Run sim3
%
% sim3(inpfil[,s3version])
%
% Input:
%   inpfil     - s3 input file
%   s3version  - used s3 version
%
% Output:
%  No output
%
% Examples
%   sim3 s3.inp
%   sim3 s3.inp 1.6.08
%   sim3('s3.inp','1.6.08');
%   s3inp{1}='s3_1.inp';s3inp{2}='s3_2.inp'; sim3(s3inp)
%
% See also set_version, Res2Inp



%%
if ischar(inpfil), inpfil=cellstr(inpfil);end
for i=1:length(inpfil),
outfil=strrep(inpfil{i},'.inp','.out');
sumfil=strrep(inpfil{i},'.inp','.sum');
cmsfil=strrep(inpfil{i},'.inp','.cms');
if exist(outfil,'file'),
    delete(outfil);
end
if ispc,
    cmshome= winqueryreg('HKEY_LOCAL_MACHINE','SOFTWARE\Studsvik Scandpower');
    if nargin<2,
        s3version= winqueryreg('HKEY_LOCAL_MACHINE','SOFTWARE\Studsvik Scandpower','S3_DEFAULT_VERSION');
    elseif strcmpi(s3version(1),'v'),
        s3version(1)=[];
    end
end
s3str=[cmshome,filesep,'S3',filesep,'v',s3version,filesep,'Windows_NT',filesep,'simulate3.exe < ',inpfil{i},' > ',outfil];
disp(s3str);
disp(['Simulate Version: ',s3version]);
system(s3str);
movefile('SUMMARY',sumfil,'f');
if exist('s3plot.cms','file'),
    movefile('s3plot.cms',cmsfil,'f');
end
%delete('fort.*');
end