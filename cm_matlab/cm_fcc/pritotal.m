%@(#)   pritotal.m 1.2	 94/08/12     12:15:33
%
function pritotal(fid,eladd,levyear,enr,buntot,garburn,burncor,burnpool,burnclab,antal,ancor,anpool,antorrf,anclab,titel)
imax=length(eladd);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s\n',titel);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s','       ');
fprintf(fid,'%s','ERS-  LEV.              TOTAL  GAR.   HARD   HARD   BASS.  BASS.   CLAB  CLAB  OBESTR');
fprintf(fid,'\n');
fprintf(fid,'%s','       ');
fprintf(fid,'%s','LADD  AR   ANR. BUNTYP  ANTAL  UTBR   ANTAL  UTBR   ANTAL  UTBR    ANTAL UTBR  ANTAL');
fprintf(fid,'\n');
fprintf(fid,'%s','       ');
fprintf(fid,'%s','           w%                  MWd           MWd           MWd           MWd    ');
for i=1:imax
    fprintf(fid,'\n');
    fprintf(fid,'%s','       ');
    if eladd(i)>9,
      estr=['E',sprintf('%2i',eladd(i))];
    else
      estr=[' E',sprintf('%1i',eladd(i))];
    end
    fprintf(fid,'%3s%5i%6.2f%7s%7i%7.1f%7i%7.1f%7i%7.1f%7i%7.1f%7i',estr,levyear(i),enr(i),buntot(i,:),antal(i),garburn(i),ancor(i),burncor(i),anpool(i),burnpool(i),anclab(i),burnclab(i),antorrf(i));
end
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s','       ');
fprintf(fid,'%s%23i%14i%14i%14i%14i','SUMMA',sum(antal),sum(ancor),sum(anpool),sum(anclab),sum(antorrf));
fprintf(fid,'\n');
end
