function verify_table(verfil)

load(verfil)

k=char(ones(length(qrel)+1,1)*'  ');
f_polca_list=strvcat('File',f_polca_list);
dat=strvcat('Datum',dat);
qrel=strvcat('Qrel',num2str(qrel','%4.1f'));
hc=strvcat('HC',num2str(hc'));
drmeas=strvcat('Drmeas', num2str(drmeas','%1.2f'));
fdms=strvcat('Fdmeas', num2str(fdms','%1.2f'));
stdmeas=strvcat('stdmeas',num2str(stdmeas','%1.2f'));
modord=strvcat('modord',num2str(modord'));
drmstab=strvcat('Drmstab',num2str(drmstab','%1.2f'));
fdmstab=strvcat('fdmstab',num2str(fdmstab','%1.2f'));

racsfil='MeasFile';
for i=1:size(racsfil_list,1)
  isep=find(racsfil_list(i,:)=='/');
  racsfil=strvcat(racsfil,racsfil_list(i,isep(end-1)+1:end));
end

m=[f_polca_list, k, dat, k, qrel, k, hc, k, drmeas, k, fdms, k, stdmeas, k, modord, k, drmstab, k, fdmstab, k, racsfil];

verfiltab=strrep(verfil,'.mat','.tab');
fid=fopen(verfiltab,'w');
for i=1:size(m,1);
  fprintf(fid,m(i,:));
  fprintf(fid,'\n');
end
fclose(fid);

%diary(verfiltab)
%disp(m)
%disp('\n')
%disp(verfil)
%diary off

