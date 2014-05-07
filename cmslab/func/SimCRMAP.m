function SimCRMAP(fid,crmap,crmminj)
crwidth=length(crmminj);
for i=1:crwidth
    if crmminj(i)>1,
        fprintf(fid,'%i*0 ',crmminj(i)-1);
    end
    fprintf(fid,'        ');
    for j=1:crmminj(i)-2,
        fprintf(fid,'    ');
    end
    fprintf(fid,'%3i ',crmap(i,crmminj(i):crwidth-crmminj(i)+1));
    fprintf(fid,'        ')';
    for j=1:crmminj(i)-2,
        fprintf(fid,'    ');
    end
    if crmminj(i)>1,
        fprintf(fid,'%i*0 ',crmminj(i)-1);
    end
    fprintf(fid,'\n');
end
    