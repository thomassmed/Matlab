%@(#)   restvalue_distfil7.m 1.1	 04/10/20     15:47:29
%
function restSEK=restvalue_distfil7(distfil)
%function restSEK=restvalue_distfil7(distfil)
%
% Calculates the "straight" (i.e. with no consideration of freebundles)
% restvalue for each bundle in the distribution file.  
% Results are also printed on file distfil.lis 
%

prifil='restvalue_distfil7.lis';
fprintf(1,'Results are printed on file %s',prifil);
fprintf(1,'\n');
burnup=mean(readdist7(distfil,'burnup'))*1000;  [asytyp,mminj,konrod,bb,hy,mz,ks,asytyp,bunref,...
  distlist,staton,masfil]=readdist7(distfil,'asytyp');
asyid=readdist7(distfil,'asyid');
staton=[staton,' ',stripfile(distfil)];
reakdir=findreakdir;
batchfile=[reakdir,'div/bunhist/batch-data.txt'];
[eladd,garburn,antal,levyear,enr,buntot]=readbatch(batchfile);
ii=find(batchfile=='/');batchcostfile=[batchfile(1:ii(3)),'div/bunhist/fcc/batchcost.txt'];

[bunto,batchcost]=readcost(batchcostfile);
bpcost=batchcost./(antal+eps);

irad=findeladd(asytyp,buntot,levyear);


restburn=(garburn(irad)-burnup/1000)./garburn(irad);
restSEK=restburn.*bpcost(irad)*1e6;


fid=fopen(prifil,'w');
fprintf(fid,'\n');

fprintf(fid,' Restvalue for file %s',distfil);
fprintf(fid,'\n');
[ierr,direc]=unix('pwd');
fprintf(fid,'Current directory is %s',direc);
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'Ch.no     ASYID    ASYTYP    BURNUP     GARBUR     RESTSEK');
fprintf(fid,'\n');

for i=1:length(burnup),
  garbp=garburn(irad(i));
  fprintf(fid,'%5i %10s %8s %10.1f %10.1f %15.2f',i,asyid(i,:),asytyp(i,:),burnup(i)/1000,garbp,restSEK(i)); 
fprintf(fid,'\n');
end

%@(#)   restvalue_distfil.m 1.3   00/01/03     14:38:46
