function Versn=set_version(codename,versn)
% Sets defaults version for CMS-codes (S3, S5, C4, C5 etc)
%
% Versn=set_version(codename,versn)
%
% Input:
%   codename - name
%   versn    - default version
%
%  Output
%   Versn    - default version (or in the case of one input argument,
%              available versions)
%
% Example:
%   set_version S3 1.6.08
%   Versn=set_version('S3')
%   set_version('S3',Versn{3});
%
% See also sim3, Res2Inp

%%
% versn='TVO';
% versn='6.09.15_NMC_TVO_COMPAQ';
% codename='S3';
if nargin<1, codename='S3';end %TODO: If nargin ==0, list all available codes
if nargin<2,
    %%
    cmshome= winqueryreg('HKEY_LOCAL_MACHINE','SOFTWARE\Studsvik Scandpower');
    files=dir([cmshome,filesep,codename]);
    icount=0;
    switch upper(codename)
        case 'S3'
            executable='simulate3.exe';
        case 'S3K'
            executable='s3k.exe';
    end     
    for i=1:length(files),
        if files(i).isdir&&strcmpi(files(i).name(1),'v')
            if exist([cmshome,filesep,codename,filesep,files(i).name,filesep,'Windows_NT',filesep,executable],'file')
                icount=icount+1;
                Versn{icount,1}=files(i).name;
            end
        end
    end
    defversion= winqueryreg('HKEY_LOCAL_MACHINE','SOFTWARE\Studsvik Scandpower',[codename,'_DEFAULT_VERSION']);
    fprintf(1,'%s default version: %s\n',codename,defversion);
else 
    if strcmpi(versn(1),'v'), versn(1)=[];end
    system(['registry -s -k "HKEY_LOCAL_MACHINE\SOFTWARE\Studsvik Scandpower" -n ',codename,'_DEFAULT_VERSION -v ',versn]);
    Versn=versn;
end
