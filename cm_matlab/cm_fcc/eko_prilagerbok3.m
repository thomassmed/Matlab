%@(#)   eko_prilagerbok3.m 1.2	 04/10/20     15:26:18
%
%function eko_prilagerbok3(ival,burnup,eladdpat,antotpat,levyearpat,enrpat,weipat,garpat,restsek,fid,staton,BUIDNT,BUNTYP,BURNUP,CYCNAM,ICYC,ITOT,lastcyc,ONSITE,restSEKcyc,cyclesind,bpcost,cond1,cond2,sorton,sekfresh,kinf);
%print result from lagerbok (lagerbstat)
function eko_prilagerbok3(ival,burnup,eladdpat,antotpat,levyearpat,enrpat,weipat,garpat,restsek,fid,staton,BUIDNT,BUNTYP,BURNUP,CYCNAM,ICYC,ITOT,lastcyc,ONSITE,lastc,restSEKcyc,cyclesind,bpcost,cond1,cond2,sorton,sekfresh,kinf);
fprintf(fid,'\n');
fprintf(fid,'%s',' ** The weight is  a meanvalue for specified batch! **');
fprintf(fid,'\n');
fprintf(fid,'%s%s','Conditions for last cycle is ',cond1);
fprintf(fid,'\n');
%%fprintf(fid,'%s%s','Conditions for last of selected cycles is ',cond2);

fprintf(fid,'\n%s',setstr(12));
allfuel=1;
if allfuel==1,locat='Location';end
nbu=length(ITOT);
onpage=45;
[aa eladdindex bb]=find(diff(eladdpat)~=0);
eladdindex=eladdindex(:);
eladdindex=[eladdindex; length(eladdpat)];
ipage=fix((nbu+length(eladdindex)*5)/onpage)+1;
pagenr=0;
irun=1;
beg=1;
j=0;
lin=0;
lostspace=0;
tid=fix(clock);
if tid(2)<10,
  tidstr=sprintf('%6i%s%2.2i%s%2.2i %2.2i%s%2.2i',tid(1),'-',tid(2),'-',tid(3),tid(4),'.',tid(5));
else
  tidstr=sprintf('%6i%s%2.2i%s%2.2i %2.2i%s%2.2i',tid(1),'-',tid(2),'-',tid(3),tid(4),'.',tid(5));
end
%lastc=max(lastcyc);
fuelloc='';
for i=1:ipage,
  pagenr=pagenr+1;
  if pagenr==1,
    fprintf(fid,'%s','');
  elseif  pagenr==ipage
    fprintf(fid,'\n%s',setstr(12));
  else
    fprintf(fid,'\n%s',setstr(12));
  end
  fprintf(fid,'%s%s%s%s%2i',staton,' ',tidstr,'   Page ',pagenr);                              
  fprintf(fid,'\n\n');
  fprintf(fid,'  Nr;ELADD;YEAR;BUIDNT; BUNTYP;     A''PRIS;   Lagervärde;     Weight;    BURNUP;  Garburn;    Khot;    %s;  LastC;', locat);

  if length(cyclesind)<9
    for ind=1:length(cyclesind)
     fprintf(fid,'%s         ',CYCNAM(cyclesind(ind),:));
    end
  end
  fprintf(fid,'\n');

   if strcmp(sorton,'eladd'),
      linespace=length(eladdindex)*5;
   else
      linespace=0;
   end
  while lin<min(irun+onpage,(nbu+linespace))
     j=j+1;
     lin=lin+1;
     chtyp='  -    -';      
     bunt=BUNTYP(j,:);
%     fprintf(fid,'%s','      ');
     if allfuel>0,
       if ONSITE(j)==0,
         fuelloc='Clab';
       elseif lastcyc(j)==lastc,
         fuelloc='Core';
       else
         fuelloc='Pool';
       end
     end

    restsini=[];
    restsekk=sprintf('%12.3f',bpcost(j)*1000);
    aaa=find(restsekk=='.');restsekk(aaa)='';
    siss=size(restsekk,2);
    for iii=siss:-3:3
      restsini=[restsekk(1,iii-2:iii),' ',restsini];
    end;

    rests=[];
    restsekk=sprintf('%12.3f',restsek(j)*1000);
    aaa=find(restsekk=='.');restsekk(aaa)='';
    siss=size(restsekk,2);
    for iii=siss:-3:3
      rests=[restsekk(1,iii-2:iii),' ',rests];
    end;

    

    restcyctemp=[];
    for iji=1:size(restSEKcyc,2)
      restcyc=[];
      restsekk=sprintf('%12.3f',restSEKcyc(j,iji)*1000);
      aaa=find(restsekk=='.');restsekk(aaa)='';
      siss=size(restsekk,2);
      for iii=siss:-3:3
        restcyc=[restsekk(1,iii-2:iii),' ',restcyc];
      end;
      restcyctemp=[restcyctemp restcyc];
    end
    if length(cyclesind)<9
      fprintf(fid,'%4i;%3i;%5i;%7s;%7s;%7s;%7s;%s;%s;%s;%s;  %6s;%8s;%s;', j,eladdpat(j),levyearpat(j),BUIDNT(j,:),BUNTYP(j,:),restsini,rests,p2c(weipat(j),'%11.2f'), p2c(burnup(j),'%10.3f'), p2c(garpat(j),'%9.2f'), p2c(kinf(j),'%9.3f'), fuelloc,CYCNAM(lastcyc(j),:),restcyctemp);
    else
      fprintf(fid,'%4i;%3i;%5i;%7s;%7s;%7s;%7s;%s;%s;%s;%s;   %6s;%8s;', j,eladdpat(j),levyearpat(j),BUIDNT(j,:),BUNTYP(j,:),restsini,rests,p2c(weipat(j),'%11.2f'), p2c(burnup(j),'%10.3f'), p2c(garpat(j),'%9.2f'), p2c(kinf(j),'%9.3f'),fuelloc,CYCNAM(lastcyc(j),:));
    end
    fprintf(fid,'\n');


 if strcmp(sorton,'eladd'),
  
  if j==eladdindex(beg)|j==nbu
    if beg==1
      eladdsum(beg)=sum(restsek(1:eladdindex(beg)));
      garpatsum(beg)=sum(garpat(1:eladdindex(beg)));
      burnupsum(beg)=sum(burnup(1:eladdindex(beg)));
      antel=eladdindex(beg);
    elseif j==nbu
      eladdsum(beg)=sum(restsek(eladdindex(length(eladdindex)-1)+1:nbu));
      garpatsum(beg)=sum(garpat(eladdindex(length(eladdindex)-1)+1:nbu));
      burnupsum(beg)=sum(burnup(eladdindex(length(eladdindex)-1)+1:nbu));
      antel=nbu-eladdindex(length(eladdindex)-1);
    else
      eladdsum(beg)=sum(restsek(eladdindex(beg-1)+1:eladdindex(beg)));
      garpatsum(beg)=sum(garpat(eladdindex(beg-1)+1:eladdindex(beg)));
      burnupsum(beg)=sum(burnup(eladdindex(beg-1)+1:eladdindex(beg)));
      antel=eladdindex(beg)-eladdindex(beg-1);
    end
    rests=[];
    restsekk=sprintf('%12.3f',eladdsum(beg)*1000);
    aaa=find(restsekk=='.');restsekk(aaa)='';
    siss=size(restsekk,2);
    for iii=siss:-3:3
      rests=[restsekk(1,iii-2:iii),' ',rests];
    end;
%    fprintf(fid,'\n%s%5i\t\t\t\t%18s\t%15.3f%9.2f\n\n\n','Total',antel,rests,burnupsum(beg),garpatsum(beg));
    fprintf(fid,'\n Total;%5i; ;       ;       ;            ;%12s;           ;%s;%s;\n\n\n', antel, rests, p2c(burnupsum(beg),'%10.3f'), p2c(garpatsum(beg),'%9.2f'));

    if j~=nbu
      fprintf(fid,'  Nr;ELADD;YEAR;BUIDNT; BUNTYP;     A''PRIS;   Lagervärde;     Weight;    BURNUP;  Garburn;    Khot;    %s;  LastC;\n', locat);
    end
    beg=beg+1;
%    lostspace=lostspace+5;
    lin=lin+5;
   end%if j==eladdindex(beg)|j==nbu
  end%if strcmp(sorton,'eladd'),

 end%while
 irun=irun+onpage;
end
lostspace=0;
rests=[];
restsekk=sprintf('%12.3f',sum(eladdsum*1000)+sum(sekfresh*1000));
aaa=find(restsekk=='.');restsekk(aaa)='';
siss=size(restsekk,2);
for iii=siss:-3:3
  rests=[restsekk(1,iii-2:iii),' ',rests];
end;
fprintf(fid,'\n\n Totalt lagervärde;;; ;       ;            ;%12s;\n\n', rests); 
fclose(fid);

