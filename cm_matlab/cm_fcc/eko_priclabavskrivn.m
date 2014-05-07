%@(#)   eko_priclabavskrivn.m 1.1	 98/12/08     14:24:22
%
function eko_priclabavskrivn(eladd,buntot,antal,levyear,meanburn,garburn,...
uttag,garut,restsek,fil,staton,restburn,apris,inkurans)
bunstat=[staton(1),staton(length(staton))];
if nargin<6,
  fil='clab-restvalue.lis';
  disp('Restvalue will be printed on clab-restvalue.lis');
end
if isstr(fil),
  fid=fopen(fil,'w');
  clos=1;
else
  fid=fil;
  clos=0;
end

if nargin>10,
  fprintf(fid,'\n');
  fprintf(fid,'%s\n',staton);
end

if size(restsek,2)==2,
  restsek=restsek(:,1);
end

fprintf(fid,'\n');
fprintf(fid,'Eladd;    Buntyp    ;           Antal;  Lev.;       ;  Gar.;   Uttag;  Garant.;');

if nargin>11
  fprintf(fid,'    Restenergi;   a''pris;      inkurans;');
end
fprintf(fid,'        Lagervärde;\n');

fprintf(fid,'     ;              ;                ;  år  ;   Utbr.;  Utbr.;       ;  uttag;');
if nargin>11
  fprintf(fid,'       GWht;      SEK/GWht;          SEK;');
end
fprintf(fid,'             SEK   ;\n');

fprintf(fid,'     ;              ;                ;      ; MWd/kgU; MWd/kgU;  GWht;   GWh;\n');
ib=size(buntot,1);
for i=1:ib,
  if antal(i)>0,
    rests=[];
    restink=[];
    restsekk=sprintf('%12.3f',restsek(i)*1000);
    aaa=find(restsekk=='.');restsekk(aaa)='';
    siss=size(restsekk,2);
    for iii=siss:-3:3
      rests=[restsekk(1,iii-2:iii),' ',rests];
    end;
  if nargin>11
    restsekk=sprintf('%12.3f',inkurans(i)*1000);
    aaa=find(restsekk=='.');restsekk(aaa)='';
    siss=size(restsekk,2);
    for iii=siss:-3:3
      restink=[restsekk(1,iii-2:iii),' ',restink];
    end;
  end;

   eladdstr=sprintf('%s%i',[bunstat,'E'],eladd(i) );
   if length(buntot(i,:))>5
      fprintf(fid,'%-5s;   %10s;%4i;',eladdstr,buntot(i,:),antal(i));
    else
      fprintf(fid,'%-5s;    %10s;  %10i;',eladdstr,buntot(i,:),antal(i));
    end
    fprintf(fid,'%6i;   %s; %s;',levyear(i), p2c(meanburn(i),'%5.1f'), p2c(garburn(i),'%5.1f'));
    fprintf(fid,'%8i;%8i;',round(uttag(i)*1000),round(garut(i)*1000));
    if nargin>11
       fprintf(fid,'%11i;  %s; %14s;       ',round(restburn(i)*1000),p2c(apris(i),'%9.2f'),restink);
    else
      fprintf(fid,'      ');
    end
    fprintf(fid,'%s;\n',rests);
  end
end
fprintf(fid,'\n');
rests=[];
restsekk=sprintf('%9i',sum(round(restsek*1000000)));
siss=size(restsekk,2);
for iii=siss:-3:3
  rests=[restsekk(1,iii-2:iii),' ',rests];
end;

if nargin>11
  restink=[];
  restsekk=sprintf('%9i',sum(round(inkurans*1000000)));
  siss=size(restsekk,2);
  for iii=siss:-3:3
    restink=[restsekk(1,iii-2:iii),' ',restink];
  end;
end

fprintf(fid,'Totalt:;            ;        %8i;      ;        ;      ;%8i;%8i;', sum(antal), round(sum(uttag)*1000), round(sum(garut)*1000));
if nargin>11
   fprintf(fid,'%11i;  %s; %14s;       ',round(sum(restburn*1000)),p2c(mean(apris),'%9.2f'),restink);
else
  fprintf(fid,'      ');
end

fprintf(fid,'%s;\n',rests);
fprintf(fid,'\n');
if clos==1,
  fclose(fid);
end
