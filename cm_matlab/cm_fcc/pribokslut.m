%@(#)   pribokslut.m 1.3	 04/09/01     12:03:03
%
function pribokslut(buntot,antal,levyear,anskcost,restsek,fil,staton);
if nargin<6,
  fil='bokslut.lis';
  disp('Restvalue will be printed on bokslut.lis');
end
if isstr(fil),
  fid=fopen(fil,'w');
  clos=1;
else
  fid=fil;
  clos=0;
end
if nargin>6,
  fprintf(fid,'\n');
  fprintf(fid,'\t%s',staton);
  fprintf(fid,'\n');
end
if size(restsek,2)==2,
  restsek=restsek(:,1);
end
fprintf(fid,'\n');
fprintf(fid,'%12s\t%s\t%s\t%11s\t%3s','Buntyp','Antal','Lev.','Anskaffn.','F');
sme_oe(fid);
fprintf(fid,'%s\t%7s','rbrukn','Restv');
ae(fid);fprintf(fid,'%s','rde');
fprintf(fid,'\n');
fprintf(fid,'%12s\t%s\t%s','      ','     ',' ');
aa(fid);
fprintf(fid,'%s\t%11s\t%11s\t%11s\t%11s\t%11s\n','r',' MSEK',' MSEK',' MSEK');
ib=size(buntot,1);
for i=1:ib,
  if antal(i)>0,
    fprintf(fid,'\n%12s\t%4i',buntot(i,:),antal(i));
    fprintf(fid,'\t%i\t%11.6f\t%11.6f\t%11.6f',levyear(i),anskcost(i),anskcost(i)-restsek(i),restsek(i));
  end
end
fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'%12s\t%4i\t\t%11.6f\t%11.6f\t%11.6f','Totalt:',sum(antal),sum(anskcost),sum(anskcost-restsek),sum(restsek));
fprintf(fid,'\n');
fprintf(fid,'\n');
if clos==1,
  fclose(fid);
end
