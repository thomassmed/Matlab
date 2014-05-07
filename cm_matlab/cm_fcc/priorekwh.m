%@(#)   priorekwh.m 1.7	 98/04/02     10:16:17
%
function priorekwh(fid,antal,orekWh,orekWhtot,eladd,levyear,buntot,garburn,burneladd,Dburneladd,kkan,TWh,kostnad,nomkostnad,eta,distfil1,distfil2);
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s','    ');
if nargin>15,
  fprintf(fid,'%s',distfil1,'--->',distfil2);
  fprintf(fid,'\n');
end
fprintf(fid,'%s','    ');
fprintf(fid,'%s%7.3f%s','Total produktion under perioden: ',TWh,' TWhe');
if nargin>16,
  fprintf(fid,'\n%s','    ');
  fprintf(fid,'%s%7.2f%s','Verkningsgrad: ',1e5*eta,' %');
end  
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s','    ');
fprintf(fid,'%s','Ers-  Lev.             Garant. Total  Period   Spec.             ');
OE(fid);
fprintf(fid,'%s','ver-');
fprintf(fid,'\n');
fprintf(fid,'%s','    ');
fprintf(fid,'%s','ladd  ');aa(fid);                                         
fprintf(fid,'%s','r Buntyp   Antal  utbr. utbr.  utbr     kostn    Kostnad  utnyttj.');
fprintf(fid,'\n');
fprintf(fid,'%s','    ');
fprintf(fid,'%s','                       MWd/tU MWd/tU  MWd/tU  SEK/MWh       SEK     SEK');
imax=length(eladd);
deltakost=nomkostnad-kostnad;
deltakost=max(deltakost,0);
for i=1:imax
 if antal(i)>0,
   fprintf(fid,'\n');
   fprintf(fid,'%s','    ');
   if eladd(i)>9,
     estr=['E',sprintf('%2i',eladd(i))];
   else
     estr=[' E',sprintf('%1i',eladd(i))];
   end
   fprintf(fid,'%3s%5i%9s%5i%7.1f%7.1f%7.1f%10.2f%10.0f%9.0f',estr,levyear(i),buntot(i,:),antal(i),garburn(i),burneladd(i),Dburneladd(i),10*orekWh(i),1e6*kostnad(i),1e6*deltakost(i));
 end
end
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s','    ');
fprintf(fid,'%s%9.2f%s','Genomsnittlig kostnad: ',10*orekWhtot,' SEK/MWh');
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%s','            ');
fprintf(fid,'%s%9i%s','Total kostnad: ',round(1e7*orekWhtot*TWh),' SEK');
fprintf(fid,'%s%.1f%s','  (',10*orekWhtot*TWh,' MSEK)');
fprintf(fid,'\n');
fprintf(fid,'%s','  V');ae(fid);
fprintf(fid,'%s','rde ');OE(fid);
fprintf(fid,'%s','verutnytt. br');ae(fid);
fprintf(fid,'%s%7.1f%s','nsle: ',sum(deltakost),' MSEK');
fprintf(fid,'\n');

