%function sdmsum(sumfil,cnums,infil);
function sdmsum(sumfil,cnums,infil);
tx=readtextfile(infil);
i=bucatch('SDMDIS',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
refdistfile=t(7:length(t));
i=bucatch('COLREF',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
kref=str2num(t(7:length(t)));
i=bucatch('MINSDM',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
min=str2num(t(7:length(t)));
i=bucatch('PRIFIL',tx(:,1:6));
[t,n]=sscanf(tx(i,:),'%s');
printfile=t(7:length(t));
fid=fopen(printfile,'w');
sum=sum2mlab(sumfil);
[sdm,mminj]=readdist(refdistfile,'sdm');
sdm=9*ones(1,length(sdm));
ind=1;
for i=1:size(cnums,1)
%  if (ind/65)==round(ind/65),fprintf(fid,'\f\n');end
%  if ind==1 | (ind/65)==round(ind/65),
  if ind==1
    fprintf(fid,'Sammanfattning av avstängningsmarginalberäkningar\n');
    fprintf(fid,'-------------------------------------------------\n\n');
    fprintf(fid,'Kall referensnivå: %7.5f\n\n',kref); 
    fprintf(fid,'Drivdon  Grannstav  keff    ASM\n\n');
  end
  marg=100*(kref-sum(14,i))/sum(14,i);
  dd=crnum2crpos(cnums(i,1),mminj);
  nei=crnum2crpos(cnums(i,2),mminj);
  ind=ind+1;
  if i>1,if cnums(i-1,1)~=cnums(i,1),fprintf(fid,'\n%s',setstr(45*ones(1,51))...
   );ind=ind+1;end,end
  fprintf(fid,'\n%4s%9s%12.5f%7.2f',crpos2axis(dd,0),...
   crpos2axis(nei,0),sum(14,i),marg);
  if marg<min,fprintf(fid,'   **** Varning ****');end
  if marg<sdm(cnums(i,1)),sdm(cnums(i,1))=marg;end
%  if marg<sdm(cnums(i,2)),sdm(cnums(i,2))=marg;end
end
fprintf(fid,'\n---------------  Slut på utskrift  ----------------');
writedist(refdistfile,'sdm',sdm);
fclose(fid);
