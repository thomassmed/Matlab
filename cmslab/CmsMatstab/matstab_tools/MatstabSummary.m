function MatstabSummary(file,titel)
if nargin<1,
    file='files.txt';
end
fid=fopen(file,'r');
temp=textscan(fid,'%s');
s3kinp=temp{1};
fclose(fid);
%%
if nargin<2,
    titel=FindCommonStart(s3kinp);
end
%% Pick up the results
for i=1:length(s3kinp),
    s3kmat{i,1}=strrep(s3kinp{i},'.inp','.mat');
end
[dr_mstab,fd_mstab,Qrel_mstab,Wtot_mstab,drh,fdh]=get_drfd(s3kmat);
%% Read measured data and s3k/calc from excel spread sheet
if ispc,
    read_from_excel; % Gives dr_meas, fd_meas, dr_s3k, fd_s3k
else
    load excel_data
end
%% Plot the results
figs=plot_drfd(dr_mstab,fd_mstab,dr_meas,fd_meas,dr_s3k,fd_s3k,'s3k',titel);
%% Document in a summary file, png-files and a mat-file
nu=prt_drfd(dr_mstab,fd_mstab,dr_meas,fd_meas,s3kmat,titel,figs);
%% If you work on a pc, you may want to store it to an excel-file as well
if ispc,
    mstab2excel(s3kmat,dr_meas,fd_meas,nu,titel,dr_s3k,fd_s3k,qrel,Hcflow);
end
function titel=FindCommonStart(s3kinp)

%%
l=length(s3kinp);
for i=1:length(s3kinp{1}),
    if length(cell2mat(strfind(s3kinp,s3kinp{1}(1:i))))<l,break;end
end
titel=s3kinp{1}(1:i-1);
    