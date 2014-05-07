%@(#)   brprog.m 1.2	 98/12/16     15:31:26
%
%function brprog(infil,utfil)
% funktion för bränslekostnadsprognos.
% körs från /cm/fx/fcp
% använder indata från /cm/fx/fcp/indata_prog.txt som default
function brprog(infil,utfil)
if nargin<1, infil='indata_prog.txt'; end
if nargin<2, utfil='brprog.lis'; end
reakdir=findreakdir;
infil=[reakdir,'fcp/',infil];
[s,date]=unix('date');
fid=fopen(utfil,'w');
tx=readtextfile(infil);
s=size(tx);
i=bucatch('ANAFIL',tx(:,1:6));
anafil=remblank(tx(i,7:s(2)));
i=bucatch('STAFIL',tx(:,1:6));
stafil=remblank(tx(i,7:s(2)));
i=bucatch('VERKN',tx(:,1:5));
verkn=str2num(remblank(tx(i,7:s(2))));
i=bucatch('TITLE',tx(:,1:5));
title=tx(i,7:s(2));
fprintf(fid,'\n%s\n\n%s',title,date);
i=bucatch('NOMPOW',tx(:,1:6));
nompow=str2num(remblank(tx(i,7:s(2))));
gwh2efph=1e5/(verkn*nompow);
txa=readtextfile(anafil);
san=size(txa);
i=bucatch('COMPLE',txa(:,1:6));
comple=remblank(txa(i,7:s(2)));
ini=bucatch('INIT',txa(:,1:4));
sav=bucatch('SAVE',txa(:,1:4));
ref=bucatch('REFUEL',txa(:,1:6));
i=bucatch('LADDFU',tx(:,1:6));
for j=1:length(i)
  text=remblank(tx(i(j),7:s(2)));
  b=find(text==',');
  year(j)=str2num(text(1:b(1)-1));
  cyc(j,1:b(2)-b(1)-1)=text(b(1)+1:b(2)-1);
  ant(j)=str2num(text(b(2)+1:b(3)-1));
  bun(j,1:b(4)-b(3)-1)=text(b(3)+1:b(4)-1);
  vprod(j)=str2num(text(b(4)+1:b(5)-1));
  hprod(j)=str2num(text(b(5)+1:size(text,2)));
  if j>1, stafil=['eo' remblank(cyc(j-1,:)) '_prog.dat'];end
  init=['INIT     ' stafil];
  txa(ini,:)=setstr(32*ones(1,san(2)));
  txa(ini,1:length(init))=init;
  savfil=['bo' remblank(cyc(j,:)) '_prog.dat'];
  save=['SAVE     ' savfil];
  txa(sav,:)=setstr(32*ones(1,san(2)));
  txa(sav,1:length(save))=save;
  refuel=sprintf('%s%i%s%s','REFUEL   RANK,',ant(j),',',bun(j,1:b(4)-b(3)-1));
  txa(ref,:)=setstr(32*ones(1,san(2)));
  txa(ref,1:length(refuel))=refuel;
  anafil=sprintf('%s%i%s','ana_prog',year(j),'.txt');
  writxfile(anafil,txa);
  evstr=sprintf('%s %s %s','!cp',anafil,'ana.txt');
  eval(evstr)
  !anaload ana.txt
  [iut,rest]=restvalue(stafil,savfil,0.93,0);
  if j==1,fprintf(fid,'\n\n19%i\n%s',year(j),'====');end
  fprintf(fid,'\n\n%s%4i','Antal färska knippen vid bränslebyte',ant(j));
  fprintf(fid,'\n\n%s%4.1f%s','Avskrivning vid rev',rest,' MSEK');
  txc=readtextfile(comple);
  in=bucatch('INIT',txc(:,1:4));
  sa=bucatch('SAVE',txc(:,1:4));
  eoyfil=sprintf('%s%i%s','comp_eoy',year(j),'.txt');
  evstr=['!cp ' comple ' ' eoyfil];
  eval(evstr);
  txy=readtextfile(eoyfil);
  sy=size(txy);
  initfil=['bo' remblank(cyc(j,:)) '_prog.dat'];
  init=sprintf('%s%s%s','INIT      ',initfil,' = BURNUP,BUIDNT');
  txy(in,:)=setstr(32*ones(1,sy(2)));
  txy(in,1:length(init))=init;
  txy(sa,:)=setstr(32*ones(1,sy(2)));
  savefil=sprintf('%s%i%s','eoy',year(j),'_prog.dat');
  save=sprintf('%s%s%s','SAVE      ',savefil,' = BURNUP,POWER,BUIDNT');
  txy(sa,1:length(save))=save;
  burnup=sprintf('%s%5.0f','BURNUP    ',hprod(j)*gwh2efph);
  txy(sy(1),:)=setstr(32*ones(1,sy(2)));
  txy(sy(1),1:length(burnup))=burnup;
  txy(sy(1)+1,1:3)='END';
  writxfile(eoyfil,txy);
  evstr=['!cp ' eoyfil ' comp_work.txt'];
  eval(evstr)
  !polca comp_work.txt
  [TWh,orekWhtot]=fuelcost(initfil,savefil,hprod(j)/1000);
  fprintf(fid,'\n\n%s%6.1f%s','Total bränslekostnad efter rev',10*orekWhtot*TWh,' MSEK');
  fprintf(fid,'\n%s%5i%4s','Planerad produktion',hprod(j),'GWh');
  fprintf(fid,'\n%s%6.2f%s%','Specifik bränslekostnad efter rev',orekWhtot,' öre/kWh');
  if j~=length(i)
    eocfil=sprintf('%s%s%s','comp_eo',remblank(cyc(j,:)),'.txt');
    evstr=['!cp ' comple ' ' eocfil];
    eval(evstr);
    txc=readtextfile(eocfil);
    sc=size(txc);
    txc(in,:)=setstr(32*ones(1,sc(2)));
    txc(sa,:)=setstr(32*ones(1,sc(2)));
    initfil=sprintf('%s%i%s','eoy',year(j),'_prog.dat');
    init=sprintf('%s%s%s','INIT      ',initfil,' = BURNUP,BUIDNT');
    txc(in,1:length(init))=init;
    savefil=['eo' remblank(cyc(j,:)) '_prog.dat'];
    save=sprintf('%s%s%s','SAVE      ',savefil,' = BURNUP,POWER,BUIDNT');
    txc(sa,1:length(save))=save;
    text=remblank(tx(i(j+1),7:s(2)));
    vprod(j+1)=str2num(text(b(4)+1:b(5)-1));
    burnup=sprintf('%s%5.0f','BURNUP    ',vprod(j+1)*gwh2efph);
    txc(sc(1),:)=setstr(32*ones(1,sc(2)));
    txc(sc(1),1:length(burnup))=burnup;
    txc(sc(1)+1,1:3)='END';
    writxfile(eocfil,txc);
    evstr=['!cp ' eocfil ' comp_work.txt'];
    eval(evstr)
    !polca comp_work.txt
    year(j+1)=str2num(text(1:b(1)-1));
    [TWh,orekWhtot]=fuelcost(initfil,savefil,vprod(j+1)/1000);
    fprintf(fid,'\n\n\n%s%i','19',year(j+1));
    fprintf(fid,'\n%s','====');
    fprintf(fid,'\n\n%s%6.1f%s','Total bränslekostnad före rev',10*orekWhtot*TWh,' MSEK');
    fprintf(fid,'\n%s%5i%4s','Planerad produktion',vprod(j+1),'GWh');
    fprintf(fid,'\n%s%6.2f%s','Specifik bränslekostnad före rev',orekWhtot,' öre/kWh');
  end
end
fclose(fid);
