f2dnew
%hitta hc-flode i datan
%hitta effekt
%plot(hc-flode,effekt)
%211K035 hc-flode
<<<<<<< .mine
dir1='C:\PowerUprate\Provprogram\PI660\115%\LTRV stängn\T21';
dir1=pwd;
temp=dir([dir1,'\FTTPPXXX1_*']); 
file=[dir1,filesep,temp.name];
=======
%dir1='C:\PowerUprate\Provprogram\PI660\115%\LTRV stängn\T21';
temp=dir('FTTPPXXX1_*'); 
file=temp.name;
>>>>>>> .r442
ds=ReadMatdataFil(file);
indexNF=get_index_from_matfile(ds.signaler,'531K081');
indexHC=get_index_from_matfile(ds.signaler,'211K035');
nf=ds.data(:,indexNF);
hc=ds.data(:,indexHC);
f2dnew
plot(hc,nf,'linewidth',2);

shg