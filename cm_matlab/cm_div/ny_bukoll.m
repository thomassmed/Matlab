%@(#)   ny_bukoll.m 1.2	 02/06/05     08:23:21
%
%ny_bukoll(laddafil,distfil)
% Kontroll av LADDA:s härd mot BOCFIL
%läs in härdinventariefil från LADDA och BOC-fil
% Programmet konverterar infilen till unixformat.
function ny_bukoll(laddafil,distfil)
dosfix=['!dos2unix ',laddafil,' laddafil.ux'];
eval(dosfix);
laddafil='laddafil.ux'
fid=fopen(laddafil,'r');
line=fgetl(fid);
ladda_asy=[];
ladda_r=[];
ladda_k=[];
while line ~= -1
  i=findstr(line,'  ');
  ii=find(line==32);
  if ~isempty(i)
    asy='      ';
  else
    asy=line(ii(1)+1:ii(2)-1);
    asy=[asy setstr(32*ones(1,6-length(asy)))];
  end
  r=str2num(line(ii(2)+1:ii(3)-1));
  k=str2num(line(ii(3)+1:length(line)));
  ladda_asy=[ladda_asy;asy];
  ladda_r=[ladda_r;r];
  ladda_k=[ladda_k;k];
  line=fgetl(fid);
end
!rm laddafil.ux
%
%   Läs filen från POLCA
%
[polca_asy,mminj,konrod]=readdist7(distfil,'asyid');
[crid]=readdist7(distfil,'crid');
yx=knum2cpos(1:size(polca_asy,1),mminj);
crpos=crnum2crpos(1:length(konrod),mminj);
polca_r=[yx(:,1);crpos(:,1)];
polca_k=[yx(:,2);crpos(:,2)];
polca_asy=[polca_asy;crid];
err=find(max((ladda_asy-polca_asy)')');
for i=1:length(err)
  fprintf('\n%s  %s  %d  %d',ladda_asy(err(i),:),polca_asy(err(i),:),polca_r(err(i)),polca_k(err(i)));
end
fprintf(1,'\n\nTotalt %d skillnader mellan LADDA och POLCA\n\n',length(err));
