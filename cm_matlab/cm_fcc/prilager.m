%@(#)   prilager.m 1.2	 94/08/12     12:15:29
%
function prilager(fid,antal,eladd,buntot,garut,uttag,rest,restsek,levyear,enr,titel,kkan);
if nargin<12, kkan=0;end  % if kkan~=0, it is assumed that the printout refers to core
imax=length(eladd);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s\n',titel);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s','       ');
if kkan>0,
  fprintf(fid,'%s','ERS-  LEV.                         GARANT.                           ANDEL');
  fprintf(fid,'\n');
  fprintf(fid,'%s','       ');
  fprintf(fid,'%s','LADD  ');
  AA(fid);
  fprintf(fid,'%s','R  BUNTYP  ANTAL   ANRIKN.  UTTAG     UTTAG    REST    REST   I H');
  AE(fid);
  fprintf(fid,'%s','RD');
  fprintf(fid,'\n');
  fprintf(fid,'%s','       ');
  fprintf(fid,'%s','                           (%)     (TWh)     (TWh)    (TWh)   (MSEK)   (%)  ');
else
  fprintf(fid,'%s','ERS-  LEV.                         GARANT.');
  fprintf(fid,'\n');
  fprintf(fid,'%s','       ');
  fprintf(fid,'%s','LADD  ');
  AA(fid);
  fprintf(fid,'%s','R  BUNTYP  ANTAL   ANRIKN.  UTTAG     UTTAG    REST    REST');
  fprintf(fid,'\n');
  fprintf(fid,'%s','       ');
  fprintf(fid,'%s','                           (%)     (TWh)     (TWh)    (TWh)   (MSEK)');
end
for i=1:imax
  if antal(i)>0,
    if kkan >0,
        perc=100*antal(i)/kkan;
    else
        perc=[];
    end
    fprintf(fid,'\n');
    fprintf(fid,'%s','       ');
    if eladd(i)>9,
      estr=['E',sprintf('%2i',eladd(i))];
    else
      estr=[' E',sprintf('%1i',eladd(i))];
    end
    fprintf(fid,'%3s%5i%7s%7i%8.2f%10.3f%10.3f%10.3f%7.1f%7.1f',estr,levyear(i),buntot(i,:),antal(i),enr(i),garut(i),uttag(i),rest(i),restsek(i),perc);
  end
end
inoll=find(antal==0);
rest(inoll)=zeros(size(inoll));
restsek(inoll)=zeros(size(inoll));
garut(inoll)=zeros(size(inoll));
uttag(inoll)=zeros(size(inoll));
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s','       ');
fprintf(fid,'%s%15i%18.3f%10.3f%10.3f%7.1f','SUMMA  ',sum(antal),sum(garut),sum(uttag),sum(rest),sum(restsek));
fprintf(fid,'\n');
