function java_start_casmo(cn,option,neulib,version)

global cs;


caifile = cs.s(cn).caifile;
[pathstr, ~, ~] = fileparts(caifile);
startfile=sprintf('%s%s',pathstr,'/start_casmo');
fid = fopen(startfile,'w');
fprintf(fid,'#!/bin/bash\n');
fprintf(fid,'cd %s\n',pathstr);
fprintf(fid,'cas4 %s -N %s -V %s %s',option,neulib,version,caifile);
fclose(fid);
startcasmo=strcat(startfile,'&');
system(startcasmo);
end





