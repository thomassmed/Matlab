%@(#)   pristat.m 1.4	 97/11/05     12:36:43
%
%function prista(matfil,prifil,titel,allfuel);
function prista(matfil,prifil,titel,allfuel);
if nargin<4, allfuel=0;end
locat='SSHIST';
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
  fprintf(fid,'%s%s%s','  Nr BUIDNT BUNTYP SYMPAT   Kinf    BURNUP ',locat,' Cycles ');
  fprintf(fid,'\n');
  for j=irun:min(irun+onpage-1,nbu)
     chtyp='  -    -';      
     bunt=BUNTYP(j,:);
     cycles=['  ',sprintf('%i ',ICYC(j,1:ITOT(j))-1)];
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
       fuelloc=sprintf('%5.3f',SSHIST(j,ITOT(j)));
     end
     fprintf(fid,'%4i%7s%7s%7s%10.5f%7i%6s%s',j,BUIDNT(j,:),BUNTYP(j,:),BUSYM(j,1:6),kinf(j),round(burnup(j)),fuelloc,cycles);
     fprintf(fid,'\n');
  end
  irun=irun+onpage;
end
fclose(fid);
