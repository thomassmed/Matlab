%dir1='C:\PowerUprate\Provprogram\Blandade MVD filer från flera prov\AC\2013_04_09_1400'; %MVD
%dir2='C:\PowerUprate\Provprogram\PI 608\Sinus\117.5%\8 mHz'; %matdatorn
dir1=dir('AC*')
[data,t,ttid,pid,point_desc]=ReadMVD(dir1.name);
temp=dir('FTTPPXXX2_*'); 
file=temp.name;
ds=ReadMatdataFil(file);
%%
t1=ds.data(:,1);
index=get_index_from_matfile(ds.signaler,'531K951');
y1=ds.data(:,index);
y=data(:,1);
[o,to]=max(y);
[o1,to1]=max(y1);
delta1=t(to)-t1(to1);
%t1=t1+delta1;
[u,tu]=min(y);
[u1,tu1]=min(y1);
delta2=t(tu)-t1(tu1);
%% t1=t1+delta2
options=optimset;
options.Display='iter';
delta=fminbnd(@passaihop,-abs(delta1)-1,-abs(delta1)+1,options,y,t,y1,t1);
%delta=fminbnd(@passaihop,-654,-650,options,y,t,y1,t1);
figure
plot(t+delta,y) 
hold on
plot(t1,y1,'r')
title('delta')
title(['delta = ',sprintf('%7.2f',delta)]);
shg
options1=optimset;
options1.Display='iter';
deltaa=fminbnd(@passaihop,320,300,options,y,t,y1,t1);
figure
%%
deltaa=-310;
hold off
plot(t+deltaa,y) 
hold on
plot(t1,y1,'r')
title(['deltaa = ',sprintf('%7.2f',deltaa)]);
shg
%%

%700mHz unt 800mHz no match pi658 21 mars
%1000mHz suspect pa match - 16.46 AC, not sure though