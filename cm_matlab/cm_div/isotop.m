%@(#)   isotop.m 1.6	 10/08/04     11:00:59
%
% isotop('eocfil.dat')
% distributioner som måste finnas: history och Pu238
% Programmet körs på eoc-filen efter varje cykel. Utdata från programmet används
% som underlag för isotop-uppdatering i Safeguard. 
function isotop(eocfil)
%Molmassa och avogadros k
avo=6.022*10^23;
Mu235=235;
Mu236=236;
Mu238=238;
Mpu238=238;
Mpu239=239;
Mpu240=240;
Mpu241=241;
Mpu242=242;
%från polca7
u235=readdist7(eocfil,'U235');
u236=readdist7(eocfil,'U236');
u238=readdist7(eocfil,'U238');
pu238=readdist7(eocfil,'PU238');
pu239=readdist7(eocfil,'PU239');
pu240=readdist7(eocfil,'PU240');
pu241=readdist7(eocfil,'PU241');
pu242=readdist7(eocfil,'PU242');
burnup=readdist7(eocfil,'burnup').*1000;
asyid=readdist7(eocfil,'asyid');
fudens=readdist7(eocfil,'fudens')./1000;

% omvandling atomer/cm3 till g(iso)/g(U)
% (n(iso)/cm3)*(g/mol)/(n(iso)/mol)*1/(g/cm3)
u235=u235.*(Mu235/avo)./(fudens); 
u236=u236.*(Mu236/avo)./(fudens); 
u238=u238.*(Mu238/avo)./(fudens); 
pu238=pu238.*(Mpu238/avo)./(fudens); 
pu239=pu239.*(Mpu239/avo)./(fudens); 
pu240=pu240.*(Mpu240/avo)./(fudens); 
pu241=pu241.*(Mpu241/avo)./(fudens); 
pu242=pu242.*(Mpu242/avo)./(fudens);

% här tar vi medel på varje patron

u235=mean(u235)*100;
u236=mean(u236)*100;
u238=mean(u238)*100;
pu238=mean(pu238)*100;
pu239=mean(pu239)*100;
pu240=mean(pu240)*100;
pu241=mean(pu241)*100;
pu242=mean(pu242)*100;
burnup=mean(burnup); 
% skriva till fil
[pathstr, eocname]=fileparts(eocfil);
prifil=[eocname '.iso'];
fid=fopen(prifil,'w');
fprintf(fid,'\r\n');

for i=1:length(asyid);
fprintf(fid,'%8s,%5.0f,%5.3f,%5.3f,%5.3f,%5.3f,%5.3f,%5.3f,%5.3f,%5.3f\r\n',remblank(asyid(i,:)),burnup(i),u235(i),u236(i),u238(i),pu238(i),pu239(i),pu240(i),pu241(i),pu242(i));
%fprintf(fid,'\n');
end
fclose(fid);


