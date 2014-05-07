%@(#)   sspristat7.m 1.2	 06/03/22     09:28:19
%
%function sspristat7(matfil,prifil,titel,allss,pool);
function sspristat7(matfil,prifil,titel,allss,pool);
%if nargin<4, allss=0;end
%locat='U-VIKT';
%if allss==1,locat='Location';end
locat='Location';
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
ssloc='';
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
  fprintf(fid,'%s%s%s','  Nr CRID      CRTYP   CRTX     CRTB   CRNX     CRNB   MAXQX    MAXQB  CRAX     CRAB    ',locat,'  Cycles ');
  fprintf(fid,'\n');
  for j=irun:min(irun+onpage-1,nbu)
     chtyp='  -    -';      
     %bunt=ASYTYP(j,:);
%     cycles=['  ',sprintf('%i ',ICYC(j,1:ITOT(j))-1)];
%     cycles=CYCNAM(ICYC(j,1:ITOT(j)),2:size(CYCNAM,2));
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
     if allss>0,
       if ONSITE(j)==0,
         ssloc='Clab';
       elseif lastcyc(j)==lastc,
         ssloc='Core';
       else
         ssloc='Pool';
       end
     else
%       ssloc=sprintf('%7.2f',ASYWEI(j,ITOT(j)));
       ssloc=[upper(pool(1)) pool(2:size(pool,2))];
     end
     fprintf(fid,'%4i%9s%6s  %8.3f%8.2f%8.3f%8.2f%8.3f%8.2f%8.3f%8.2f%7s      %s',j,CRID(j,1:8),CRTYP(j,:),crtx(j),crtb(j),crnx(j),crnb(j),maxqx(j),maxqb(j),crax(j),crab(j),ssloc,cycasc);
     fprintf(fid,'\n');
  end
  irun=irun+onpage;
end
fclose(fid);
