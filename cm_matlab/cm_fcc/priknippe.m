%@(#)   priknippe.m 1.3	 97/11/05     12:36:04
%
function priknippe(buidnt,buntyp,busym,kinf,burnup,cycnam,itot,loc,distfil,fid)
if nargin<10, fid=1;end
[dum,dum,dum,dum,dum,dum,dum,dum,dum,dum,staton]=readdist(distfil);
locat='LOCATION';
nbu=size(buidnt,1);
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
fuelloc='';
for i=1:ipage,
  pagenr=pagenr+1;
  if pagenr==1,
    fprintf(fid,'%s','       ');
  else
    fprintf(fid,'%s','1      ');
  end
  fprintf(fid,'%s%s%s%s%2i',staton,' Selected bundle(s) ',tidstr,'   Page ',pagenr);                              
  fprintf(fid,'\n\n');
  fprintf(fid,'%s','      ');
  fprintf(fid,'%s%s','  Nr BUIDNT BUNTYP   SYMPAT   Kinf    BURNUP Cycle Cytot ',locat);
  fprintf(fid,'\n');
  for j=irun:min(irun+onpage-1,nbu)
     chtyp='  -    -';      
     cycle=cycnam(j,:);
     fprintf(fid,'%s','      ');
     if loc==0,
       fuelloc='Clab';
     elseif loc==2,
       fuelloc='Core';
     elseif loc==1,
       fuelloc='Pool';
     end
     fprintf(fid,'%4i%7s%7s%9s%10.5f%7i%7s%4i%6s',j,buidnt(j,:),buntyp(j,:),busym(j,:),kinf(j),round(burnup(j)),cycnam(j,:),itot(j),fuelloc);
     fprintf(fid,'\n');
  end
  irun=irun+onpage;
end
end
