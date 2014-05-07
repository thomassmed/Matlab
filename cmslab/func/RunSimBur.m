fid=fopen('sim-test.inp','w');
%% Las in data
logdata=lngsum2mlab('sum-data.dat');
[konrods,dm]=crpos2mlab;
resinfo=ReadCore('../c31/res/tip-130212.res');
mminj=resinfo.core.mminj;
crmminj=resinfo.core.crmminj;
% [dum,mminj]=readdist7('tip/tip-130320-base.dat');
% crmminj=mminj2crmminj(mminj);
%% resten
lgsta=3216;
lgsto=4702;
efph=logdata(7,lgsta:lgsto);
qrel=logdata(8,lgsta:lgsto);
hc=logdata(9,lgsta:lgsto);
crsum=logdata(10,lgsta:lgsto);
Tin=logdata(11,lgsta:lgsto);
tit=''' F2 C31 31S-01- ';
hcrel=100*hc/11000;
%%
refnum=regexp(sprintf('%02i%02i%02i ',logdata(2:4,lgsta:lgsto)), ' ', 'split');
refnum=refnum(1:end-1);
%%
tid=datenum(logdata(1:6,lgsta:lgsto)');
Mars=[20:22 25:27];
April=[2:5 8:12 24:26 29:30];
Maj=[2:3 6:10 13:17 20];
Marsdat=zeros(length(Mars),6);
Marsdat(:,1)=2013;Marsdat(:,1)=2013;Marsdat(:,2)=3;Marsdat(:,3)=Mars';Marsdat(:,4)=10;
Marstid=datenum(Marsdat);
Aprildat=zeros(length(April),6);
Aprildat(:,1)=2013;Aprildat(:,1)=2013;Aprildat(:,2)=4;Aprildat(:,3)=April';Aprildat(:,4)=10;
Apriltid=datenum(Aprildat);
Majdat=zeros(length(Maj),6);
Majdat(:,1)=2013;Majdat(:,1)=2013;Majdat(:,2)=5;Majdat(:,3)=Maj';Majdat(:,4)=10;
Majtid=datenum(Majdat);

Spartid=[Marstid;Apriltid;Majtid];
%% Exakt Spartid
for i=1:length(Spartid), 
    [dum,ii(i)]=min(abs(Spartid(i)-tid));
    Spartid(i)=tid(ii(i));
end
Spardatvec=datevec(Spartid);
for i=1:length(Spartid),
    temp=[Spardatvec(i,1:3) Spardatvec(i,4)+round(Spardatvec(i,5)/60)];
    Spardatstr{i}=sprintf('%i-%i-%i-%i',temp);
end
%%
crpattern=zeros(length(crsum),size(konrods,2));
dif=zeros(size(crsum));
imin=dif;
for i=1:length(crsum)
    [dif(i),imin(i)]=min(abs(crsum(i)-dm));
    crpattern(i,:)=konrods(imin(i),:);
end
%%
SimBur(fid,crpattern,qrel,hc,hcrel,Tin,efph,tit,mminj,crmminj,refnum,tid,Spartid,Spardatstr)
fclose(fid);

