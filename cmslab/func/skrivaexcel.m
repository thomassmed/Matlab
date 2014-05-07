%% Script för att skapa Excel-fil
clear Prov Effekt Datum Typ 
irem=[];
for i=1:length(lista)
    ac=strfind(lista{i},'AC');
    bd=strfind(lista{i},'BD');
    if ~isempty(ac)
        irem=[irem i];
    elseif ~isempty(bd)
        irem=[irem i];
    end
end
lista(irem)=[];
for i=1:length(lista)
    pI=strfind(lista{i},'PI');
    Prov{i,1}=lista{i}(pI:pI+5);
end
for i=1:length(lista)
    prc=strfind(lista{i},'%');
    backslsh=strfind(lista{i},'\');
    ib=find(backslsh-prc(1)>0,1,'first')-1;
    Effekt{i,1}=lista{i}(backslsh(ib)+1:prc);
    Effekt{i}=strrep(Effekt{i},',','.');
end

for i=1:length(lista)
    sinus=strfind(lista{i},'Sinus');
    steg=strfind(lista{i},'Steg');
    if ~isempty(sinus)
        Typ{i,1}='Sinus';
    elseif ~isempty(steg)
        Typ{i,1}='Steg';
    else
        Typ{i,1}='';
    end
end


for i=1:length(lista)
    idat=strfind(lista{i},'.dat');
    Datum{i,1}=lista{i}(idat-17:idat-8);
end



%%
xlswrite('datafiler',Typ,'Sheet1','C2')
xlswrite('datafiler',Effekt,'Sheet1','B2')
xlswrite('datafiler',Prov,'Sheet1','A2')
xlswrite('datafiler',Datum,'sheet1','D2')
xlswrite('datafiler',lista,'sheet1','E2');
Rubriker={'Prov','Effekt','Typ','Datum','Filnamn','Reell Effekt','HC-Flöde','Tryck','Mavatemperatur','Inloppstemperatur','Pumpvarvtal','Summa Mavaflöde'};
xlswrite('datafiler',Rubriker,'Sheet1','A1')

%%
for i=1:length(lista)
    tabort=strfind(lista{i},'\');
    pathen{i,1}=lista{i}(1:tabort(end)-1);
end
pathenu=unique(pathen);
for i=1:length(pathenu)
    dir2=pathenu{i}; %matdatorn
    %[data,t,ttid,pid,point_desc]=ReadMVD(dir1);
    temp=dir([dir2,'\FTTPPXXX1_*.dat']); 
    file=[dir2,filesep,temp.name];
    temp1=dir([dir2,'\FTTPPXXX2_*.dat']); 
    file1=[dir2,filesep,temp1.name];
    if ~isempty(temp)
        ds=ReadMatdataFil(file);
    end
    ds1=ReadMatdataFil(file1);
    t1=ds.data(1:1000,1);
    t2=ds.data(:,1);
    index=get_index_from_matfile(ds1.signaler,'531K081');
    effektinit=ds1.data((1:1000),index);
    Effektm{i,1}=mean(effektinit);
    index1=get_index_from_matfile(ds.signaler,'211K035');
    HC=ds.data((1:1000),index1);
    HCm{i,1}=mean(HC);
    index2=get_index_from_matfile(ds.signaler,'211K551');
    Inloppstemperatur=ds.data((1:1000),index2);
    Inloppstemperaturm{i,1}=mean(Inloppstemperatur);
    index3=get_index_from_matfile(ds1.signaler,'415K501');
    Mavatemperatur=ds1.data((1:1000),index3);
    Mavatemperaturm{i,1}=mean(Mavatemperatur);
    index4=get_index_from_matfile(ds1.signaler,'313K821');
    PumpVarvtal=ds1.data((1:1000),index4);
    PumpVarvtalm{i,1}=mean(PumpVarvtal);
    index5=get_index_from_matfile(ds.signaler,'211K101');
    Tryck=ds.data((1:1000),index5);
    Tryckm{i,1}=mean(Tryck(:,1));
    index6=get_index_from_matfile(ds1.signaler,'415K031');
    SummaMavaflode=ds1.data((1:1000),index6);
    SummaMavaflodem{i,1}=mean(SummaMavaflode);
end   
Effektm
HCm
Inloppstemperaturm
Mavatemperaturm
PumpVarvtalm
Tryckm
SummaMavaflodem
b=length(pathen);
Effektm1=cell(1,b)';
HCm1=cell(1,b)';
Inloppstemperaturm1=cell(1,b)';
Mavatemperaturm1=cell(1,b)';
PumpVarvtalm1=cell(1,b)';
Tryckm1=cell(1,b)';
SummaMavaflodem1=cell(1,b)';
Inloppstemperaturm1=cell(1,b)';
for i=1:length(pathenu)
    varfin=find(~cellfun(@isempty,strfind(pathen,pathenu{i})));
    Effektm1{varfin(1)}=Effektm{i};
    HCm1{varfin(1)}=HCm{i};
    Mavatemperaturm1{varfin(1)}=Mavatemperaturm{i};
    PumpVarvtalm1{varfin(1)}=PumpVarvtalm{i};
    Tryckm1{varfin(1)}=Tryckm{i};
    SummaMavaflodem1{varfin(1)}=SummaMavaflodem{i};
    Inloppstemperaturm1{varfin(1)}=Inloppstemperaturm{i};
end
xlswrite('datafiler',Effektm1,'Sheet1','F2')
xlswrite('datafiler',HCm1,'Sheet1','G2')
xlswrite('datafiler',Tryckm1,'Sheet1','H2')
xlswrite('datafiler',Mavatemperaturm1,'Sheet1','I2')
xlswrite('datafiler',Inloppstemperaturm1,'Sheet1','J2')
xlswrite('datafiler',PumpVarvtalm1,'Sheet1','K2')
xlswrite('datafiler',SummaMavaflodem1,'Sheet1','L2')

