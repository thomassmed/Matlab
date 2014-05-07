function lista=hittadatafiler(lista)
if nargin==0, lista=cell(0,0);end
datafiler=dir('*.racs');
curdir=pwd;
il=length(lista);
if ~isempty(datafiler)
    for i=1:length(datafiler),
        il=il+1;
        lista{il,1}=[curdir,filesep,datafiler(i).name];
    end
end
%%
dirs=dir;
iremove=[];
for i=1:length(dirs),
    if ~dirs(i).isdir, iremove=[iremove;i];end
    if strncmp(dirs(i).name(1),'.',1), iremove=[iremove;i];end
end
dirs(iremove)=[];
%% 
for i=1:length(dirs),
    cd(dirs(i).name)
    lista=hittadatafiler(lista);
    cd ..
end
%%

