function file=get_file(file1,file2)
%%
file1=strrep(file1,'\','/');
file2=strrep(file2,'\','/');
Slash1=strfind(file1,'/');
Slash2=strfind(file2,'/');
%%
cleanpath1=file1(Slash1(1):Slash1(end));
cleanpath2=file2(Slash2(1):Slash2(end));
cSlash1=strfind(cleanpath1,'/');
cSlash2=strfind(cleanpath2,'/');
for i=1:length(Slash1)-2,
    ifound=strfind(cleanpath1(cSlash1(i):cSlash1(i+2)),cleanpath2(cSlash2(1):cSlash2(end)));
    if ifound;break;end
end
%%
if ~ifound
    file=file2;
    return
else
    istart=i;
    istop=i+2;
    for i=istop+1:length(cSlash2),
        if strfind(cleanpath1(cSlash1(istart):cSlash1(i)),cleanpath2);
           newstop=i;
        else
            break;
        end
    end
    istop=newstop;
    file=[file2(1:Slash2(ifound)-1),cleanpath1(Slash1(istart):Slash2(istop)),file1(Slash2(istop)+1:end)];
    file=strrep(file,'/',filesep);
end