%@(#)   readsepareg.m 1.1	 95/04/03     09:36:24
%
function separeg=readsepareg(fil)
fid=fopen(fil,'r');
rad=fgetl(fid);
while isstr(rad),
  if rad(1)=='%',
   % do nothing
  else
    separeg=[separeg;sscanf(rad,'%i')];
  end
  rad=fgetl(fid);
end
