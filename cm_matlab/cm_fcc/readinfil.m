%@(#)   readinfil.m 1.4	 06/02/10     10:52:15
%
function [DISTFIL,MASFIL,skbfil,CYCNAM]=readinfil(infil)
MASFIL=[];                                                      % Obsolete
fid=fopen(infil,'r');
rad=fgetl(fid);
ir=find(rad==' ');
id=1;
DISTFIL=rad(1:ir(1)-1);
CYCNAM=remblank(rad(ir(1)+1:length(rad)));
while isstr(rad),
  rad=fgetl(fid);
  ir=find(rad==' ');
  if length(ir)==0, skbfil=remblank(rad);break;end
  if length(find(rad(ir(1):length(rad))))==0,
     skbfil=remblank(rad);break;
  end
  id=id+1;
  i=readdist7(rad(1:ir(1)-1));
  if i~=-1, MASFIL=rad(1:ir(1)-1);break;end
  DISTFIL=str2mat(DISTFIL,rad(1:ir(1)-1));
  CYCNAM=str2mat(CYCNAM,remblank(rad(ir(1)+1:length(rad))));
end  
fclose(fid);
