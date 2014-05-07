% $Id: crwea_run_polca.m 70 2013-08-19 12:48:53Z rdj $
%
function crwea_run_polca(ctrlmode,srcfile,options,compfile,burfile,xefile,savefile,symme,conrod,ktarget,power,flow,tlowp,press)

if exist(xefile)
    [~,mminj,~,~,~,~,~,~,~,~,reactorid]=readdist7(xefile);
else
    error('Can not find distribution file!');
end

fid=fopen(compfile,'w');

fprintf(fid,'TITLE    CRWE Analysis case\n');
fprintf(fid,'SOUFIL   %s\n',srcfile);
fprintf(fid,'PRIFIL   off/print-crwea.txt\n');
fprintf(fid,'IDENT    %s\n',reactorid);
if strcmp(ctrlmode,'er')
    fprintf(fid,'OPTION   %s,FLOSEARCH\n',options);
end
if strcmp(ctrlmode,'vr')
    fprintf(fid,'OPTION   %s,POWSEARCH\n',options);
end
fprintf(fid,'INIT     %s=BASIC,HISTORY\n',burfile);
fprintf(fid,'INIT     %s=XENON,IODINE\n',xefile);
fprintf(fid,'SAVE     %s=POWER,TM\n',savefile);
fprintf(fid,'PRINT    \n');
fprintf(fid,'SYMME    %d\n',symme);
fprintf(fid,'SUMFIL   off/sum-crwea.dat\n');

if size(conrod,2)==2
    mangrpcasestr=sprintf('%d=%d,',conrod');
    fprintf(fid,'CONROD   %s\n',mangrpcasestr(1:end-1));
else
    ascmap=crwd2ascmap(conrod,mminj,80);
    fprintf(fid,'CONROD\n');
    for i=1:size(ascmap,1)
        fprintf(fid,'%s\n',ascmap(i,:));
    end
end

fprintf(fid,'POWER    %3.1f\n',power);
fprintf(fid,'FLOW     %5.0f\n',flow);
fprintf(fid,'TLOWP    %3.1f\n',tlowp);
fprintf(fid,'PRESS    %2.1f\n',press);
fprintf(fid,'KTRGT    %1.5f\n',ktarget);
fprintf(fid,'END      \n');

fclose(fid);

% Run polca
system(['polca ' compfile]);

end
