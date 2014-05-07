function prt_tip(tipstat,titel,prtfile)
% prt_tip(tipstat[,title,prtfile])
% See also tip_stat
ntip=length(tipstat.RmsNodal);
if nargin<2,
    for i=1:ntip,
        titel{i}=sprintf('%i',i);
    end
end
if nargin<3, 
    prtfile='tipsum.txt';
    fprintf(1,'Tip summaries printed on %s \n',prtfile);
end
fid=fopen(prtfile,'w');
for i=1:ntip,
fprintf(fid,'\n');
fprintf(fid,'Summary %s \n',titel{i});
fprintf(fid,'Overall Statistics %s     Nodal  Axial Radial \n','%');
fprintf(fid,'RMS of difference  :     %5.1f  %5.1f  %5.1f \n',tipstat.RmsNodal(i),tipstat.RmsAxial(i),tipstat.RmsRadial(i));
fprintf(fid,'Average difference :     %5.1f  %5.1f  %5.1f \n',tipstat.AvDiffNodal(i),tipstat.AvDiffAxial(i),tipstat.AvDiffRadial(i));
fprintf(fid,'Maximum difference :     %5.1f  %5.1f  %5.1f \n',tipstat.MaxDiffNodal(i),tipstat.MaxDiffAxial(i),tipstat.MaxDiffRadial(i));
end
fclose(fid);