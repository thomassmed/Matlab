function inpfil=Res2Inp(resfil,Xpo,titel)
% Creates S3 input file from restart file
%
% Res2Inp(resfil[Xpo,,titel])
%
% Input:
%   resfil  - restart file name
%   Xpo     - exposure point (default 10000)
%   titel   - title of case  (default ['S3 run started from Matlab with restartfile: ',resfil])
%
%  Output:
%   inpfil - Name on input file
%
% Examples
%   Res2Inp s3.res
%   Res2Inp('s3.res','Test case for Matlab');
%   sim3(Res2Inp('s3.res'));
%
%  See also sim3, set_version

if nargin<2, 
 [limits,Xpo,Titles]=read_restart_bin(resfil,-1); 
end

if nargin<3, titel=['S3 run started from Matlab with restartfile: ',resfil];end
inpfil=strrep(resfil,'.res','.inp');
%% Prepare input file
fid=fopen(inpfil,'w');
for i=1:length(Xpo),
    titstr=['''TIT.CAS'' ','''',titel,''' Exposure: '];
    fprintf(fid,'%s %5.2f  / \n',titstr,Xpo(i));
    resstr=['''RES'' ''',resfil,''' '];
    fprintf(fid,'%s %5.2f / \n',resstr,Xpo(i));
    fprintf(fid,'''CMS.EDT'' ''ON'' ''3RPF'' ''3VOI'' ''2FLO'' / \n');
    fprintf(fid,'''STA'' / \n');
end
fprintf(fid,'''END'' / \n');
fclose(fid);