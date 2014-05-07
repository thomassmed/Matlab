function nu=prt_drfd(dr_mstab,fd_mstab,dr_meas,fd_meas,matfiles,titel,figs,drh,fdh)
% prt_drfd    Write stat of stability to file
%
% prt_drfd(dr_mstab,fd_mstab,dr_meas,fd_meas[,matfiles,figs])
%
%
% Example:
%     matfiles={'/cms/t2-jef/c18/s3k/s3k-1.mat','/cms/t2-jef/c19/s3k/s3k-1.mat'};
%     [dr,fd]=get_drfd(matfiles)
%     prt_drfd(dr_mstab,fd_mstab,dr_meas,fd_meas,matfiles);
%
% See Also
% get_drfd, plot_drfd

if nargin<5,
    matfiles=cell(length(dr_mstab),1);
end

nu=datestr(now,'yyyy-mm-dd-HHMM');
mkdir(nu)
printfil=[nu,filesep,'matsum.sum'];

if nargin>6
    for i=1:length(figs),
        figure(figs(i))
        switch i
            case 1
                prifil=[nu,filesep,'dr-tid'];
            case 2
                prifil=[nu,filesep,'fd-tid'];
            case 3
                prifil=[nu,filesep,'drMeasCalc'];
            case 4
                prifil=[nu,filesep,'fdMeasCalc'];
        end
        print('-dpng',prifil);
end
end
if ~iscell(matfiles), matfiles=cellstr(matfiles);end

ml_meas=length(dr_meas);
ml_mstab=length(dr_mstab);
if ml_mstab>ml_meas,
    dr_meas(ml_meas+1:ml_mstab)=NaN;
    fd_meas(ml_meas+1:ml_mstab)=NaN;
end

fid=fopen(printfil,'w');
fprintf(fid,'%s \n \n',titel);
fprintf(fid,'       Case                      Qrel  Flow  Measured  Matstab   Measured  Matstab');
if nargin>7,
    fprintf(fid,'  drh1      fdh1      drh2      fdh2');
end
fprintf(fid,'\n');
fprintf(fid,'                                      (kg/s)   dr       dr         fd       fd   ');
fprintf(fid,'\n');
for i=1:size(matfiles,1),
  matfile=char(matfiles{i});
  load(matfile,'Oper');
  lm=length(matfile);
  istart=max(lm-34,1);
  matfile=matfile(istart:lm-4);
    fprintf(fid,'%30s',matfile);
    fprintf(fid,'%6.1f %5i',Oper.Qrel,round(Oper.Wtot));
    fprintf(fid,'%7.3f   ',dr_meas(i),dr_mstab(i),fd_meas(i),fd_mstab(i));
    if nargin>7,
        for j=1:size(drh,2)
            fprintf(fid,'%7.3f   ',drh(i,j));
            fprintf(fid,'%7.3f   ',fdh(i,j));
        end
    end
    fprintf(fid,'\n'); 
end   
fclose(fid);
disp(['Summary printed on ',printfil]);
savfil=[nu,filesep,'matsum'];
save(savfil,'dr_mstab','fd_mstab','dr_meas','fd_meas','matfiles','nu');