%@(#)   pristat7.m 1.9	 08/02/11     15:47:45
%
%function pristat7(matfil,prifil,titel,allfuel);
function pristat7(matfil,prifil,titel,allfuel);
if nargin<4, allfuel=0;end
locat='CRHIS ';
if allfuel==1,locat='Location';end
load(matfil);
[dum,dum,dum,dum,dum,dum,dum,dum,dum,dum,staton]=readdist(DISTFIL(1,:));
nbu=length(ITOT);
fid=fopen(prifil,'w');
onpage=50;
ipage=fix(nbu/onpage)+1;
pagenr=0;
irun=1;
tid=fix(clock);
if tid(2)<10,
  tidstr=sprintf('%6i%s%i%s%2i%3i%s%2i',tid(1),'-',tid(2),'-',tid(3),tid(4),'.',tid(5));
else
  tidstr=sprintf('%6i%s%2i%s%2i%3i%s%2i',tid(1),'-',tid(2),'-',tid(3),tid(4),'.',tid(5));
end
lastc=max(lastcyc);
fuelloc='';
for i=1:ipage,
  pagenr=pagenr+1;
  if pagenr==1,
    fprintf(fid,'%s','       ');
  else
    fprintf(fid,'%s','1      ');
  end
  fprintf(fid,'%s%s%s%s%s%s%2i',staton,'  ',titel,' ',tidstr,'   Page ',pagenr);                              
  fprintf(fid,'\n\n');
  fprintf(fid,'%s','      ');
  fprintf(fid,'%s%s%s','  Nr ASYID    ASYTYP SYMPAT   KHOT     BURNUP  ',locat,' Cycles ');
  fprintf(fid,'\n');
  for j=irun:min(irun+onpage-1,nbu)
     chtyp='  -    -';      
     bunt=ASYTYP(j,:);
%     cycles=['  ',sprintf('%i ',ICYC(j,1:ITOT(j))-1)];
     if ((CYCNAM(ICYC(j,1:ITOT(j)),1)=='C') | (CYCNAM(ICYC(j,1:ITOT(j)),1)=='c')),
       cycles=CYCNAM(ICYC(j,1:ITOT(j)),2:size(CYCNAM,2));
     else
       cycles=CYCNAM(ICYC(j,1:ITOT(j)),1:size(CYCNAM,2));
     end
     cycasc=[];
     for k=1:size(cycles,1)
       cycasc=cat(2,cycasc,[deblank(cycles(k,:)) ' ']);
     end
     fprintf(fid,'%s','      ');
     if allfuel>0,
       if ONSITE(j)==0,
         fuelloc='Clab';
       elseif lastcyc(j)==lastc,
         fuelloc='Core';
       else
         fuelloc='Pool';
       end
     else
      fuelloc=sprintf('%7.2f',CRHIS(j,ITOT(j)));
%      fuelloc=sprintf('%7.2f',ASYWEI(j,ITOT(j)));
    end
%     fprintf(fid,'%4i%7s%7s%7s%10.5f%7i%7s%s',j,ASYID(j,:),ASYTYP(j,:),BUSYM(j,1:6),khot(j),round(burnup(j)),fuelloc,cycles);
     fprintf(fid,'%4i%9s%5s%9s%10.5f%7i%8s  %s',j,ASYID(j,1:8),ASYTYP(j,:),BUSYM(j,1:7),khot(j),round(burnup(j)),fuelloc,cycasc);
     fprintf(fid,'\n');
  end
  irun=irun+onpage;
end
fclose(fid);
