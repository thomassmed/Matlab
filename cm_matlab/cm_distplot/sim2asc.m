%@(#)   sim2asc.m 1.6	 06/01/12     10:26:36
%
%function sim2asc(simfile,ascfile)
function sim2asc(simfile,ascfile)
load(simfile);
if isempty(sdmfiles), sdmfiles=filenames;end
fid=fopen(ascfile,'w');
s=size(filenames,1);
fprintf(fid,'STEPS\n');
fprintf(fid,'%i\n',s);
fprintf(fid,'BLIST\n');
for i=1:size(blist,1)
  fprintf(fid,'%i\n',blist(i));
end
fprintf(fid,'BOCFILE\n');
fprintf(fid,'%s\n',bocfile);
fprintf(fid,'MANGRPFILE\n');
fprintf(fid,'%s\n',mangrpfile);
fprintf(fid,'CONROD\n');
for i=1:s
  fprintf(fid,'%s\n',conrod(i,:));
end
fprintf(fid,'FILENAMES\n');
for i=1:s
  fprintf(fid,'%s\n',filenames(i,:));
end
fprintf(fid,'SDMFILES\n');
for i=1:s
  fprintf(fid,'%s\n',sdmfiles(i,:));
end
fprintf(fid,'HC\n');
for i=1:s
  fprintf(fid,'%s\n',hc(i,:));
end
fprintf(fid,'POWER\n');
for i=1:s
  fprintf(fid,'%s\n',pow(i,:));
end
fprintf(fid,'TLOWP\n');
for i=1:s
  fprintf(fid,'%s\n',tlowp(i,:));
end
fclose(fid);
