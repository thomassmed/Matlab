%@(#)   testa_om_infil.m 1.1	 05/07/13     10:29:43
%
%function infi=testa_om_infil(fil)
function infi=testa_om_infil(fil)
fid=fopen(fil,'r');
rad=fgetl(fid);
rad=fgetl(fid);
if length(rad)<1, rad=' ';end
if strcmp(rad(1:1),'P')|strcmp(rad(1:1),'S')|strcmp(rad(1:1),'C') 
   infi=1;
else 
   infi=0;
end
fclose(fid);
