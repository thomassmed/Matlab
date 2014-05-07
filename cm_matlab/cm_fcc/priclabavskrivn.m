%@(#)   priclabavskrivn.m 1.3	 94/08/12     12:15:26
%
function priclabavskrivn(buntot,antal,levyear,meanburn,garburn,uttag,garut,restsek,fil,staton)
if nargin<9,
  fil='clab-restvalue.lis';
  disp('Restvalue will be printed on clab-restvalue.lis');
end
if isstr(fil),
  fid=fopen(fil,'w');
  clos=1;
else
  fid=fil;
  clos=0;
end
if nargin>9,
  fprintf(fid,'\n');
  fprintf(fid,'\t%s',staton);
  fprintf(fid,'\n');
end
if size(restsek,2)==2,
  restsek=restsek(:,1);
end
fprintf(fid,'\n');
fprintf(fid,'%12s\t%s\t%s\t%s\t%s\t%s\t%s\t%s','Buntyp','Antal','Lev.','Utbr.','Gar. ','Uttag','Garant.','Restv');
ae(fid);fprintf(fid,'%s','rde');
fprintf(fid,'\n');
fprintf(fid,'%12s\t%s\t%s','      ','     ',' ');aa(fid);
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\n','r','MWd/tU','Utbr.','GWh  ','uttag  ','kSEK     ');
fprintf(fid,'%12s\t%s\t%s\t%s\t%s\t%s\t%s\n','     ','    ','    ','      ','MWd/tU','   ','GWh');
ib=size(buntot,1);
for i=1:ib,
  if antal(i)>0,
    fprintf(fid,'%12s\t%4i',buntot(i,:),antal(i));
    fprintf(fid,'\t%i\t%5.1f\t%5.1f',levyear(i),meanburn(i),garburn(i));
    fprintf(fid,'\t%5i\t%5i\t%6i\n',round(uttag(i)*1000),round(garut(i)*1000),round(restsek(i)*1000));
  end
end
fprintf(fid,'\n');
fprintf(fid,'%12s\t%4i%33i\t%5i\t%9.3f','Totalt:',sum(antal),round(sum(uttag)*1000),round(sum(garut)*1000),sum(restsek)*1000);
fprintf(fid,'\n');
fprintf(fid,'\n');
if clos==1,
  fclose(fid);
end
