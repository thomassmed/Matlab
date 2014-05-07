%@(#)   restvalue7_asyid.m 1.3	 05/07/01     15:31:07
%
%@(#)   restvalue7_asyid.m 1.4	 00/08/10     12:16:11
%
%function [iut,rest]=restvalue(distfile1,distfile2,khotlim)

function [iut,rest]=restvalue(x1,x2,x3);

distfile=x1;
distfile2=x2;
buid1=readdist(distfile,'asyid');
buid2=readdist(distfile2,'asyid');
kkan=size(buid1,1);
[from,to,ready,fuel]=initvec(buid1,buid2,ones(kkan,1));
iut=find(to==0);
 
khotlim=x3;
khot=readdist7(distfile,'khot');
ik=(khot>khotlim)';
iut=find(to+ik==0);
    
burnup=mean(readdist(distfile,'burnup'))'*1000;
[asytyp,mminj,konrod,bb,hy,mz,ks,asytyp,bunref,...
distlist,staton,masfil]=readdist(distfile,'asytyp');
staton=[staton,' ',stripfile(distfile2),' - ',stripfile(distfile)];
reakdir=findreakdir;
batchfile=[reakdir,'div/bunhist/batch-data.txt'];
burnup=burnup(iut)';	
asytyp=asytyp(iut,:);
asyid=buid1(iut,:);
khot=(khot(iut));
[eladd,garburn,antal,levyear,enr,buntot]=readbatch(batchfile);
ii=find(batchfile=='/');batchcostfile='fcc/batchcost.txt';
[bunto,batchcost]=readcost(batchcostfile);
bpcost=batchcost./(antal+eps);
irad=findeladd(asytyp,buntot,levyear);
restburn=(garburn(irad)-burnup/1000)./garburn(irad);
restsek=restburn.*bpcost(irad)*1e6;
po=find(restsek<0);
restsek(po)=0;
rest=round(sum(restsek));

prifil='restvalue_asyid.lis';
fid=fopen(prifil,'w');
fprintf(fid,'\n');

fprintf(fid,distfile  ,'-',distfile2);
fprintf(fid,'\n');
[ierr,direc]=unix('pwd');
fprintf(fid,'Current directory is %s',direc);
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,' NR      asyid    asytyp     BURNUP     GARBURN      khot       RESTSEK');
fprintf(fid,'\n');

for i=1:length(burnup),
  garbp=garburn(irad(i));
  fprintf(fid,'%3i %10s %8s %10.1f %10.1f %12.3f %12.2f %12.2f',i,asyid(i,:),asytyp(i,:),burnup(i)/1000,garbp,khot(i),restsek(i)); 
fprintf(fid,'\n');
end
fprintf(fid,'\n');
fprintf(fid,'                                        summa restvärde %15.0f',rest');
fclose(fid);

disp([batchfile,' and ',batchcostfile,' have been used']);
disp('A summary of the results will be printed on restvalue_asyid.lis');
